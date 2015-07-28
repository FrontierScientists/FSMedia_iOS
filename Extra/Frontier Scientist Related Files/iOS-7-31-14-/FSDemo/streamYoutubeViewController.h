//
//  streamYoutubeViewController.h
//  FSDemo
//
//  Created by Andrew Clark on 7/8/14.
//  Copyright (c) 2014 Andrew Clark. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface streamYoutubeViewController : UIViewController<UIWebViewDelegate>
{
    UIActivityIndicatorView *activityIndicator;
}

@property (weak, nonatomic) IBOutlet UIWebView *webViewOutlet;

@property NSString *streamingURL;

@end
