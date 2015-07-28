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

@synthesize videoNameArray;
@synthesize researchNameArray;
@synthesize videoMP4Array;
@synthesize video3GPArray;
@synthesize videoUTubeArray;
@synthesize vidLink;
@synthesize youTubeLink;
@synthesize pickedSection;
@synthesize researchTopicCount;
@synthesize defaults;

NSIndexPath *scrollPath;


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
    
    youTubeLink = @"https://www.youtube.com/watch?v=2r1VPxESfoY";

    scrollPath = [NSIndexPath indexPathForRow:NSNotFound inSection:pickedSection];
    NSLog(@"The video section is: %d", scrollPath.section);
    [self.tableView scrollToRowAtIndexPath:scrollPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    self.title = @"Videos";
    
    videoNameArray = [[NSMutableArray alloc]init];
    researchNameArray = [[NSMutableArray alloc]init];
    videoMP4Array = [[NSMutableArray alloc]init];
    video3GPArray = [[NSMutableArray alloc]init];
    videoUTubeArray = [[NSMutableArray alloc]init];
    
    //[self parseForVideoData];
    
    /*
    for(NSString *index in videoNameArray)
    {
        NSLog(@"The name of the videos are %@ ", index);
    }
     */
    
    UIImage *navBarImage = [UIImage imageNamed:@"RiR_plainyellow_iphone"];
    [self.navigationController.navigationBar setBackgroundImage:navBarImage forBarMetrics:UIBarMetricsDefault];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"RiR_lined_iphone_V44px"]];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - Table view data source
-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    view.tintColor = [UIColor clearColor];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
    //return [[[NSUserDefaults standardDefaults] objectForKey:@"researchDict"] count];
}


/*
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    // researchDict -> projects(Array) -> projectsDict -> (projects)Name
    return [[[[NSUserDefaults standardDefaults] objectForKey:@"researchDict"] objectForKey:@"projects"][section] objectForKey: @"name"];
    return [[[NSUserDefaults standardDefaults] objectForKey:@"projects"][section] objectForKey: @"name"];
}
*/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{	
    return 1;
    //return [[[[[NSUserDefaults standardDefaults] objectForKey:@"researchDict"] objectAtIndex:section] objectForKey:@"videos"] count];
}

 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor clearColor];
    
    cell.accessoryView = [[ UIImageView alloc ] initWithImage:[UIImage imageNamed:@"Transition_Icon.png"]];
    [cell.accessoryView setFrame:CGRectMake(0, 0, 34, 34)];
  
    /*
    // Set up the cell
	int storyIndex = [indexPath indexAtPosition: [indexPath length] - 1];
	
	int offset = 0;
	int count = [indexPath section] - 1;
	
	while (count >= 0) {
        offset += [[[[[NSUserDefaults standardDefaults] objectForKey:@"researchDict"] objectAtIndex:count] objectForKey:@"videos"] count];
		count--;
	}
     */
     
    //cell.textLabel.text = [videoNameArray objectAtIndex:storyIndex+offset];
    cell.textLabel.text = @"Video test";
    cell.textLabel.font = [UIFont fontWithName:@"Chalkduster" size:17.0];
     
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self performSegueWithIdentifier:@"choosePlayback" sender:self];
    
    /*
    int videoIndex = [indexPath indexAtPosition: [indexPath length] - 1];
	
	//vidLink = [videoMP4Array objectAtIndex:videoIndex+offset];
    youTubeLink = [[[[NSUserDefaults standardDefaults] objectForKey:@"researchDict"] objectForKey:@"videos"][videoIndex] objectForKey:@"utubeurl"];
    
    [self performSegueWithIdentifier:@"choosePlayback" sender:self];*/
}

#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    chooseVideoPlaybackViewController *cvpc = [segue destinationViewController];
    NSLog(@"Video Table View Controller, youTubeLink is %@", youTubeLink);
    cvpc.urlString = youTubeLink;
}

- (void)parseForVideoData {
		/*
	int i = 0;
	int j = 0;
    
    while (i < [[[NSUserDefaults standardDefaults] objectForKey:@"researchDict"] count])
    {
		j = 0;
        while (j < [[[[[NSUserDefaults standardDefaults] objectForKey:@"researchDict"] objectAtIndex:i] objectForKey:@"videos"] count])
        {
            [videoNameArray addObject:[[[[[[NSUserDefaults standardDefaults] objectForKey:@"researchDict"] objectAtIndex:i] objectForKey:@"videos"] objectAtIndex:j] objectForKey:@"title"]];
            [videoMP4Array addObject:[[[[[[NSUserDefaults standardDefaults] objectForKey:@"researchDict"] objectAtIndex:i] objectForKey:@"videos"] objectAtIndex:j] objectForKey:@"download3GP"]];
            [videoUTubeArray addObject:[[[[[[NSUserDefaults standardDefaults] objectForKey:@"researchDict"] objectAtIndex:i] objectForKey:@"videos"] objectAtIndex:j] objectForKey:@"utubeurl"]];
			j++;
		}
		i++;
	}*/
}

@end
