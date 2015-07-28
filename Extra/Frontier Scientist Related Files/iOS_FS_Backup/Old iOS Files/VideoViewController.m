//
//  VideoViewController.m
//  frontier_scientists
//
//  Created by Bob Torgerson on 6/30/11.
//  Copyright 2011 ARSC. All rights reserved.
//

#import "VideoViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "frontier_scientistsAppDelegate.h"
#import "ASIHTTPRequest.h"
#import "YouTubeView.h"

#import <SystemConfiguration/SCNetworkReachability.h>
#include <netinet/in.h>

@implementation VideoViewController
@synthesize videoName, saveName, youTubeName, selection, progressView;
@synthesize playButton, downloadButton, deleteButton, selectedVidName;

- (IBAction)deleteMovie {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Deleting Movie File..." message:@"Do You Really Want To Delete The Movie File?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete Video",nil];
	[alert show];
	[alert release];
	 
}

- (IBAction)playMovie {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];

	NSString *vidFile = [documentsDirectory stringByAppendingPathComponent:saveName];
	//vidFile = [vidFile stringByAppendingString:@".mp4"];
	vidFile = [vidFile stringByAppendingString:@".mp4"];
	NSURL *myURL = [NSURL fileURLWithPath:vidFile];
	
	MPMoviePlayerController *player = [[MPMoviePlayerController alloc] initWithContentURL:myURL];
	// enable Apple Airplay
	if([player respondsToSelector:@selector(setAllowsAirPlay:)])
	{
		//NSLog(@"Airplay is a gogo?!");
		[player setAllowsAirPlay:YES];
	}
	else {
		//NSLog(@"No airplay for me!!");
	}
	[player play];
	
	MPMoviePlayerViewController *moviePlayer = [[MPMoviePlayerViewController alloc] initWithContentURL:myURL];
	[self presentMoviePlayerViewControllerAnimated:moviePlayer];
	
	[moviePlayer release];
	[player release];
}


/*Stream movie needs to have the else statement fixed to check whether the Internet is off or if the URL to the video is incorrect*/
- (IBAction)streamMovie {
	if ([self connectedToNetwork]) {
		NSURL *myURL = nil;
	
		if (self.videoName) {
			myURL = [[NSURL URLWithString:self.videoName] retain];
		}
		else {
			// This is the wrong placement for this section, need to check for Internet problem before assuming this
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Video URL Not Found" message:@"Provided URL String Does Not Exist!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[alert show];
			[alert release];		
		}

		MPMoviePlayerController *player = [[MPMoviePlayerController alloc] initWithContentURL:myURL];
		if([player respondsToSelector:@selector(setAllowsAirPlay:)])
		{
			[player setAllowsAirPlay:YES];
		}
		else {
			//NSLog(@"No airplay for me!!");
		}
		[player play];
	
		MPMoviePlayerViewController *moviePlayer = [[MPMoviePlayerViewController alloc] initWithContentURL:myURL];
		[self presentMoviePlayerViewControllerAnimated:moviePlayer];
	
		[moviePlayer release];
		[player release];
	}
	else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Unavailable" message:@"Unable to stream videos. \nAborting operation." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
}

