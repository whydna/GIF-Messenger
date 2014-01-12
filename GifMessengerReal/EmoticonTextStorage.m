//
//  EmoticonTextStorage.m
//  GifMessengerReal
//
//  Created by Andy Hin on 1/5/2014.
//  Copyright (c) 2014 Andy Hin. All rights reserved.
//

#import "EmoticonTextStorage.h"

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

- (void)setAttributes:(NSDictionary *)attrs range:(NSRange)range
{
    NSLog(@"setAttributes:%@ range:%@", attrs, NSStringFromRange(range));
    
    [self beginEditing];
    [_backingStore setAttributes:attrs range:range];
    [self edited:NSTextStorageEditedAttributes range:range changeInLength:0];
    [self endEditing];
}

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
    [self applyStylesToRange:extendedRange];
}

- (void)applyStylesToRange:(NSRange)searchRange
{
    UIFontDescriptor* fontDescriptor = [UIFontDescriptor
                                        preferredFontDescriptorWithTextStyle:UIFontTextStyleBody];
    UIFontDescriptor* boldFontDescriptor = [fontDescriptor
                                            fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold];
    UIFont* boldFont =  [UIFont fontWithDescriptor:boldFontDescriptor size: 0.0];
    UIFont* normalFont =  [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    
    
    NSDictionary* boldAttributes = @{ NSFontAttributeName : boldFont };
    NSDictionary* normalAttributes = @{ NSFontAttributeName : normalFont };
    
    
    NSDictionary *emoticonDict = @{@"lol": @"lolgif", @"asdf", @"asdfgif"};
    
    for(NSString *emoticonKey in emoticonDict) {
        NSString *emoticonReplacement = [emoticonDict objectForKey:emoticonKey];
        
        NSString *regexStr = [NSString stringWithFormat:@"\\s(%@)\\s", emoticonKey];
        NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:regexStr
                                                                               options:0
                                                                                 error:nil];
        
        [regex enumerateMatchesInString:[_backingStore string]
                                options:0
                                  range:searchRange
                             usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop)
         {
             NSRange matchRange = [match rangeAtIndex:1];
             
             [self addAttributes:boldAttributes range:matchRange];
             
             if (NSMaxRange(matchRange)+1 < self.length) {
                 [self addAttributes:normalAttributes range:NSMakeRange(NSMaxRange(matchRange)+1, 1)];
             }
         }];

        
        
    }


    
    

    
    
    
//    // 1. create some fonts
//    UIFontDescriptor* fontDescriptor = [UIFontDescriptor
//                                        preferredFontDescriptorWithTextStyle:UIFontTextStyleBody];
//    UIFontDescriptor* boldFontDescriptor = [fontDescriptor
//                                            fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold];
//    UIFont* boldFont =  [UIFont fontWithDescriptor:boldFontDescriptor size: 0.0];
//    UIFont* normalFont =  [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
//    
//    // 2. match items surrounded by asterisks
//    NSString* regexStr = @"(\\*\\w+(\\s\\w+)*\\*)\\s";
//    NSRegularExpression* regex = [NSRegularExpression
//                                  regularExpressionWithPattern:regexStr
//                                  options:0
//                                  error:nil];
//    
//    NSDictionary* boldAttributes = @{ NSFontAttributeName : boldFont };
//    NSDictionary* normalAttributes = @{ NSFontAttributeName : normalFont };
//    
//    // 3. iterate over each match, making the text bold
}
@end