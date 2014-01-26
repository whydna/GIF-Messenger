//
//  EmoticonTextStorage.h
//  GifMessengerReal
//
//  Created by Andy Hin on 1/5/2014.
//  Copyright (c) 2014 Andy Hin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EmoticonDictionary;
@class NSMutableAttributedString;

@interface EmoticonTextStorage : NSTextStorage

@property NSMutableAttributedString *attributedString;

- (id)initWithAttributedString:(NSAttributedString *)attributedString;

@end
