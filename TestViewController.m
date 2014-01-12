//
//  TestViewController.m
//  GifMessengerReal
//
//  Created by Andy Hin on 1/4/2014.
//  Copyright (c) 2014 Andy Hin. All rights reserved.
//

#import "TestViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "EmoticonTextStorage.h"

@interface TestViewController ()

@end

@implementation TestViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initVideoPlayer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//////////////////////////////////////////////////////////////////////////////////////////

- (void) initVideoPlayer
{
    NSString *videoUrl = @"http://yum.gifsicle.com/8e9b612.mp4";
    
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
    
    
    
 //   NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"like after"];
//    
//    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
//    UIImage *theImage = [UIImage animatedImageWithAnimatedGIFData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://yum.gifsicle.com/8e9b612.gif"]]];
//    textAttachment.image = theImage;
//    textAttachment.bounds = CGRectMake(0, 0, 25, 25);

//    
//    
//    UIImageView *uiimageview = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 25, 25)];
//    [uiimageview setImage:theImage];
//    
//    [self.view addSubview: uiimageview];
//    
//    NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
//    
//    [attributedString replaceCharactersInRange:NSMakeRange(4, 1) withAttributedString:attrStringWithImage];
//
//    [self.textView setAttributedText:attributedString];



    
//    UIView *smallVideoView = [[UIView alloc] initWithFrame:CGRectMake(absPoint.x, absPoint.y, textAttachment.bounds.size.width, textAttachment.bounds.size.height)];
//    [smallVideoView setBackgroundColor:[UIColor redColor]];
//    
//    AVPlayerLayer *smallAVLayer = [AVPlayerLayer playerLayerWithPlayer:self.avPlayer];
//    smallAVLayer.frame = smallVideoView.layer.bounds;
//    [smallVideoView.layer addSublayer:smallAVLayer];
//    
//    [self.view addSubview:smallVideoView];


    /// TODO:
    
    /* 
     
     The best way to implement this is to use a text storage like weinderlich tutorial. On edit, do a regex search for the recognized text i.e: ":facepal-picard" and then replace it with a space characvter " ", and then move the avi player view over the character with the exclusion set.
    
    */
    
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"hello"];
    
    EmoticonTextStorage *textStorage = [EmoticonTextStorage new];
    [textStorage appendAttributedString:attributedString];
    
    CGRect newTextViewRect = CGRectMake(0, 200, self.view.bounds.size.width, 200);
    
    
    // 2. Create the layout manager
    NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
    
    // 3. Create a text container
    CGSize containerSize = CGSizeMake(newTextViewRect.size.width,  CGFLOAT_MAX);
    NSTextContainer *container = [[NSTextContainer alloc] initWithSize:containerSize];
    container.widthTracksTextView = YES;
    [layoutManager addTextContainer:container];
    [textStorage addLayoutManager:layoutManager];
    
    // 4. Create a UITextView
    self.textView = [[UITextView alloc] initWithFrame:newTextViewRect
                                    textContainer:container];
    [self.textView setBackgroundColor:[UIColor purpleColor]];
    
//    self.textView.delegate = self;
    [self.view addSubview:self.textView];
    
    
    // start playing the video
    [self.avPlayer play];    
}

-(void)playerItemDidReachEnd:(NSNotification *)notification
{
    AVPlayerItem *p = [notification object];
    [p seekToTime:kCMTimeZero];
}

@end
