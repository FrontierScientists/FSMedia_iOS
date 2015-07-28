//
//  ArticlesViewController.h
//  FSDemo
//
//  Created by Andrew Clark on 7/7/14.
//  Copyright (c) 2014 Andrew Clark. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArticlesViewController : UIViewController<UIWebViewDelegate>
{
    UIActivityIndicatorView *activityIndicator;
}

@property (weak, nonatomic) IBOutlet UIWebView *webViewOutlet;
@property NSString *urlString;

@property (nonatomic, retain) UIActivityIndicatorView *progressIndicator;

- (UIActivityIndicatorView *)progressIndicator;


@end
