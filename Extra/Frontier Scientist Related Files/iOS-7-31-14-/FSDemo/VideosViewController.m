//
//  VideosViewController.m
//  FSDemo
//
//  Created by Andrew Clark on 4/2/14.
//  Copyright (c) 2014 Andrew Clark. All rights reserved.
//

#import "VideosViewController.h"

@interface VideosViewController ()

@end

@implementation VideosViewController

@synthesize webViewOutlet;
@synthesize urlString;

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
    self.title = @"Videos";
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *requestedURL = [NSURLRequest requestWithURL:url];
    [webViewOutlet loadRequest:requestedURL];
    
}

//- (VideosViewController *)initWithStringAsURL:(NSString *)urlString frame:(CGRect)frame;
//{
//	if (self = [super init]) {
//		self = [[VideosViewController alloc] initWithFrame:frame];
//		
//		NSString *youTubeVideoHTML = @"<html><head>\
//        <body style=\"margin:0\">\
//        <embed id=\"yt\" src=\"%@\" type=\"application/x-shockwave-flash\" \
//        width=\"%0.0f\" height=\"%0.0f\"></embed>\
//        </body></html>";
//		
//		NSString *html = [NSString stringWithFormat:youTubeVideoHTML, urlString, frame.size.width, frame.size.height];
//		
//		[self loadHTMLString:html baseURL:nil];
//	}
//	return self;
//}
//
//- (void)webView:(UIWebView *)VideosViewController didFailLoadWithError:(NSError *)error
//{
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
//                                                    message:@"Can't connect. Please check connection."
//                                                   delegate:self
//                                          cancelButtonTitle:@"OK"
//                                          otherButtonTitles:nil];
//    [alert show];
//    //need to finish with http://www.youtube.com/watch?v=jjiQiRf9eyc
//}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
