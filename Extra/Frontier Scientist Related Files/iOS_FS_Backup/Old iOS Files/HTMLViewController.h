//
//  HTMLViewController.h
//  frontier_scientists
//
//  Created by Bob Torgerson on 7/6/11.
//  Copyright 2011 ARSC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HTMLViewController : UIViewController <UIWebViewDelegate>{
	IBOutlet UIWebView *webView;
	NSString *urlAddress;
	UIActivityIndicatorView *progressIndicator;
}

@property (nonatomic, retain) UIWebView *webView;
@property (nonatomic, retain) NSString *urlAddress;
@property (nonatomic, retain) UIActivityIndicatorView *progressIndicator;

@end
