//
//  EmoticonMessageView.m
//  GifMessengerReal
//
//  Created by Andy Hin on 1/22/2014.
//  Copyright (c) 2014 Andy Hin. All rights reserved.
//

#import "EmoticonMessageView.h"
#import <AVFoundation/AVFoundation.h>
#import "EmoticonTextView.h"

@implementation EmoticonMessageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Setup and display the video player
        [self initVideoPlayer];
        
        // Setup and display the text view
        self.textView = [[EmoticonTextView alloc] initWithFrame:frame];
        
        // Display the text view
        [self addSubview:self.textView];
    }
    return self;
}

- (void) initVideoPlayer
{
    // initialize the player item
    AVURLAsset *avAsset = [[AVURLAsset alloc] initWithURL:[NSURL URLWithString:videoUrl] options:nil];
    self.avPlayerItem = [AVPlayerItem playerItemWithAsset:avAsset];

    // initialize the player
    self.avPlayer = [[AVPlayer alloc] initWithPlayerItem:self.avPlayerItem];


    // infinitely loop the video

    //prevent the player from pausing at the end
    self.avPlayer.actionAtItemEnd = AVPlayerActionAtItemEndNone;

    // get notified when the video ends so we can replay it
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:[self.avPlayer currentItem]];

    // add the player to the view
    AVPlayerLayer *avLayer = [AVPlayerLayer playerLayerWithPlayer:self.avPlayer];
    avLayer.frame = self.videoView.layer.bounds;
    [self.videoView.layer addSublayer:avLayer];
    
    // start playing the video
    [self.avPlayer play];
    
}

-(void)playerItemDidReachEnd:(NSNotification *)notification
{
    AVPlayerItem *p = [notification object];
    [p seekToTime:kCMTimeZero];
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
