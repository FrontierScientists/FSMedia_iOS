//
//  AskViewController.m
//  FSDemo
//
//  Created by Andrew Clark on 4/4/14.
//  Copyright (c) 2014 Andrew Clark. All rights reserved.
//

#import "AskViewController.h"

@interface AskViewController ()

@end

@implementation AskViewController
@synthesize askTextLabel;
@synthesize textLabelString;

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
	// Do any additional setup after loading the view.
    
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RiR_lined_iphone_V44px"]];
    [self.view addSubview:backgroundView];
    [self.view sendSubviewToBack:backgroundView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    askTextLabel.text = textLabelString;
}

@end
