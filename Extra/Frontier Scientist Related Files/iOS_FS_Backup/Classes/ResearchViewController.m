//
//  ResearchViewController.m
//  frontier_scientists
//
//  Created by Bob Torgerson on 7/25/11.
//  Copyright 2011 ARSC. All rights reserved.
//

#import "ResearchViewController.h"
#import "MapViewController.h"
#import "MyMapAnnotations.h"
#import "VideoViewController.h"
#import "DetailViewController.h"

#import <SystemConfiguration/SCNetworkReachability.h>
#include <netinet/in.h>

@implementation ResearchViewController

@synthesize mapView, textView, titleView, item, movies, sciTableView;
@synthesize movieTableView, currentPin, imageView, offlineMapView, eye;

- (void)viewDidLoad
{
		self.mapView.hidden = NO;
		self.offlineMapView.hidden = YES;
		self.mapView.mapType = MKMapTypeStandard;   // also MKMapTypeSatellite or MKMapTypeHybrid
		self.mapView.showsUserLocation = NO;
		self.mapView.delegate = self;
		self.mapView.scrollEnabled = NO;
		self.mapView.zoomEnabled = NO;
	
		self.movieTableView.delegate = self;
	
		self.currentPin = [[MyMapAnnotations alloc] init];
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	NSString *imgFile = [documentsDirectory stringByAppendingPathComponent:[self.item objectForKey:@"research_title"]];
	imgFile = [imgFile stringByAppendingString:@".jpg"];
	imgFile = [imgFile stringByReplacingOccurrencesOfString:@"\n" withString:@""];
	
	NSLog(@"Image File on Research: %@",imgFile);
	
	imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:imgFile]];
	
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 30200)
	
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		[self.textView setFont:[UIFont fontWithName:@"Times New Roman" size:18]];
		[self.textView setText:[item objectForKey:@"text"]];
		self.textView.delegate = self;
		
        [self.titleView setFont:[UIFont fontWithName:@"Times New Roman" size:28]];
    } else {
		[self.textView setFont:[UIFont fontWithName:@"Times New Roman" size:10]];
		[self.textView setText:[item objectForKey:@"text"]];
		self.textView.delegate = self;
		
        if ([[item objectForKey:@"research_title"] length] > 20) {
			[self.titleView setFont:[UIFont fontWithName:@"Times New Roman" size:12]];
		}
	}
	
#endif
	
	[self.titleView setText:[item objectForKey:@"research_title"]];
	// if there is no Internet, I don't think mapView will work
	[self zoomToLocation];
}

- (IBAction)clickedEye:(id)sender
{
	DetailViewController *detailViewController = [[DetailViewController alloc] init];
	[detailViewController setDetailText:[item objectForKey:@"text"]];
	
	[[self navigationController] pushViewController:detailViewController animated:YES];
	[detailViewController release];
	//self.textView.frame = CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height);
	//self.eye.hidden = YES;
	
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (tableView == self.sciTableView) {
		return [[item objectForKey:@"scientists"] count];
	}
	else if (tableView == self.movieTableView) {
		return [[item objectForKey:@"videos"] count];
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (tableView == self.sciTableView) {
		static NSString *MyIdentifier = @"MyIdentifier";
		
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:MyIdentifier reuseIdentifier:MyIdentifier] autorelease];
		}
		
		// Set up the cell
		int storyIndex = [indexPath indexAtPosition: [indexPath length] - 1];
		
		cell.textLabel.font = [UIFont fontWithName:@"Times New Roman" size:20];
		cell.textLabel.text = [[[item objectForKey:@"scientists"] objectAtIndex: storyIndex] objectForKey:@"name"];
		
		return cell;
	}
	else if (tableView == self.movieTableView) {
		static NSString *MyIdentifier = @"MyIdentifier";
	
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:MyIdentifier reuseIdentifier:MyIdentifier] autorelease];
		}
	
		// Set up the cell
		int storyIndex = [indexPath indexAtPosition: [indexPath length] - 1];
	
	
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 30200)
	
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
			cell.textLabel.font = [UIFont fontWithName:@"Times New Roman" size:20];
		} else {
			cell.textLabel.font = [UIFont fontWithName:@"Times New Roman" size:12];
		}	
	