- (IBAction)streamYouTube {
	if ([self connectedToNetwork]) {
		//NSLog(@"You Tube Name: %@",self.youTubeName);
		if ([self.youTubeName isEqualToString:@""]) {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Video is in Production" message:@"Check back at a later date!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[alert show];
			[alert release];	
		}
		else {
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 30200)
			
			if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
				[[self navigationController] setNavigationBarHidden:YES animated:NO];
				tabBarFrame = self.tabBarController.view.frame;
				self.tabBarController.view.frame = CGRectMake(0,0,768,1074);
				youTubeView = [[YouTubeView alloc] initWithStringAsURL:self.youTubeName frame:CGRectMake(0,0,768,1024)];
				
				[[self view] addSubview:youTubeView];
				
				closeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
				[closeButton addTarget:self
								action:@selector(closeYouTube:)
					  forControlEvents:UIControlEventTouchDown];
				[closeButton setTitle:@"Close" forState:UIControlStateNormal];
				closeButton.frame = CGRectMake(20, 30, 80, 30);
				[[self view] addSubview:closeButton];
			} else {
				[[self navigationController] setNavigationBarHidden:YES animated:NO];
				tabBarFrame = self.tabBarController.view.frame;
				self.tabBarController.view.frame = CGRectMake(0,0,320,530);
				youTubeView = [[YouTubeView alloc] initWithStringAsURL:self.youTubeName frame:CGRectMake(0,0,320,480)];
				
				[[self view] addSubview:youTubeView];
				
				closeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
				[closeButton addTarget:self
								action:@selector(closeYouTube:)
					  forControlEvents:UIControlEventTouchDown];
				[closeButton setTitle:@"Close" forState:UIControlStateNormal];
				closeButton.frame = CGRectMake(20, 30, 80, 30);
				[[self view] addSubview:closeButton];
			}
#endif
			
		}
	}
	else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Unavailable" message:@"Unable to stream videos. \nAborting operation." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	
}

- (void)closeYouTube:(id)sender {
	[youTubeView removeFromSuperview];
	[youTubeView release];
	[closeButton removeFromSuperview];
	self.tabBarController.view.frame = tabBarFrame;
	[[self navigationController] setNavigationBarHidden:NO animated:NO];
}

/*- (void)downloadVid:(NSData *)data {
	if ([self.selection isEqualToString:@"High"]) {
		ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:self.videoName]];
		self.progressView.hidden = NO;
		//NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:self.videoName]];
		//NSLog(@"Number of Bytes:%d",[data length]);
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		//NSLog(@"%@",documentsDirectory);
		// the path to write file
		NSString *vidFile = [documentsDirectory stringByAppendingPathComponent:saveName];
		vidFile = [vidFile stringByAppendingString:@".mp4"];
		NSLog(@"Save to this location: %@",vidFile);
		[request setDownloadDestinationPath:vidFile];
		[request startAsynchronous];
		//[data writeToFile:vidFile atomically:YES];
		[data release];
	}
	else if ([self.selection isEqualToString:@"Low"]) {
		// This will not work until the .3gp videos are available on the Amazon storage server
		NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[self.videoName stringByReplacingOccurrencesOfString:@".mp4" withString:@".3gp"]]];
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		NSLog(@"%@",documentsDirectory);
		// the path to write file
		NSString *vidFile = [documentsDirectory stringByAppendingPathComponent:saveName];
		vidFile = [vidFile stringByAppendingString:@".3gp"];
		NSLog(@"Save to this location: %@",vidFile);
		[data writeToFile:vidFile atomically:YES];
		[data release];
	}
}*/
 
- (IBAction)downloadHiResMovie {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	NSString *vidFile = [documentsDirectory stringByAppendingPathComponent:saveName];
	//NSLog(@"This is the save name: %@",vidFile);
	vidFile = [vidFile stringByAppendingString:@".mp4"];
	
	[self downloadHiVid];
	/*if ([[NSFileManager defaultManager] fileExistsAtPath:vidFile]) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Movie File Already Exists" message:@"Do You Really Want To Redownload The Movie File?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Download Again",nil];
		[alert show];
		[alert release];
	}
	else {
		[self downloadHiVid];
	}*/
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	if (buttonIndex == 1) {
		NSFileManager *fileMgr = [NSFileManager defaultManager];
		NSString *documentsDir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
		NSString *movieFile = [documentsDir stringByAppendingPathComponent:saveName];
		movieFile = [movieFile stringByAppendingString:@".mp4"];
		[fileMgr removeItemAtPath:movieFile error:nil];
		self.playButton.hidden = YES;
		self.deleteButton.hidden = YES;
		self.downloadButton.hidden = NO;
	}
}

