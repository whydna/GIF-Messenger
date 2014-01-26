//
//  EmoticonTextStorage.m
//  GifMessengerReal
//
//  Created by Andy Hin on 1/5/2014.
//  Copyright (c) 2014 Andy Hin. All rights reserved.
//

#import "EmoticonTextStorage.h"
#import "EmoticonDictionary.h"
#import "EmoticonTextAttachment.h"

@implementation EmoticonTextStorage

- (id)initWithAttributedString:(NSAttributedString *)attributedString
{
    if (self = [super init]) {
        [self setAttributedString:[[NSMutableAttributedString alloc] initWithAttributedString:attributedString]];
    }
    return self;
}

- (NSString *)string
{
    return [[self attributedString] string];
}

- (NSDictionary *)attributesAtIndex:(NSUInteger)location effectiveRange:(NSRangePointer)range
{
    return [[self attributedString] attributesAtIndex:location
                             effectiveRange:range];
}

- (void)replaceCharactersInRange:(NSRange)range withString:(NSString *)str
{
    NSLog(@"replaceCharactersInRange:%@ withString:%@", NSStringFromRange(range), str);
    
    [self beginEditing];
    [[self attributedString] replaceCharactersInRange:range withString:str];
    [self edited:NSTextStorageEditedCharacters|NSTextStorageEditedAttributes range:range changeInLength:str.length-range.length];
    [self endEditing];
}

- (void)replaceCharactersInRange:(NSRange)range withAttributedString:(NSAttributedString *)attrStr
{
    NSLog(@"replaceCharactersInRange:%@ withAttributedString:%@", NSStringFromRange(range), attrStr);
    
    [self beginEditing];
    [[self attributedString] replaceCharactersInRange:range withAttributedString:attrStr];
    [self edited:NSTextStorageEditedCharacters|NSTextStorageEditedAttributes range:range changeInLength:attrStr.string.length-range.length];
    [self endEditing];
}

- (void)setAttributes:(NSDictionary *)attrs range:(NSRange)range
{
    NSLog(@"setAttributes:%@ range:%@", attrs, NSStringFromRange(range));
    
    [self beginEditing];
    [[self attributedString] setAttributes:attrs range:range];
    [self edited:NSTextStorageEditedAttributes range:range changeInLength:0];
    [self endEditing];
}

// This gets fired every time the text is edited
-(void)processEditing
{
    [self performReplacementsForRange:[self editedRange]];
    [super processEditing];
}

- (void)performReplacementsForRange:(NSRange)changedRange
{
    // Since changed range only indicates a single character, we extend it to include the entire line here
    NSRange extendedRange = NSUnionRange(changedRange, [[[self attributedString] string] lineRangeForRange:NSMakeRange(changedRange.location, 0)]);
    extendedRange = NSUnionRange(changedRange, [[[self attributedString] string] lineRangeForRange:NSMakeRange(NSMaxRange(changedRange), 0)]);
    
    [self applyEmoticonsToRange:extendedRange];
}

- (void)applyEmoticonsToRange:(NSRange)searchRange
{
    // We need to keep track of how many characters were removed/replaced with emoticons
    // so we can adjust our ranges accordingly.
    __block NSUInteger numCharactersRemoved = 0;
    
    // loop through the emoticon dictionary and try to match each word
    for(NSString *emoticonKeyword in [[EmoticonDictionary singletonInstance] getAllKeywords]) {
        NSURL *emoticonThumbUrl = [[EmoticonDictionary singletonInstance] thumbnailUrlForKeyword:emoticonKeyword];
        
        NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:[NSString stringWithFormat:@"\\s(%@)\\s", emoticonKeyword]
                                                                               options:0
                                                                                 error:nil];
        
        [regex enumerateMatchesInString:[[self attributedString] string]
                                options:0
                                  range:NSMakeRange(searchRange.location, searchRange.length - numCharactersRemoved)
                             usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop) {
                                 // The range of the matched keyword
                                 NSRange matchRange = [match rangeAtIndex:1];
                                 
                                 // remove the keyword from the string and update the counter
                                 [self replaceCharactersInRange:matchRange withString:@""];
                                 numCharactersRemoved += matchRange.length;
                            
                                 // append the emoticon image to the string using the attachment feature for NSAttributedString
                                 EmoticonTextAttachment *textAttachment = [[EmoticonTextAttachment alloc] init];
                                 [textAttachment setEmoticonKeyword:emoticonKeyword];
                                 textAttachment.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:emoticonThumbUrl]];
                                 textAttachment.bounds = CGRectMake(0, 0, 25, 25);

                                 NSAttributedString *attributedString = [NSAttributedString attributedStringWithAttachment:textAttachment];
                                 
                                 [self replaceCharactersInRange:NSMakeRange(matchRange.location, 0)
                                           withAttributedString:attributedString];
                             }];
    }
}

@end