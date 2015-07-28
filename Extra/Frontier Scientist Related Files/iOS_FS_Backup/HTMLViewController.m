//
//  HTMLViewController.m
//  frontier_scientists
//
//  Created by Bob Torgerson on 7/6/11.
//  Copyright 2011 ARSC. All rights reserved.
//

#import "HTMLViewController.h"


@implementation HTMLViewController

@synthesize webView, urlAddress, progressIndicator;

- (void)viewDidLoad {
	[super viewDidLoad];
	webView.delegate = self;
	[self.view addSubview:self.progressIndicator];
	
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:(BOOL)animated];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[NSThread detachNewThreadSelector:@selector(startBackground) toTarget:self withObject:nil];
}	

- (UIActivityIndicatorView *)progressIndicator {
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

- (void)loadURL
{
	NSURL *url = [NSURL URLWithString:urlAddress];
	
	NSURLRequest *requestObject = [NSURLRequest requestWithURL:url];
	
	[webView loadRequest:requestObject];
	webView.scalesPageToFit = YES;
}

- (void)startBackground {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	[self performSelectorOnMainThread:@selector(loadURL) withObject:nil waitUntilDone:YES];
	[pool release];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	[self.progressIndicator removeFromSuperview];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return YES;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[webView release];
	[urlAddress release];
	[progressIndicator release];
    [super dealloc];
}


@end
