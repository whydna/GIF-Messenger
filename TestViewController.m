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
    [[EmoticonDictionary singletonInstance] addEmoticonWithId:@"OyuvptF" andKeyword:@"lol"];
    
    // Create the message view and display it.
    CGRect messageViewRect = CGRectMake(0, 0, self.view.bounds.size.width, 150);
    self.messageView = [[EmoticonMessageView alloc] initWithFrame:messageViewRect];
    
    [self.view addSubview:self.messageView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
