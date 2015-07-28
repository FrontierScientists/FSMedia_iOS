//
//  InitialTableViewController.m
//  FSDemo
//
//  Created by Andrew Clark on 4/2/14.
//  Copyright (c) 2014 Andrew Clark. All rights reserved.
//

#import "InitialTableViewController.h"
#import "XMLParser.h"

@interface InitialTableViewController ()
{
    NSMutableArray *titles;
}

@end

@implementation InitialTableViewController

@synthesize customDisclosureView;
@synthesize customDisclosureImage;
@synthesize camera;
@synthesize itvcParsedData;
@synthesize _responseData;
@synthesize xmlUpdate;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    self.title = @"Frontier Scientists";
    
    xmlUpdate = [[UILocalNotification alloc] init];
    xmlUpdate.fireDate = [NSDate dateWithTimeIntervalSinceNow:60];
    xmlUpdate.repeatInterval = NSMinuteCalendarUnit;
    xmlUpdate.timeZone = [NSTimeZone defaultTimeZone];
    NSMutableDictionary *dummyDict = [[NSMutableDictionary alloc] init];
    [dummyDict setObject:@"FS" forKey:@"key"];
    xmlUpdate.userInfo = dummyDict;
    [[UIApplication sharedApplication] scheduleLocalNotification:xmlUpdate];
    
    [self downloadXMLFile];
    
    //replace the image name string
    UIImage *navBarImage = [UIImage imageNamed:@"RiR_plainyellow_iphone"];
    [self.navigationController.navigationBar setBackgroundImage:navBarImage forBarMetrics:UIBarMetricsDefault];
    
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RiR_lined_iphone_V44px"]];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"RiR_lined_iphone_V44px"]];
    [self.view addSubview:backgroundView];
    [self.view sendSubviewToBack:backgroundView];
    
    titles = [[NSMutableArray alloc] init];
    DataObject *infoObject;

    infoObject = [[DataObject alloc] init];
    infoObject.cellName = @"Research";
    infoObject.info = @"Stuff about research";
    [titles addObject:infoObject];
    
    infoObject = [[DataObject alloc] init];
    infoObject.cellName = @"Videos";
    infoObject.info = @"Cool videos";
    [titles addObject:infoObject];
    
    infoObject = [[DataObject alloc] init];
    infoObject.cellName = @"Map";
    infoObject.info = @"A map";
    [titles addObject:infoObject];
    
    infoObject = [[DataObject alloc] init];
    infoObject.cellName = @"News/Articles";
    infoObject.info = @"Read all about it!";
    [titles addObject:infoObject];
    
    infoObject = [[DataObject alloc] init];
    infoObject.cellName = @"Ask A Scientist";
    infoObject.info = @"S'up, scientists";
    [titles addObject:infoObject];
    
    infoObject = [[DataObject alloc] init];
    infoObject.cellName = @"About Frontier Scientists";
    infoObject.info = @"Frontier Scientists project";
    [titles addObject:infoObject];
    

    // Uncomment the following line to preserve selection between presentations.
    //self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //itvcParsedData
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    DataObject *current = [titles objectAtIndex:indexPath.row];
    cell.textLabel.text = [current cellName];
    
    cell.backgroundColor = [UIColor clearColor];
    
    cell.accessoryView = [[ UIImageView alloc ] initWithImage:[UIImage imageNamed:@"Transition_Icon.png"]];
    [cell.accessoryView setFrame:CGRectMake(0, 0, 34, 34)];
    cell.textLabel.font = [UIFont fontWithName:@"EraserDust" size:17.0];
    
    switch (indexPath.row)
    {
        case 0:
            cell.imageView.image = [UIImage imageNamed:@"Research_Icon"];
            break;
        case 1:
            cell.imageView.image = [UIImage imageNamed:@"Video_Icon"];
            break;
        case 2:
            cell.imageView.image = [UIImage imageNamed:@"Map_Icon"];
            break;
        case 3:
            cell.imageView.image = [UIImage imageNamed:@"Article_Icon"];
            break;
        case 4:
            cell.imageView.image = [UIImage imageNamed:@"Ask_A_Scientist_Icon"];
            break;
        default:
            cell.imageView.image = [UIImage imageNamed:@"About_Icon"];
            break;
    }
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CellBorder.png"]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row)
    {
        case 0:
            [self performSegueWithIdentifier:@"research" sender:self];
            break;
        case 1:
            [self performSegueWithIdentifier:@"videos" sender:self];
            break;
        case 2:
            [self performSegueWithIdentifier:@"map" sender:self];
            break;
        case 3:
            [self performSegueWithIdentifier:@"news" sender:self];
            break;
        case 4:
            [self performSegueWithIdentifier:@"ask" sender:self];
            break;
        default:[self performSegueWithIdentifier:@"about" sender:self];
            break;
    }
    //NSLog([itvcParsedData[0] objectForKey:@"post_title"]);
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if([[segue identifier] isEqualToString:@"research"])
    {
        ResearchTableViewController *rtvc = [segue destinationViewController];
        rtvc.rtvcParsedData = [itvcParsedData copy];
        rtvc.title = @"Research";
    }
    else if ([[segue identifier] isEqualToString:@"videos"])
    {
        VideoTableViewController *vtvc = [segue destinationViewController];
        vtvc.vtvcParsedData = [itvcParsedData copy];
        vtvc.title = @"Videos";
        vtvc.pickedSection = 0;
    }
    else if ([[segue identifier] isEqualToString:@"map"])
    {
        MapViewController *mvc = [segue destinationViewController];
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        DataObject *toPass = titles[path.row];
        mvc.textLabelString = [toPass info];
        mvc.camera = [GMSCameraPosition cameraWithLatitude:64.8436111 longitude:-150.72305555555556 zoom:3.375];
        mvc.title = @"Map";
        mvc.mvcParsedData = itvcParsedData;
    }
    else if ([[segue identifier] isEqualToString:@"news"])
    {
        ArticlesTableViewController *atvc = [segue destinationViewController];
        atvc.title = @"Articles";
    }
    else if ([[segue identifier] isEqualToString:@"ask"])
    {
        AskAScientistTableViewController *asktvc = [segue destinationViewController];
        asktvc.title = @"Ask A Scientist";
        asktvc.asktvcParsedData = itvcParsedData;
    }
    else
    {
        InfoTableViewController *aboutvc = [segue destinationViewController];
        aboutvc.title = @"About Frontier Scientists";
    }
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                      style:UIBarButtonItemStyleBordered
                                                                     target:nil
                                                                     action:nil];
    [[self navigationItem] setBackBarButtonItem:newBackButton];
    
}

