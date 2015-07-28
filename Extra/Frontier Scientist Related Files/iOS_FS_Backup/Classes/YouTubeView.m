//
//  YouTube.m
//  frontier_scientists
//
//  Created by Bob Torgerson on 11/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "YouTubeView.h"


@implementation YouTubeView

- (YouTubeView *)initWithStringAsURL:(NSString *)urlString frame:(CGRect)frame;
{
	if (self = [super init]) {
		self = [[YouTubeView alloc] initWithFrame:frame];
		
		NSString *youTubeVideoHTML = @"<html><head>\
					<body style=\"margin:0\">\
					<embed id=\"yt\" src=\"%@\" type=\"application/x-shockwave-flash\" \
					width=\"%0.0f\" height=\"%0.0f\"></embed>\
					</body></html>";
		
		NSString *html = [NSString stringWithFormat:youTubeVideoHTML, urlString, frame.size.width, frame.size.height];
		
		[self loadHTMLString:html baseURL:nil];
	}
	return self;
}

- (void)dealloc
{
	[super dealloc];
}


- (void)webView:(UIWebView *)YouTubeView didFailLoadWithError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:@"Can't connect. Please check connection."
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
    //need to finish with http://www.youtube.com/watch?v=jjiQiRf9eyc
}

@end
