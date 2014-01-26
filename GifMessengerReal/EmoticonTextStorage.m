//
//  EmoticonTextStorage.m
//  GifMessengerReal
//
//  Created by Andy Hin on 1/5/2014.
//  Copyright (c) 2014 Andy Hin. All rights reserved.
//

#import "EmoticonTextStorage.h"
#import "EmoticonDictionary.h"

@implementation EmoticonTextStorage
{
    NSMutableAttributedString *_backingStore;
}

- (id)init
{
    if (self = [super init]) {
        _backingStore = [NSMutableAttributedString new];
    }
    return self;
}

- (NSString *)string
{
    return [_backingStore string];
}

- (NSDictionary *)attributesAtIndex:(NSUInteger)location
                     effectiveRange:(NSRangePointer)range
{
    return [_backingStore attributesAtIndex:location
                             effectiveRange:range];
}

- (void)replaceCharactersInRange:(NSRange)range withString:(NSString *)str
{
    NSLog(@"replaceCharactersInRange:%@ withString:%@", NSStringFromRange(range), str);
    
    [self beginEditing];
    [_backingStore replaceCharactersInRange:range withString:str];
    [self edited:NSTextStorageEditedCharacters|NSTextStorageEditedAttributes range:range changeInLength:str.length-range.length];
    [self endEditing];
}

- (void)replaceCharactersInRange:(NSRange)range withAttributedString:(NSAttributedString *)attrStr
{
    NSLog(@"replaceCharactersInRange:%@ withAttributedString:%@", NSStringFromRange(range), attrStr);
    
    [self beginEditing];
    [_backingStore replaceCharactersInRange:range withAttributedString:attrStr];
    [self edited:NSTextStorageEditedCharacters|NSTextStorageEditedAttributes range:range changeInLength:attrStr.string.length-range.length];
    [self endEditing];
}

- (void)setAttributes:(NSDictionary *)attrs range:(NSRange)range
{
    NSLog(@"setAttributes:%@ range:%@", attrs, NSStringFromRange(range));
    
    [self beginEditing];
    [_backingStore setAttributes:attrs range:range];
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
    NSRange extendedRange = NSUnionRange(changedRange, [[_backingStore string] lineRangeForRange:NSMakeRange(changedRange.location, 0)]);
    extendedRange = NSUnionRange(changedRange, [[_backingStore string] lineRangeForRange:NSMakeRange(NSMaxRange(changedRange), 0)]);
    
    [self applyEmoticonsToRange:extendedRange];
}

- (void)applyEmoticonsToRange:(NSRange)searchRange
{
    // We need to keep track of how many characters were removed/replaced with emoticons
    // so we can adjust our ranges accordingly.
    __block NSUInteger numCharactersRemoved = 0;
    
    // loop through the emoticon dictionary and try to match each word
    for(NSString *emoticonKey in [[EmoticonDictionary singletonInstance] getAllKeywords]) {
        NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:[NSString stringWithFormat:@"\\s(%@)\\s", emoticonKey]
                                                                               options:0
                                                                                 error:nil];
        
        [regex enumerateMatchesInString:[_backingStore string]
                                options:0
                                  range:NSMakeRange(searchRange.location, searchRange.length - numCharactersRemoved)
                             usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop) {
                                 // The range of the matched keyword
                                 NSRange matchRange = [match rangeAtIndex:1];
                                 
                                 // remove the keyword from the string and update the counter
                                 [self replaceCharactersInRange:matchRange withString:@""];
                                 numCharactersRemoved += matchRange.length;
                            
                                 // append the emoticon image to the string using the attachment feature for NSAttributedString
                                 NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
                                 textAttachment.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[[EmoticonDictionary singletonInstance] thumbnailUrlForKeyword:emoticonKey]]];
                                 textAttachment.bounds = CGRectMake(0, 0, 25, 25);

                                 NSAttributedString *attributedString = [NSAttributedString attributedStringWithAttachment:textAttachment];
                                 
                                 [self replaceCharactersInRange:NSMakeRange(matchRange.location, 0)
                                           withAttributedString:attributedString];
                             }];
    }
}
@end