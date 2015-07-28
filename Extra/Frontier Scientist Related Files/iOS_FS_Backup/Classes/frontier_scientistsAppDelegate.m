//
//  frontier_scientistsAppDelegate.m
//  frontier_scientists
//
//  Created by Bob Torgerson on 7/11/11.
//  Copyright 2011 ARSC. All rights reserved.
//

#import "frontier_scientistsAppDelegate.h"
#import "XMLParser.h"
#import <SystemConfiguration/SCNetworkReachability.h>
#include <netinet/in.h>

@interface UITabBarController (private)
- (UITabBar *)tabBar;
@end

@implementation frontier_scientistsAppDelegate


@synthesize window;
@synthesize tabBarController;
@synthesize navigationController;
@synthesize appData;
@synthesize mapData;
@synthesize oncall;
@synthesize tempImg;


#pragma mark -
#pragma mark Application lifecycle

//- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions {    
  
-(void)applicationDidFinishLaunching:(UIApplication *)application {
	[self.window addSubview:self.tabBarController.view];
    [self.window makeKeyAndVisible];

}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
	NSFileManager *fileMgr = [NSFileManager defaultManager];
	NSString *documentsDir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
	
	NSString *xmlFile = [documentsDir stringByAppendingString:@"/main.xml"];
	
	NSDate *fileDate = [[fileMgr attributesOfItemAtPath:xmlFile error:NULL] fileModificationDate];
	NSTimeInterval between = [fileDate timeIntervalSinceNow];
	
	//BOOL truth = [fileMgr fileExistsAtPath:xmlFile];
	
	// If time since last starting the app was less than a day,
	// don't download anything
	if ((between > -86400.0) && (between != 0.0)) {
		// Do nothing
	}
	else if ([self connectedToNetwork]) {
		self.tabBarController.view.hidden = YES;
		tempImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nlights.jpg"]];
		tempImg.frame = [self.window frame];
		[self.window addSubview:tempImg];
		[self.window addSubview:self.progressIndicator];
		
		[NSThread detachNewThreadSelector:@selector(startBackground) toTarget:self withObject:nil];
	}
	
	/*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark UITabBarControllerDelegate methods

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed {
}
*/

#pragma mark -
#pragma mark Additional Functions

- (UIActivityIndicatorView *)progressIndicator {
	if (_progressIndicator == nil)
	{
		CGRect frame = CGRectMake(self.window.frame.size.width/2-15, self.window.frame.size.height/2-15, 30, 30);
		_progressIndicator = [[UIActivityIndicatorView alloc] initWithFrame:frame];
		[_progressIndicator startAnimating];
		_progressIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
		[_progressIndicator sizeToFit];
		_progressIndicator.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin |
											  UIViewAutoresizingFlexibleRightMargin |
											  UIViewAutoresizingFlexibleTopMargin |
											  UIViewAutoresizingFlexibleBottomMargin);
		
		_progressIndicator.tag = 1;    // tag this view for later so we can remove it from recycled table cells
	}
	return _progressIndicator;
}

- (void)startBackground {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	[self performSelectorOnMainThread:@selector(downloadXMLFile) withObject:nil waitUntilDone:YES];
	[tempImg removeFromSuperview];
	[_progressIndicator removeFromSuperview];
	self.tabBarController.view.hidden = NO;
	[pool release];
}

-(void)downloadXMLFile
{
	NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:@"http://snowy.arsc.alaska.edu/frontierscientists/test/main.xml"]];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	// the path to write file
	NSString *appFile = [documentsDirectory stringByAppendingPathComponent:@"main.xml"];
	
	[data writeToFile:appFile atomically:YES];
	[data release];
	
	[self startParsing];
	
	NSData *sciImg = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[self.oncall objectForKey:@"image"]]];
	appFile = [documentsDirectory stringByAppendingPathComponent:@"ScientistOnCall.jpg"];
	[sciImg writeToFile:appFile atomically:YES];
}

-(void)startParsing
{
	NSString *documentsDir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
	NSString *xmlFile = [documentsDir stringByAppendingString:@"/main.xml"];
	NSData *xmlData = [[NSData alloc] initWithContentsOfFile:xmlFile]; 
	
	XMLParser *parser = [[XMLParser alloc] init];
	[parser parseXMLData:xmlData];
	[xmlData release];
	
	// Add copy of Research data from XML Parser to global variable in frontier_scientist App Delegate
	self.appData = [[parser dataArray] copy];
	self.mapData = [[parser mpAnnotations] copy];
	self.oncall = [[parser oncallDict] copy];

	[parser release];
}

- (BOOL) connectedToNetwork
{
    // Create zero addy
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
	
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
	
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
	
    if (!didRetrieveFlags)
    {
        printf("Error. Could not recover network reachability flags\n");
        return 0;
    }
	
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    return (isReachable && !needsConnection) ? YES : NO;
}


#pragma mark -
#pragma mark Memory management

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
	[navigationController release];
    [tabBarController release];
    [window release];
    [super dealloc];
}

@end