#endif
	
		cell.textLabel.text = [[[item objectForKey:@"videos"] objectAtIndex: storyIndex] objectForKey:@"title"];
	
		return cell;
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (tableView == self.sciTableView) {
		// Do nothing
	}
	else if (tableView == self.movieTableView) {
	// Navigation logic
	int videoIndex = [indexPath indexAtPosition: [indexPath length] - 1];
	
	NSString * vidLink = [[[self.item objectForKey:@"videos"] objectAtIndex:videoIndex] objectForKey:@"download3GP"];
	NSString * youTubeVideo = [[[self.item objectForKey:@"videos"] objectAtIndex:videoIndex] objectForKey:@"utubeurl"];
	NSLog(@"Video Link: %@",vidLink);
	// clean up the link - get rid of spaces, returns, and tabs...
	vidLink = [vidLink stringByReplacingOccurrencesOfString:@"\n" withString:@""];
	youTubeVideo = [youTubeVideo stringByReplacingOccurrencesOfString:@"\n" withString:@""];
	
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 30200)
	
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		VideoViewController *videoViewController = [[VideoViewController alloc] initWithNibName:@"VideoViewController-iPad" bundle:nil];
		[videoViewController setYouTubeName:youTubeVideo];
		[videoViewController setVideoName:vidLink];
		[videoViewController setSaveName:[[[self.item objectForKey:@"videos"] objectAtIndex:videoIndex] objectForKey:@"title"]];
		[[self navigationController] pushViewController:videoViewController animated:YES];
		[videoViewController release];
    } else {
		VideoViewController *videoViewController = [[VideoViewController alloc] init];
		[videoViewController setYouTubeName:youTubeVideo];
		[videoViewController setVideoName:vidLink];
		[videoViewController setSaveName:[[[self.item objectForKey:@"videos"] objectAtIndex:videoIndex] objectForKey:@"title"]];
		[[self navigationController] pushViewController:videoViewController animated:YES];
		[videoViewController release];
	}
	
#endif
	
	/*VideoViewController *videoViewController = [[VideoViewController alloc] init];
	[videoViewController setYouTubeName:youTubeVideo];
	[videoViewController setVideoName:vidLink];
	[videoViewController setSaveName:[[[self.item objectForKey:@"videos"] objectAtIndex:videoIndex] objectForKey:@"title"]];
	[[self navigationController] pushViewController:videoViewController animated:YES];*/
						  
	//storyLink = [storyLink stringByReplacingOccurrencesOfString:@"\n" withString:@""];
	//storyLink = [storyLink stringByReplacingOccurrencesOfString:@"	" withString:@""];
	
	//NSLog(@"link: %@", storyLink);
	// open in Safari
	//HTMLViewController *htmlViewController = [[HTMLViewController alloc] init];
	//[htmlViewController setUrlAddress:storyLink];
	//[[self navigationController] pushViewController:htmlViewController animated:YES];*/
	//[[UIApplication sharedApplication] openURL:[NSURL URLWithString:storyLink]];
	}
}

- (void)zoomToLocation
{
	MKCoordinateRegion zoom;
	CLLocationDegrees lat = [[item objectForKey:@"latitude"] doubleValue];
	CLLocationDegrees lon = [[item objectForKey:@"longitude"] doubleValue];
	NSNumber *lat2 = [[NSNumber alloc] initWithDouble:[[item objectForKey:@"latitude"] doubleValue]];
	NSNumber *lon2 = [[NSNumber alloc] initWithDouble:[[item objectForKey:@"longitude"] doubleValue]];
	[self.currentPin setLatitude:lat2];
	[self.currentPin setLongitude:lon2];
	[lat2 release];
	[lon2 release];
	zoom.center.latitude = lat;
	zoom.center.longitude = lon;
	zoom.span.latitudeDelta = 5.0;
	zoom.span.longitudeDelta = 5.0;
	
	[self.mapView setRegion:zoom animated:YES];
	[self.mapView addAnnotation:self.currentPin]; 
}
// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

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
	[mapView release];
	[textView release]; 
	[titleView release]; 
	[item release]; 
	[movies release]; 
	[movieTableView release]; 
	[currentPin release];
	[imageView release];
    [super dealloc];
}


@end
