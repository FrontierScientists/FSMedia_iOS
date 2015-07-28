//
//  HomeScreenController.m
//  frontier_scientists
//
//  Created by Bob Torgerson on 7/13/11.
//  Copyright 2011 ARSC. All rights reserved.
//

#import "HomeScreenController.h"
#import "AskAScientistViewController.h"
#import "Reachability.h"
#import "frontier_scientistsAppDelegate.h"
#import "HelpViewController.h"
#import <libxml/tree.h>
#import <libxml/parser.h>
#import <libxml/HTMLparser.h>
#import <libxml/xpath.h>
#import <libxml/xpathInternals.h>
#import <SystemConfiguration/SCNetworkReachability.h>
#import <MediaPlayer/MediaPlayer.h>
#import "XMLParser.h"
#import "VideoViewController.h"
#include <netinet/in.h>

@implementation HomeScreenController

@synthesize askAScientistViewController, helpViewController, imageView, progressIndicator,downloaded;
@synthesize topImageView, tempImg, movieTableView, dataArray, movieNameArray, movieMP4Array;
@synthesize movie3GPArray, movieUTubeArray, oncallDict;

-(void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:(BOOL)animated];

	NSFileManager *fileMgr = [NSFileManager defaultManager];
	NSString *documentsDir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
	
	NSString *xmlFile = [documentsDir stringByAppendingString:@"/main.xml"];
	
	NSDate *fileDate = [[fileMgr attributesOfItemAtPath:xmlFile error:NULL] fileModificationDate];
	NSTimeInterval between = [fileDate timeIntervalSinceNow];
	
	NSLog(@"Difference: %f",between);
	
	BOOL truth = [fileMgr fileExistsAtPath:xmlFile];
	NSLog(@"%d",truth);
	
	// If time since last starting the app was less than a day,
	// don't download anything
	if ((between > -86400.0) && (between != 0.0)) {
		NSString *imgFile = [documentsDir stringByAppendingPathComponent:@"ScientistOnCall.jpg"];
		imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:imgFile]];
		self.movieNameArray = [[NSMutableArray alloc] init];
		self.movieMP4Array = [[NSMutableArray alloc] init];
		self.movie3GPArray = [[NSMutableArray alloc] init];
		self.movieUTubeArray = [[NSMutableArray alloc] init];
		
		[self choosePicture];
		
		frontier_scientistsAppDelegate *appDelegate = (frontier_scientistsAppDelegate *)[[UIApplication sharedApplication] delegate];
		self.dataArray = [appDelegate appData];
		self.oncallDict = [appDelegate oncall];
		
		[NSThread detachNewThreadSelector:@selector(populateVideoTable) toTarget:self withObject:nil];
	}
	else if ([fileMgr fileExistsAtPath:xmlFile]) {
		NSString *imgFile = [documentsDir stringByAppendingPathComponent:@"ScientistOnCall.jpg"];
		imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:imgFile]];
		self.movieNameArray = [[NSMutableArray alloc] init];
		self.movieMP4Array = [[NSMutableArray alloc] init];
		self.movie3GPArray = [[NSMutableArray alloc] init];
		self.movieUTubeArray = [[NSMutableArray alloc] init];
		
		[self choosePicture];
		
		frontier_scientistsAppDelegate *appDelegate = (frontier_scientistsAppDelegate *)[[UIApplication sharedApplication] delegate];
		self.dataArray = [appDelegate appData];
		self.oncallDict = [appDelegate oncall];
		
		[NSThread detachNewThreadSelector:@selector(populateVideoTable) toTarget:self withObject:nil];
	}
	else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Internet Connection Available" message:@"Frontier Scientists Needs an Active Internet Connection For Its First Use" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	/*else if ([self connectedToNetwork]) {
	 self.tabBarController.view.hidden = YES;
	 tempImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nlights.jpg"]];
	 tempImg.frame = [[(frontier_scientistsAppDelegate*)[[UIApplication sharedApplication] delegate] window] frame];
	 [[(frontier_scientistsAppDelegate*)[[UIApplication sharedApplication] delegate] window] addSubview:tempImg];
	 [[(frontier_scientistsAppDelegate*)[[UIApplication sharedApplication] delegate] window] addSubview:self.progressIndicator];
	 
	 [NSThread detachNewThreadSelector:@selector(startBackground) toTarget:self withObject:nil];
	 
	 self.downloaded = YES;
	 self.movieNameArray = [[NSMutableArray alloc] init];
	 self.movieMP4Array = [[NSMutableArray alloc] init];
	 self.movie3GPArray = [[NSMutableArray alloc] init];
	 self.movieUTubeArray = [[NSMutableArray alloc] init];
	 
	 [self choosePicture];
	 
	 [NSThread detachNewThreadSelector:@selector(populateVideoTable) toTarget:self withObject:nil];*/
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.movieTableView.delegate = self;
    [self.movieTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
}

