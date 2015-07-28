//
//  streamYoutubeViewController.m
//  FSDemo
//
//  Created by Andrew Clark on 7/8/14.
//  Copyright (c) 2014 Andrew Clark. All rights reserved.
//

#import "streamYoutubeViewController.h"

@interface streamYoutubeViewController ()

@end

@implementation streamYoutubeViewController

@synthesize webViewOutlet;
@synthesize streamingURL;

- (IBAction)back:(id)sender
{
    [webViewOutlet goBack];
}

- (IBAction)forward:(id)sender
{
    [webViewOutlet goForward];
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
    
    //self.title = @"Videos";
    
    NSLog(@"Stream Youtube streamingURL is %@", streamingURL);
    
    [webViewOutlet setDelegate:self];
    
    NSURL *url = [NSURL URLWithString:streamingURL];
    NSURLRequest *requestedURL = [NSURLRequest requestWithURL:url];
    NSLog(@"It should be loading...");
    [webViewOutlet loadRequest:requestedURL];
    
    webViewOutlet.scalesPageToFit = YES;
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [activityIndicator startAnimating];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [activityIndicator stopAnimating];
    
    /*
    if(webViewOutlet.isLoading)
    {
        NSLog(@"It says it's loading...");
    }*/
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
