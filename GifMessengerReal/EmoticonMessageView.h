//
//  EmoticonMessageView.h
//  GifMessengerReal
//
//  Created by Andy Hin on 1/22/2014.
//  Copyright (c) 2014 Andy Hin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EmoticonTextView;
@class AVPlayer;
@class AVPlayerItem;

@interface EmoticonMessageView : UIView

@property UIView *videoView;
@property EmoticonTextView *textView;

@property AVPlayer *avPlayer;
@property AVPlayerItem *avPlayerItem;

- (id)initWithFrame:(CGRect)frame andAttributedString:(NSAttributedString *)attributedString shouldDisplayVideo:(BOOL)vid;
- (NSAttributedString *)attributedString;

@end