- (void)populateVideoTable {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	[self performSelectorOnMainThread:@selector(parseDoc) withObject:nil waitUntilDone:NO];
	[pool release];
}

- (void)parseDoc {
	if ([self.dataArray count] == 0)
		[self startParsing];
	
	int i = 0;
	int j = 0;

	while (i < [self.dataArray count]) {
		j = 0;
		while (j < [[[self.dataArray objectAtIndex:i] objectForKey:@"videos"] count]) {
			[self.movieNameArray addObject:[[[[self.dataArray objectAtIndex:i] objectForKey:@"videos"] objectAtIndex:j] objectForKey:@"title"]];
			//[self.movieMP4Array addObject:[[[[self.dataArray objectAtIndex:i] objectForKey:@"videos"] objectAtIndex:j] objectForKey:@"downloadMP4"]];
			[self.movieMP4Array addObject:[[[[self.dataArray objectAtIndex:i] objectForKey:@"videos"] objectAtIndex:j] objectForKey:@"download3GP"]];
			//[self.movie3GPArray addObject:[[[[self.dataArray objectAtIndex:i] objectForKey:@"videos"] objectAtIndex:j] objectForKey:@"download3GP"]];
			[self.movieUTubeArray addObject:[[[[self.dataArray objectAtIndex:i] objectForKey:@"videos"] objectAtIndex:j] objectForKey:@"utubeurl"]];
			j++;
		}
		i++;
	}
	[self.movieTableView reloadData];
}

- (void)startBackground {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	[self performSelectorOnMainThread:@selector(downloadXMLFile) withObject:nil waitUntilDone:YES];
	[tempImg removeFromSuperview];
	[progressIndicator removeFromSuperview];
	self.tabBarController.view.hidden = NO;
	[pool release];
}

- (void)choosePicture {
	NSDate *today = [[NSDate alloc] init];
	NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	
	NSDateComponents *weekdayComp = [cal components:NSWeekdayCalendarUnit fromDate:today];
	int weekday = [weekdayComp weekday] - 1;
	
	NSString *imageFile = [NSString stringWithFormat:@"%d.jpg",weekday];
	topImageView.image = [UIImage imageNamed:imageFile];

	[today release];
	[cal release];
}

- (UIActivityIndicatorView *)progressIndicator {
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
}	

/*- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}*/


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	return [[[self.dataArray objectAtIndex:section] objectForKey:@"videos"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *MyIdentifier = @"MyIdentifier";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier]; //forIndexPath:indexPath];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:MyIdentifier reuseIdentifier:MyIdentifier] autorelease];
	}
	// Set up the cell
    //Find where we are in the current section
	int storyIndex = [indexPath indexAtPosition: [indexPath length] - 1];
    
    //This will be the number of movies from previous sections that we have to skip over
	int offset = 0;
    //find the number of movies we have to skip over from previous sections
	int count = [indexPath section] - 1;
	while (count >= 0) {
		offset += [[[self.dataArray objectAtIndex:count] objectForKey:@"videos"] count];
		count--;
	}
	
    [[cell textLabel] setText:@"Hello World."];
    if ([[cell textLabel] length] == 0)
        NSLog(@"I better not see this.");
    //NSString *vidName = [self.movieMP4Array objectAtIndex:storyIndex+offset];
    //Skipping past all previous movies, fill the cell with the name of the current movie
    //[self.movieNameArray objectAtIndex:storyIndex+offset];
    //(NSString*)[[[self.dataArray objectAtIndex:indexPath] objectForKey:@"videos"]];
    
    
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 30200)
	
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [cell.textLabel setFont:[UIFont fontWithName:@"Times New Roman" size:22]];
    } else {
        [cell.textLabel setFont:[UIFont fontWithName:@"Times New Roman" size:12]];
	}
	
