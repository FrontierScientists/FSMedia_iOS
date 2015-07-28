//
//  ResearchViewController.m
//  FSDemo
//
//  Created by Andrew Clark on 4/2/14.
//  Copyright (c) 2014 Andrew Clark. All rights reserved.
//

#import "ResearchViewController.h"

@interface ResearchViewController ()

@end

@implementation ResearchViewController

@synthesize researchTextLabel;
@synthesize textLabelString;
@synthesize rvcImage;
@synthesize rvcImagePic;
@synthesize textField;
@synthesize textFieldContent;

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
    //self.title = @"Research";
    //researchTextLabel.text = textLabelString;
    
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RiR_lined_iphone_V44px"]];
    [self.view addSubview:backgroundView];
    [self.view sendSubviewToBack:backgroundView];
    
    UIImage *image = [UIImage imageNamed:@"mountainsAndField"];
    [self.rvcImage setImage:image];
    textField.text = textFieldContent;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
