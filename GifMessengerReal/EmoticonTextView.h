//
//  EmoticonTextView.h
//  GifMessengerReal
//
//  Created by Andy Hin on 1/20/2014.
//  Copyright (c) 2014 Andy Hin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EmoticonTextStorage;

@interface EmoticonTextView : UITextView

- (id)initWithFrame:(CGRect)frame andAttributedString:(NSAttributedString *)attributedString;
- (NSAttributedString *)attributedString;

@end