#endif
	


	return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return [self.dataArray count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return [[self.dataArray objectAtIndex:section] objectForKey:@"research_title"];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	// Navigation logic
	
	int videoIndex = [indexPath indexAtPosition: [indexPath length] - 1];
	
	int offset = 0;
	int count = [indexPath section] - 1;
	
	while (count >= 0) {
		offset += [[[self.dataArray objectAtIndex:count] objectForKey:@"videos"] count];
		count--;
	}
	
	NSString *vidLink = [self.movieMP4Array objectAtIndex:videoIndex+offset];
	NSString *youTubeLink = [self.movieUTubeArray objectAtIndex:videoIndex+offset];

	// clean up the link - get rid of spaces, returns, and tabs...
	vidLink = [vidLink stringByReplacingOccurrencesOfString:@"\n" withString:@""];
	youTubeLink = [youTubeLink stringByReplacingOccurrencesOfString:@"\n" withString:@""];
		
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 30200)
	
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        VideoViewController *videoViewController = [[VideoViewController alloc] initWithNibName:@"VideoViewController-iPad" bundle:nil];
		[videoViewController setYouTubeName:youTubeLink];
		[videoViewController setVideoName:vidLink];
		[videoViewController setSaveName:[self.movieNameArray objectAtIndex:videoIndex+offset]];
		[[self navigationController] pushViewController:videoViewController animated:YES];
    } else {
        VideoViewController *videoViewController = [[VideoViewController alloc] init];
		[videoViewController setYouTubeName:youTubeLink];
		[videoViewController setVideoName:vidLink];
		[videoViewController setSaveName:[self.movieNameArray objectAtIndex:videoIndex+offset]];
		[[self navigationController] pushViewController:videoViewController animated:YES];
	}
	
#endif
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

	NSData *sciImg = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[self.oncallDict objectForKey:@"image"]]];
	appFile = [documentsDirectory stringByAppendingPathComponent:@"ScientistOnCall.jpg"];
	[sciImg writeToFile:appFile atomically:YES];
	imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:appFile]];
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
	frontier_scientistsAppDelegate *appDelegate = (frontier_scientistsAppDelegate *)[[UIApplication sharedApplication] delegate];
	appDelegate.appData = [[parser dataArray] copy];
	appDelegate.mapData = [[parser mpAnnotations] copy];
	
	self.dataArray = [[parser dataArray] copy];
	self.oncallDict = [[parser oncallDict] copy];
	[parser release];
}

- (IBAction)pushScientist:(id)sender {
	internetActive = [self connectedToNetwork];
	NSLog(@"Internet Active: %d",internetActive);
	if (internetActive) {
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 30200)
		
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
			askAScientistViewController = [[AskAScientistViewController alloc] initWithNibName:@"AskAScientistViewController-iPad" bundle:nil];
			askAScientistViewController.brieftext = [self.oncallDict objectForKey:@"oncall_brief"];
			[[self navigationController] pushViewController:askAScientistViewController animated:YES];
			[askAScientistViewController release];
		} else {
			askAScientistViewController = [[AskAScientistViewController alloc] init];
			[[self navigationController] pushViewController:askAScientistViewController animated:YES];
			[askAScientistViewController release];
		}
#endif
	}
	else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Unavailable" message:@"Unable to send an email. \nAborting operation." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}		
}