- (void)downloadHiVid {
	if ([self connectedToNetwork]) {
		[self connectedToWiFi];
		if ([self.videoName isEqualToString:@""]) {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Download URL Provided" message:@"Video is not available for download at this time." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[alert show];
			[alert release];
		}
		else {
			self.playButton.hidden = YES;
			CGRect frame = CGRectMake(self.view.frame.size.width/2-112, self.view.frame.size.height/2+15, 220, 30);
			self.progressView = [[UIProgressView alloc] initWithFrame:frame];
			self.progressView.progressViewStyle = UIProgressViewStyleDefault;
			[self.view addSubview:self.progressView];
			
			ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:self.videoName]];
			NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
			NSString *documentsDirectory = [paths objectAtIndex:0];
			
			// the path to write file
			NSString *vidFile = [documentsDirectory stringByAppendingPathComponent:saveName];
			vidFile = [vidFile stringByAppendingString:@".mp4"];
			
			[request setDownloadDestinationPath:vidFile];
			[request setDownloadProgressDelegate:self.progressView];
			[request setDelegate:self];
			[request startAsynchronous];
			[request setDidFinishSelector:@selector(requestDone:)];
		}
	}
	else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Unavailable" message:@"Unable to download videos. \nAborting operation." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}	
}

- (IBAction)downloadLoResMovie {
	[self setSelection:@"Low"];
	[NSThread detachNewThreadSelector:@selector(startBackground) toTarget:self withObject:nil];
	//NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[self.videoName stringByReplacingOccurrencesOfString:@".mp4" withString:@".3gp"]]];
}

- (void)requestDone:(ASIHTTPRequest *)request {
	//NSLog(@"Finished downloading video!");
	//self.progressView.hidden = YES;
	[self.progressView removeFromSuperview];
	self.playButton.hidden = NO;
	self.downloadButton.hidden = YES;
	self.deleteButton.hidden = NO;
}

- (BOOL) connectedToWiFi
{
	SCNetworkReachabilityFlags flags;
	BOOL isReachable = flags & kSCNetworkFlagsReachable;
	BOOL isWWAN = flags & kSCNetworkReachabilityFlagsIsWWAN;
	
	if (isReachable && isWWAN) {
		NSLog(@"This is 3G!");
		return NO;
	}
	else {
		NSLog(@"This is ");
		return YES;
	}
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

-(void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:(BOOL)animated];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	NSString *vidFile = [documentsDirectory stringByAppendingPathComponent:saveName];
	//NSLog(@"This is the save name: %@",vidFile);
	vidFile = [vidFile stringByAppendingString:@".mp4"];
	
	self.selectedVidName.text = saveName;
	
	if ([[NSFileManager defaultManager] fileExistsAtPath:vidFile]) {
		self.playButton.hidden = NO;
		self.deleteButton.hidden = NO;
		self.downloadButton.hidden = YES;
	}
	else {
		self.playButton.hidden = YES;
		self.deleteButton.hidden = YES;
		self.downloadButton.hidden = NO;
	}
}
	
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}

/*- (void)startBackground:(NSData *)data {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	[self performSelectorOnMainThread:@selector(downloadVid:) withObject:data waitUntilDone:NO];
	//[self.progressIndicator removeFromSuperview];
	[pool release];
}*/

/*- (UIActivityIndicatorView *)progressIndicator {
	if (progressIndicator == nil)
	{
		CGRect frame = CGRectMake(self.view.frame.size.width/2-15, self.view.frame.size.height/2-15, 30, 30);
		progressIndicator = [[UIActivityIndicatorView alloc] initWithFrame:frame];
		[progressIndicator startAnimating];
		progressIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
		[progressIndicator sizeToFit];
		progressIndicator.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin |
											  UIViewAutoresizingFlexibleRightMargin |
											  UIViewAutoresizingFlexibleTopMargin |
											  UIViewAutoresizingFlexibleBottomMargin);
		
		progressIndicator.tag = 1;    // tag this view for later so we can remove it from recycled table cells
	}
	return progressIndicator;
}*/	

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[videoName release];
	[saveName release];
	[youTubeName release];
	[selection release];
	//[progressIndicator release];
	[progressView release];
	[selectedVidName release];
    [super dealloc];
}


@end
