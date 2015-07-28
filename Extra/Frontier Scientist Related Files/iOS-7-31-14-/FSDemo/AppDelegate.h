//
//  AppDelegate.h
//  FSDemo
//
//  Created by Andrew Clark on 4/2/14.
//  Copyright (c) 2014 Andrew Clark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InitialTableViewController.h"
#import "XMLParser.h"
#import "UpdateHandler.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

-(void)setTimeInterval;
-(void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler NS_AVAILABLE_IOS(7_0);

@property (strong, nonatomic) UIWindow *window;
@property NSUserDefaults *defaults;
@property NSTimeInterval intervalToUpdate;
@property UpdateHandler *updateHandlerInstance;

@end