- (IBAction)pushHelpView:(id)sender {
	helpViewController = [[HelpViewController alloc] init];

	[[self navigationController] pushViewController:helpViewController animated:YES];
	[helpViewController release];
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

NSDictionary *DictionaryForNode(xmlNodePtr currentNode, NSMutableDictionary *parentResult)
{
	NSMutableDictionary *resultForNode = [NSMutableDictionary dictionary];
	
	if (currentNode->name)
	{
		NSString *currentNodeContent =
		[NSString stringWithCString:(const char *)currentNode->name encoding:NSUTF8StringEncoding];
		[resultForNode setObject:currentNodeContent forKey:@"nodeName"];
	}
	
	if (currentNode->content && currentNode->type != XML_DOCUMENT_TYPE_NODE)
	{
		NSString *currentNodeContent =
		[NSString stringWithCString:(const char *)currentNode->content encoding:NSUTF8StringEncoding];
		
		if ([[resultForNode objectForKey:@"nodeName"] isEqual:@"text"] && parentResult)
		{
			currentNodeContent = [currentNodeContent
								  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
			
			NSString *existingContent = [parentResult objectForKey:@"nodeContent"];
			NSString *newContent;
			if (existingContent)
			{
				newContent = [existingContent stringByAppendingString:currentNodeContent];
			}
			else
			{
				newContent = currentNodeContent;
			}
			
			[parentResult setObject:newContent forKey:@"nodeContent"];
			return nil;
		}
		
		[resultForNode setObject:currentNodeContent forKey:@"nodeContent"];
	}
	
	xmlAttr *attribute = currentNode->properties;
	if (attribute)
	{
		NSMutableArray *attributeArray = [NSMutableArray array];
		while (attribute)
		{
			NSMutableDictionary *attributeDictionary = [NSMutableDictionary dictionary];
			NSString *attributeName =
			[NSString stringWithCString:(const char *)attribute->name encoding:NSUTF8StringEncoding];
			if (attributeName)
			{
				[attributeDictionary setObject:attributeName forKey:@"attributeName"];
			}
			
			if (attribute->children)
			{
				NSDictionary *childDictionary = DictionaryForNode(attribute->children, attributeDictionary);
				if (childDictionary)
				{
					[attributeDictionary setObject:childDictionary forKey:@"attributeContent"];
				}
			}
			
			if ([attributeDictionary count] > 0)
			{
				[attributeArray addObject:attributeDictionary];
			}
			attribute = attribute->next;
		}
		
		if ([attributeArray count] > 0)
		{
			[resultForNode setObject:attributeArray forKey:@"nodeAttributeArray"];
		}
	}
	
	xmlNodePtr childNode = currentNode->children;
	if (childNode)
	{
		NSMutableArray *childContentArray = [NSMutableArray array];
		while (childNode)
		{
			NSDictionary *childDictionary = DictionaryForNode(childNode, resultForNode);
			if (childDictionary)
			{
				[childContentArray addObject:childDictionary];
			}
			childNode = childNode->next;
		}
		if ([childContentArray count] > 0)
		{
			[resultForNode setObject:childContentArray forKey:@"nodeChildArray"];
		}
	}
	
	return resultForNode;
}

NSArray *PerformXPathQuery(xmlDocPtr doc, NSString *query)
{
    xmlXPathContextPtr xpathCtx; 
    xmlXPathObjectPtr xpathObj; 
	
    /* Create xpath evaluation context */
    xpathCtx = xmlXPathNewContext(doc);
    if(xpathCtx == NULL)
	{
		NSLog(@"Unable to create XPath context.");
		return nil;
    }
    
    /* Evaluate xpath expression */
    xpathObj = xmlXPathEvalExpression((xmlChar *)[query cStringUsingEncoding:NSUTF8StringEncoding], xpathCtx);
    if(xpathObj == NULL) {
		NSLog(@"Unable to evaluate XPath.");
		return nil;
    }
	
	xmlNodeSetPtr nodes = xpathObj->nodesetval;
	if (!nodes)
	{
		NSLog(@"Nodes was nil.");
		return nil;
	}
	
	NSMutableArray *resultNodes = [NSMutableArray array];
	for (NSInteger i = 0; i < nodes->nodeNr; i++)
	{
		NSDictionary *nodeDictionary = DictionaryForNode(nodes->nodeTab[i], nil);
		if (nodeDictionary)
		{
			[resultNodes addObject:nodeDictionary];
		}
	}
	
    /* Cleanup */
    xmlXPathFreeObject(xpathObj);
    xmlXPathFreeContext(xpathCtx); 
    
    return resultNodes;
}

NSArray *PerformHTMLXPathQuery(NSData *document, NSString *query)
{
    xmlDocPtr doc;
	
    /* Load XML document */
	doc = htmlReadMemory([document bytes], [document length], "", NULL, HTML_PARSE_NOWARNING | HTML_PARSE_NOERROR);
	
    if (doc == NULL)
	{
		NSLog(@"Unable to parse.");
		return nil;
    }
	
	NSArray *result = PerformXPathQuery(doc, query);
    xmlFreeDoc(doc); 
	
	return result;
}

NSArray *PerformXMLXPathQuery(NSData *document, NSString *query)
{
    xmlDocPtr doc;
	
    /* Load XML document */
	doc = xmlReadMemory([document bytes], [document length], "", NULL, XML_PARSE_RECOVER);
	
    if (doc == NULL)
	{
		NSLog(@"Unable to parse.");
		return nil;
    }
	
	NSArray *result = PerformXPathQuery(doc, query);
    xmlFreeDoc(doc); 
	
	return result;
}

- (void) viewWillDisappear:(BOOL)animated
{
	NSLog(@"View did disappear!");
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    self.imageView = nil;
	self.topImageView = nil;
	self.askAScientistViewController = nil;
	self.helpViewController = nil;
	
}


- (void)dealloc {
	[askAScientistViewController release];
	[helpViewController release];
	[progressIndicator release];
	[imageView release];
	[tempImg release];
	[topImageView release];
	[dataArray release];
	[movieMP4Array release];
	[movie3GPArray release];
	[movieUTubeArray release];
	[movieNameArray release];
	[movieTableView release];
	[oncallDict release];
    [super dealloc];
}


@end
