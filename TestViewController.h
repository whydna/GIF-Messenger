//
//  TestViewController.h
//  GifMessengerReal
//
//  Created by Andy Hin on 1/4/2014.
//  Copyright (c) 2014 Andy Hin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EmoticonMessageView;

@interface TestViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property IBOutlet UIView *inputMessageViewContainer;
@property EmoticonMessageView *inputMessageView;

@property IBOutlet UIView *sentMessageViewContainer;
@property EmoticonMessageView *sentMessageView;

@property IBOutlet UITableView *tableView;
// array of NSAttributedStrings. They are the messages that should
// be shown in the table view
@property NSMutableArray *messages;

- (IBAction) sendButtonTapped;

@end
