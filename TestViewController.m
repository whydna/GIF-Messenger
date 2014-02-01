//
//  TestViewController.m
//  GifMessengerReal
//
//  Created by Andy Hin on 1/4/2014.
//  Copyright (c) 2014 Andy Hin. All rights reserved.
//

#import "TestViewController.h"
#import "EmoticonDictionary.h"
#import "EmoticonMessageView.h"
#import "EmoticonTextAttachment.h"
#import "NSAttributedString+EmoticonAttachments.h"


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
    
    // Generate the emoticon dictionary
    [[EmoticonDictionary singletonInstance] addEmoticonWithId:@"OyuvptF" andKeyword:@"wtf"];
    [[EmoticonDictionary singletonInstance] addEmoticonWithId:@"9CfmU1q" andKeyword:@"duh"];
    [[EmoticonDictionary singletonInstance] addEmoticonWithId:@"AlxxT1w" andKeyword:@"woah"];
    
    self.messages = [[NSMutableArray alloc] init];
    
    // Create the message view and display it.
    self.inputMessageView = [[EmoticonMessageView alloc] initWithFrame:self.inputMessageViewContainer.bounds
                                                   andAttributedString:nil
                                                    shouldDisplayVideo:NO];
    
    [self.inputMessageViewContainer addSubview:self.inputMessageView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)sendButtonTapped
{
    [self.view endEditing:YES];
    
    [self.messages addObject:[self.inputMessageView attributedString]];
    
    [self.tableView reloadData];
    NSLog(@"send button tapped");
}

// UITableView Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return [self.messages count];
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    self.sentMessageView = [[EmoticonMessageView alloc] initWithFrame:self.sentMessageViewContainer.bounds
    //                                                   andAttributedString:[self.inputMessageView attributedString]
    //                                                    shouldDisplayVideo:YES];
    //
    //    [self.sentMessageViewContainer addSubview:self.sentMessageView];
    
    CGRect messageViewRect = CGRectMake(0, 0, tableView.frame.size.width, 200);
    EmoticonMessageView *messageView = [[EmoticonMessageView alloc] initWithFrame:messageViewRect
                                                              andAttributedString:[self.messages objectAtIndex:indexPath.row]
                                                               shouldDisplayVideo:YES];


    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
    }
    
    [cell.contentView addSubview:messageView];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}

@end
