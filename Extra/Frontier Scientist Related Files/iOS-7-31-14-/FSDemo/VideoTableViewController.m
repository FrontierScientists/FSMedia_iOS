//
//  VideoTableViewController.m
//  FSDemo
//
//  Created by Andrew Clark on 4/17/14.
//  Copyright (c) 2014 Andrew Clark. All rights reserved.
//

#import "VideoTableViewController.h"

@interface VideoTableViewController ()


@end

@implementation VideoTableViewController

@synthesize vtvcParsedData;
@synthesize videoNameArray;
@synthesize videoMP4Array;
@synthesize video3GPArray;
@synthesize videoUTubeArray;
@synthesize vidLink;
@synthesize youTubeLink;


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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    self.title = @"Videos";
    
    videoNameArray = [[NSMutableArray alloc]init];
    videoMP4Array = [[NSMutableArray alloc]init];
    video3GPArray = [[NSMutableArray alloc]init];
    videoUTubeArray = [[NSMutableArray alloc]init];
    
    [self parseForVideoData];
    
    for(NSString *index in videoNameArray)
    {
        NSLog(@"The name of the videos are %@ ", index);
    }
    
    UIImage *navBarImage = [UIImage imageNamed:@"RiR_plainyellow_iphone"];
    [self.navigationController.navigationBar setBackgroundImage:navBarImage forBarMetrics:UIBarMetricsDefault];
    
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RiR_lined_iphone_V44px"]];
    [self.view addSubview:backgroundView];
    [self.view sendSubviewToBack:backgroundView];
    

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
    return [vtvcParsedData count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[vtvcParsedData objectAtIndex:section] objectForKey:@"research_title"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{	
    return [[[vtvcParsedData objectAtIndex:section] objectForKey:@"videos"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor clearColor];
    
//    cell.accessoryView = [[ UIImageView alloc ] initWithImage:[UIImage imageNamed:@"Transition_Icon.png"]];
//    [cell.accessoryView setFrame:CGRectMake(0, 0, 34, 34)];
    
    // Set up the cell
	int storyIndex = [indexPath indexAtPosition: [indexPath length] - 1];
	
	int offset = 0;
	int count = [indexPath section] - 1;
	
	while (count >= 0) {
		offset += [[[self.vtvcParsedData objectAtIndex:count] objectForKey:@"videos"] count];
		count--;
	}

    
    cell.textLabel.text = [videoNameArray objectAtIndex:storyIndex+offset];
     
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int videoIndex = [indexPath indexAtPosition: [indexPath length] - 1];
	
	int offset = 0;
	int count = [indexPath section] - 1;
	
	while (count >= 0) {
		offset += [[[self.vtvcParsedData objectAtIndex:count] objectForKey:@"videos"] count];
		count--;
	}
	
	vidLink = [videoMP4Array objectAtIndex:videoIndex+offset];
	youTubeLink = [videoUTubeArray objectAtIndex:videoIndex+offset];
    
	// clean up the link - get rid of spaces, returns, and tabs...
	vidLink = [vidLink stringByReplacingOccurrencesOfString:@"\n" withString:@""];
	youTubeLink = [youTubeLink stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    [self performSegueWithIdentifier:@"displayVideo" sender:self];
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//}

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
    
    VideosViewController *vvc = [segue destinationViewController];
    NSIndexPath *path = [self.tableView indexPathForSelectedRow];
    
    vvc.urlString = youTubeLink;
}

- (void)parseForVideoData {
		
	int i = 0;
	int j = 0;
    
	while (i < [vtvcParsedData count])
    {
		j = 0;
		while (j < [[[vtvcParsedData objectAtIndex:i] objectForKey:@"videos"] count])
        {
			[videoNameArray addObject:[[[[vtvcParsedData objectAtIndex:i] objectForKey:@"videos"] objectAtIndex:j] objectForKey:@"title"]];
			[videoMP4Array addObject:[[[[vtvcParsedData objectAtIndex:i] objectForKey:@"videos"] objectAtIndex:j] objectForKey:@"download3GP"]];
			[videoUTubeArray addObject:[[[[vtvcParsedData objectAtIndex:i] objectForKey:@"videos"] objectAtIndex:j] objectForKey:@"utubeurl"]];
			j++;
		}
		i++;
	}
}

@end
