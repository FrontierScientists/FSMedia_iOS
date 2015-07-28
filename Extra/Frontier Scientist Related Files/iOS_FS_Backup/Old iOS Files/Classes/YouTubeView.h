//
//  YouTube.h
//  frontier_scientists
//
//  Created by Bob Torgerson on 11/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface YouTubeView : UIWebView {
	
}

- (YouTubeView*)initWithStringAsURL:(NSString*)urlString frame:(CGRect)frame;

- (void)webView:(UIWebView *)YouTubeView didFailLoadWithError:(NSError *)error;

@end