#pragma mark NSURLConnection Delegate Methods
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self._responseData = [[NSMutableData alloc] init];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self._responseData appendData:data];
    NSLog(@"Data received.");
}

-(NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse
{
    return nil;
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"Request loaded successfully.");
    
    NSData *data = [NSData dataWithData:_responseData];
    
    NSFileManager *fileMgr = [NSFileManager defaultManager];
	NSString *documentsDir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
	
	NSString *xmlFile = [documentsDir stringByAppendingString:@"/best.txt"];
    
    if([data writeToFile:xmlFile atomically:YES])
    {
        NSLog(@"Write is successful.");
    }
    
    if([fileMgr fileExistsAtPath:xmlFile])
    {
        NSLog(@"File was saved and found!");
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSLog(@"documentsDirectory: %@", documentsDirectory);
    
	[self startParsing];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Request has failed!");
}

-(BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
    return YES;
    
}

-(void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    if([challenge.protectionSpace.host isEqualToString:@"frontsci.arsc.edu"])
        [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
}


-(void)downloadXMLFile
{
    NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:@"http://frontsci.arsc.edu/frontsci/dumpedSelectQuery.xml"]];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
    
	// the path to write file
	NSString *appFile = [documentsDirectory stringByAppendingPathComponent:@"dumpedSelectQuery.xml"];
	
	[data writeToFile:appFile atomically:YES];
	
	[self startParsing];

}


-(void)startParsing
{
	NSString *xmlFile = [documentsDir stringByAppendingString:@"/dumpedSelectQuery.xml"];
    NSLog(@"Path to the XML file: %@", xmlFile);
	NSData *xmlData = [[NSData alloc] initWithContentsOfFile:xmlFile];
	
	XMLParser *parser = [[XMLParser alloc] init];
	[parser parseXMLData:xmlData];
		
	// Add copy of Research data from XML Parser to global variable in frontier_scientist App Delegate
	itvcParsedData = [parser researchDict];
}


@end
