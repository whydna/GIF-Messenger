//
//  TestViewController.h
//  GifMessengerReal
//
//  Created by Andy Hin on 1/4/2014.
//  Copyright (c) 2014 Andy Hin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EmoticonMessageView;

@interface TestViewController : UIViewController

@property IBOutlet UIView *inputMessageViewContainer;
@property EmoticonMessageView *inputMessageView;
@property IBOutlet UIView *sentMessageViewContainer;
@property EmoticonMessageView *sentMessageView;

- (IBAction) sendButtonTapped;

@end
