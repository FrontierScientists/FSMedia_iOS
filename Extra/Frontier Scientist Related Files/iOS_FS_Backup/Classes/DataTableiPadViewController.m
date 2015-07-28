    //
//  DataTableiPadViewController.m
//  frontier_scientists
//
//  Created by Bob Torgerson on 11/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DataTableiPadViewController.h"
#import "ResearchViewController.h"
#import "MyMapAnnotations.h"
#import "XMLParser.h"
#import "frontier_scientistsAppDelegate.h"
#import <SystemConfiguration/SCNetworkReachability.h>
#include <netinet/in.h>

@implementation DataTableiPadViewController

@synthesize dataArray, dataTable, progressIndicator;

-(void)viewDidAppear:(BOOL)animated {
	[super viewWillAppear:(BOOL)animated];
	[self.view addSubview:self.progressIndicator];
	frontier_scientistsAppDelegate *appDelegate = (frontier_scientistsAppDelegate *)[[UIApplication sharedApplication] delegate];
	self.dataArray = appDelegate.appData;
	[NSThread detachNewThreadSelector:@selector(startBackground) toTarget:self withObject:nil];
	[dataTable reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)startBackground {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	[self performSelectorOnMainThread:@selector(downloadImages) withObject:nil waitUntilDone:YES];
	[self.progressIndicator removeFromSuperview];
	[pool release];
}

- (void)downloadImages {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	// the path to write file
	for (int i = 0; i < [dataArray count]; i++) {
		NSString *imgFile = [documentsDirectory stringByAppendingPathComponent:[[dataArray objectAtIndex:i] objectForKey:@"research_title"]];
		imgFile = [imgFile stringByAppendingString:@".jpg"];
		imgFile = [imgFile stringByReplacingOccurrencesOfString:@"\n" withString:@""];
		
		if([[NSFileManager defaultManager] fileExistsAtPath:imgFile]) {
			//Do nothing
		}
		else {
			NSString *tempString = [[dataArray objectAtIndex:i] objectForKey:@"image"];
			
			tempString = [tempString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
			NSData *imgData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:tempString]];
			
			[imgData writeToFile:imgFile atomically:YES];
			[imgData release];
		}
	}
	[dataTable reloadData];
}

- (void)parseDoc {
	NSString *documentsDir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
	NSString *xmlFile = [documentsDir stringByAppendingString:@"/main.xml"];
	NSData *data = [[NSData alloc] initWithContentsOfFile:xmlFile]; 
	
	XMLParser *parser = [[XMLParser alloc] init];
	[parser parseXMLData:data];
	[data release];
	self.dataArray = [parser dataArray];

	[dataTable reloadData];
	[parser release];
}

- (UIActivityIndicatorView *)progressIndicator {
	if (progressIndicator == nil)
	{
		CGRect frame = CGRectMake(self.view.frame.size.width/2-15, self.view.frame.size.height/2-15, 30, 30);
		progressIndicator = [[UIActivityIndicatorView alloc] initWithFrame:frame];
		[progressIndicator startAnimating];
		progressIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
		[progressIndicator sizeToFit];
		progressIndicator.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin |
											  UIViewAutoresizingFlexibleRightMargin |
											  UIViewAutoresizingFlexibleTopMargin |
											  UIViewAutoresizingFlexibleBottomMargin);
		
		progressIndicator.tag = 1;    // tag this view for later so we can remove it from recycled table cells
	}
	return progressIndicator;
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



// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return YES;
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [dataArray count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    int storyIndex = [indexPath indexAtPosition: [indexPath length] - 1];
	if ([[[dataArray objectAtIndex:storyIndex] objectForKey:@"image"] isEqualToString:@""]) {
		//This image is a placeholder, it means that either we have no Internet or this XML file entry didn't have an image.
		//Both mean something is wrong.
		cell.imageView.image = [UIImage imageNamed:@"polarbear.jpeg"];
	}
	else {
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		
		// the path to write file
		NSString *imgFile = [documentsDirectory stringByAppendingPathComponent:[[dataArray objectAtIndex:storyIndex] objectForKey:@"research_title"]];
		imgFile = [imgFile stringByAppendingString:@".jpg"];
		imgFile = [imgFile stringByReplacingOccurrencesOfString:@"\n" withString:@""];
		NSLog(@"Here is the information regarding imgFile: %@",imgFile);
		
		if([[NSFileManager defaultManager] fileExistsAtPath:imgFile]) {
			UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithData:[NSData dataWithContentsOfFile:imgFile]]];
			tempImageView.frame = CGRectMake(0,0,70,44);
			//UIImage *tempImg = [UIImage imageWithData:[NSData dataWithContentsOfFile:imgFile]];
			//tempImg.frame.width = 80;
			//[cell setImage:tempImg];
			//cell.image.contentMode = UIViewContentModeScaleAspectFit;
			//cell.image.size = CGSizeMake(80, cell.image.size.height);
			//[cell setImage:[UIImage imageWithData:[NSData dataWithContentsOfFile:imgFile]]];
			[cell addSubview:tempImageView];
			//cell.imageView = tempImageView;
			[tempImageView release];
		}
		else {
			NSString *tempString = [[dataArray objectAtIndex:storyIndex] objectForKey:@"image"];
			NSLog(@"Here is the image text: %@",tempString);
			
			tempString = [tempString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
			NSData *imgData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:tempString]];
			
			[imgData writeToFile:imgFile atomically:YES];
			[imgData release];
			cell.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:tempString]]];
		}
	}
	UILabel *label = [[UILabel alloc] init];
	label.font = [UIFont fontWithName:@"Times New Roman" size:18];
	label.frame = CGRectMake(80,5,600,35);
	label.text = [[dataArray objectAtIndex:storyIndex] objectForKey:@"research_title"];
	
	[cell addSubview:label];
	[label release];
	
	/*[cell setFont:[UIFont fontWithName:@"Times New Roman" size:18]];
	[cell setText:[[dataArray objectAtIndex: storyIndex] objectForKey:@"research_title"]];*/
	
	//NSLog(@"Movie Count: %d",[[[dataArray objectAtIndex:storyIndex] objectForKey:@"vid_links"] count]);
	//NSLog(@"Movie Links: %@",[[[dataArray objectAtIndex:storyIndex] objectForKey:@"vid_links"] objectAtIndex:0]);
	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	// Navigation logic
	int researchIndex = [indexPath indexAtPosition:[indexPath length] -1];
	
	ResearchViewController *researchViewController = [[ResearchViewController alloc] initWithNibName:@"ResearchViewController-iPad" bundle:nil];
	[researchViewController setItem:[self.dataArray objectAtIndex:researchIndex]];
	
	[[self navigationController] pushViewController:researchViewController animated:YES];
	[researchViewController release];
	
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
	[dataArray release];
	[dataTable release];
	[progressIndicator release];
    [super dealloc];
}


@end

