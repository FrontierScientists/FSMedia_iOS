//
//  chooseVideoPlaybackViewController.m
//  FSDemo
//
//  Created by Andrew Clark on 7/8/14.
//  Copyright (c) 2014 Andrew Clark. All rights reserved.
//

#import "chooseVideoPlaybackViewController.h"

@interface chooseVideoPlaybackViewController ()

@end

@implementation chooseVideoPlaybackViewController

@synthesize urlString;

- (IBAction)streamVideo:(id)sender
{
    
}

- (IBAction)downloadHDVideo:(id)sender
{
    
}

- (IBAction)playDownloadedVideo:(id)sender
{
    
}

- (IBAction)deleteVideo:(id)sender
{
    
}


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
    
    UIImage *navBarImage = [UIImage imageNamed:@"RiR_plainyellow_iphone"];
    [self.navigationController.navigationBar setBackgroundImage:navBarImage forBarMetrics:UIBarMetricsDefault];
    
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RiR_lined_iphone_V44px"]];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"RiR_lined_iphone_V44px"]];
    [self.view addSubview:backgroundView];
    [self.view sendSubviewToBack:backgroundView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if([[segue identifier] isEqualToString:@"streamYoutube"])
    {
        streamYoutubeViewController *sytvc = [segue destinationViewController];
        NSLog(@"Choose Video Playback urlString is %@", urlString);
        sytvc.streamingURL = urlString;
    }
}


@end
