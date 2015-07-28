//
//  frontier_scientistsAppDelegate.h
//  frontier_scientists
//
//  Created by Bob Torgerson on 7/11/11.
//  Copyright 2011 ARSC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface frontier_scientistsAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
    UIWindow *window;
	UINavigationController *navigationController;
    UITabBarController *tabBarController;
	NSMutableArray *appData;
	NSMutableArray *mapData;
	NSMutableDictionary *oncall;
	UIImageView *tempImg;
	UIActivityIndicatorView *_progressIndicator;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, retain) NSMutableArray *appData;
@property (nonatomic, retain) NSMutableArray *mapData;
@property (nonatomic, retain) NSMutableDictionary *oncall;
@property (nonatomic, retain) UIImageView *tempImg;
@property (nonatomic, retain) UIActivityIndicatorView *progressIndicator;

- (UIActivityIndicatorView *)progressIndicator;
-(void)startParsing;
-(BOOL)connectedToNetwork;
@end
