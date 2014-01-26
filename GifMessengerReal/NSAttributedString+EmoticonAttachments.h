//
//  NSAttributedString+EmoticonAttachments.h
//  GifMessengerReal
//
//  Created by Andy Hin on 1/26/2014.
//  Copyright (c) 2014 Andy Hin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSAttributedString (EmoticonAttachments)

// Returns all the attachments in the attributedString
- (NSArray *)allAttachments
{
    NSMutableArray *theAttachments = [NSMutableArray array];
    NSRange theStringRange = NSMakeRange(0, [[self attributedString] length]);
    
    if (theStringRange.length > 0)
    {
        unsigned N = 0;
        do
        {
            NSRange theEffectiveRange;
            NSDictionary *theAttributes = [[self attributedString] attributesAtIndex:N longestEffectiveRange:&theEffectiveRange inRange:theStringRange];
            NSTextAttachment *theAttachment = [theAttributes objectForKey:NSAttachmentAttributeName];
            if (theAttachment != NULL)
                [theAttachments addObject:theAttachment];
            N = theEffectiveRange.location + theEffectiveRange.length;
        }
        while (N < theStringRange.length);
    }
    
    return(theAttachments);
}

@end
