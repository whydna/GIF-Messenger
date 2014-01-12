//
//  TestViewController.h
//  GifMessengerReal
//
//  Created by Andy Hin on 1/4/2014.
//  Copyright (c) 2014 Andy Hin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AVPlayer;
@class AVPlayerItem;

@interface TestViewController : UIViewController

@property IBOutlet UIView *videoView;
@property UITextView *textView;

@property AVPlayer *avPlayer;
@property AVPlayerItem *avPlayerItem;
//@property BOOL avPlayerIsBuffering;
//@property AVAssetImageGenerator *avImageGenerator;
//@property id avPlaybackObserver;
//@property float avFrameRate;

@end
