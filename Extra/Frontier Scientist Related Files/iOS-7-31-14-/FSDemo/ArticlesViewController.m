//
//  ArticlesViewController.m
//  FSDemo
//
//  Created by Andrew Clark on 7/7/14.
//  Copyright (c) 2014 Andrew Clark. All rights reserved.
//

#import "ArticlesViewController.h"

@interface ArticlesViewController ()

@end

@implementation ArticlesViewController

@synthesize progressIndicator;
@synthesize webViewOutlet;
@synthesize urlString;

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
    
    //Setting the background image for the toolbar programmatically wasn't working (for some reason), so I set it in the interface builder 

    webViewOutlet.delegate = self;
    webViewOutlet.scalesPageToFit = YES;
    NSURL *url = [NSURL URLWithString:self.urlString];
    NSURLRequest *requestedURL = [NSURLRequest requestWithURL:url];
    [webViewOutlet loadRequest:requestedURL];
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIActivityIndicatorView *)progressIndicator
{
    if (progressIndicator == nil)
    {
        CGRect frame = CGRectMake(self.view.frame.size.width/2-15, self.view.frame.size.height/2-15, 30, 30);
        progressIndicator = [[UIActivityIndicatorView alloc] initWithFrame:frame];
        [progressIndicator startAnimating];
        progressIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        [progressIndicator sizeToFit];
        progressIndicator.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin |
                                              UIViewAutoresizingFlexibleRightMargin |
                                              UIViewAutoresizingFlexibleTopMargin |
                                              UIViewAutoresizingFlexibleBottomMargin);
        
        progressIndicator.tag = 1;    // tag this view for later so we can remove it from recycled table cells
    }
    return progressIndicator;
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
