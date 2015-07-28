//
//  VideosViewController.h
//  FSDemo
//
//  Created by Andrew Clark on 4/2/14.
//  Copyright (c) 2014 Andrew Clark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface VideosViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIWebView *webViewOutlet;

@property NSString *urlString;

//- (VideosViewController*)initWithStringAsURL:(NSString*)urlString frame:(CGRect)frame;
//
//- (void)webView:(UIWebView *)VideosViewController didFailLoadWithError:(NSError *)error;
//

@end
