//
//  AppDelegate.m
//  FSDemo
//
//  Created by Andrew Clark on 4/2/14.
//  Copyright (c) 2014 Andrew Clark. All rights reserved.
//

#import "AppDelegate.h"
#import <GoogleMaps/GoogleMaps.h>


@implementation AppDelegate
@synthesize defaults;
@synthesize intervalToUpdate;
@synthesize updateHandlerInstance;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    defaults = [NSUserDefaults standardUserDefaults];
    
    // Override point for customization after application launch.
    [GMSServices provideAPIKey:@"AIzaSyDyci_I7vnaLI6kOkkOOdBiEndguSRGITc"];
    [[UILabel appearance] setFont:[UIFont fontWithName:@"Chalkduster" size:17.0]];
    [[UITextField appearance] setFont:[UIFont fontWithName:@"Chalkduster" size:17.0]];
    [[UITextView appearance] setFont:[UIFont fontWithName:@"Chalkduster" size:17.0]];

    updateHandlerInstance = [[UpdateHandler alloc] init];
    
    [updateHandlerInstance deleteCurrentNotificationsNamed:@"updateAtMidnight"];
    [updateHandlerInstance deleteCurrentNotificationsNamed:@"update"];
    [updateHandlerInstance createUpdateNotification:@"updateAtMidnight"];
    
    [self setTimeInterval];
    [application setMinimumBackgroundFetchInterval:intervalToUpdate];
    
    return YES;
}

-(void)setTimeInterval
{
    NSDate *now =[NSDate date];
    NSDate *dateToUpdate = [now dateByAddingTimeInterval:60];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [calendar setTimeZone:[NSTimeZone timeZoneWithName:@"US/Alaska"]];
    //NSDateComponents *dateComps = [calendar components:(NSDayCalendarUnit) fromDate:[NSDate date]];
    //[dateComps setHour:23];[dateComps setMinute:55];[dateComps setSecond:59];
    //dateToUpdate = [calendar dateFromComponents:dateComps];
    intervalToUpdate = [now timeIntervalSinceDate:dateToUpdate];
}

-(void)applicationDidBecomeActive:(UIApplication *)application
{
    [updateHandlerInstance checkForXmlFile];
    [updateHandlerInstance parseData];
    [updateHandlerInstance checkForUpdates];
}

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    if([[notification.userInfo objectForKey:@"name"] isEqualToString:@"update"] || [[notification.userInfo objectForKey:@"name"] isEqualToString:@"updateAtMidnight"])
    {
        NSLog(@"Notification %@ fired!", [notification.userInfo objectForKey:@"name"]);
    
        [updateHandlerInstance readydownloadSession];
        [updateHandlerInstance.task resume];
        
    }
    if([[notification.userInfo objectForKey:@"name"] isEqualToString:@"update"])
    {
        [updateHandlerInstance deleteCurrentNotificationsNamed:@"update"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"update" object:nil];
    }
}

-(void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler NS_AVAILABLE_IOS(7_0)
{
    [updateHandlerInstance readydownloadSession];
    completionHandler(UIBackgroundFetchResultNewData);
    NSLog(@"Got into fetch.");
    
    // The command "resume" here is misleading, as this actually begins the background action(s) of the session
    [updateHandlerInstance.task resume];
    NSLog(@"Got past resume");
}



@end
