//
//  EmoticonTextView.m
//  GifMessengerReal
//
//  Created by Andy Hin on 1/20/2014.
//  Copyright (c) 2014 Andy Hin. All rights reserved.
//

#import "EmoticonTextView.h"
#import "EmoticonTextStorage.h"

@implementation EmoticonTextView
{
    NSLayoutManager *_layoutManager;
    EmoticonTextStorage *_textStorage;
    NSTextContainer *_textContainer;
}

- (id)initWithFrame:(CGRect)frame
{
    _textStorage = [EmoticonTextStorage new];

    _layoutManager = [[NSLayoutManager alloc] init];
    [_textStorage addLayoutManager:_layoutManager];

    CGSize containerSize = CGSizeMake(frame.size.width, frame.size.height);
    _textContainer = [[NSTextContainer alloc] initWithSize:containerSize];
    _textContainer.widthTracksTextView = YES;

    [_layoutManager addTextContainer:_textContainer];
    
    return  [super initWithFrame:frame textContainer:_textContainer];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
