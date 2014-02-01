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
#import "NSAttributedString+EmoticonAttachments.h"
#import "EmoticonTextAttachment.h"
#import "EmoticonDictionary.h"

@implementation EmoticonMessageView

- (id)initWithFrame:(CGRect)frame andAttributedString:(NSAttributedString *)attributedString shouldDisplayVideo:(BOOL)vid
{
    self = [super initWithFrame:frame];
    
    if (self) {
        // Setup and display the text view
        CGRect textViewFrame = CGRectMake(0, frame.size.height/2, frame.size.width, frame.size.height/2);
        self.textView = [[EmoticonTextView alloc] initWithFrame:textViewFrame andAttributedString:attributedString];
        [self.textView setBackgroundColor:[UIColor yellowColor]];

        // TODO: figure this out
        self.textView.editable = (vid) ? NO : YES;
        
        self.textView.delegate = self;
        [self addSubview:self.textView];
        
        // Setup and display the video
        CGRect videoViewFrame = CGRectMake(0, 0, frame.size.width, frame.size.height/2);
        self.videoView = [[UIView alloc] initWithFrame:videoViewFrame];
        [self.videoView setBackgroundColor:[UIColor greenColor]];
        [self addSubview:self.videoView];
        
        // TODO: figure this out
        if (vid) {
            [self initVideoPlayer];
        }
    }
    
    return self;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(EmoticonTextAttachment *)textAttachment inRange:(NSRange)characterRange
{
    NSString *emoticonKeyword = [textAttachment emoticonKeyword];
    NSURL *mp4URL = [[EmoticonDictionary singletonInstance] mp4UrlForKeyword:emoticonKeyword];
    [self playVideoWithMP4URL:mp4URL];
    
    return YES;
}

- (NSAttributedString *) attributedString
{
    return [self.textView attributedString];
}

- (void) initVideoPlayer
{
    // Setup the video player
    self.avPlayer = [AVPlayer playerWithPlayerItem:nil];
    
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
    
    // Play the first emoticon in the message
    NSArray *attachments = [[self.textView attributedString] allAttachments];
    if ([attachments count] > 0) {
        NSString *firstEmoticonKeyword = [(EmoticonTextAttachment *)[attachments objectAtIndex:0] emoticonKeyword];
        NSURL *mp4URL = [[EmoticonDictionary singletonInstance] mp4UrlForKeyword:firstEmoticonKeyword];

        [self playVideoWithMP4URL:mp4URL];
    }
}

- (void) playVideoWithMP4URL:(NSURL *)mp4URL
{
    // initialize the player item
    AVURLAsset *avAsset = [[AVURLAsset alloc] initWithURL:mp4URL options:nil];
    self.avPlayerItem = [AVPlayerItem playerItemWithAsset:avAsset];
    
    // initialize the player
    [self.avPlayer replaceCurrentItemWithPlayerItem:self.avPlayerItem];

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
