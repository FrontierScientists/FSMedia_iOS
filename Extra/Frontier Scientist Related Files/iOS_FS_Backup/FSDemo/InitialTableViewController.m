//
//  InitialTableViewController.m
//  FSDemo
//
//  Created by Andrew Clark on 4/2/14.
//  Copyright (c) 2014 Andrew Clark. All rights reserved.
//

#import "InitialTableViewController.h"

@interface InitialTableViewController ()
{
    NSMutableArray *titles;
}

@end

@implementation InitialTableViewController

@synthesize customDisclosureView;
@synthesize customDisclosureImage;

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
    
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RiR_lined_iphone_V44px"]];
    [self.view addSubview:backgroundView];
    [self.view sendSubviewToBack:backgroundView];
    //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"RiR_lined_iphone"]];
    
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
    infoObject.cellName = @"Ask a scientist";
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
//    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    DataObject *current = [titles objectAtIndex:indexPath.row];
    cell.textLabel.text = [current cellName];
    
    cell.backgroundColor = [UIColor clearColor];
    
    cell.accessoryView = [[ UIImageView alloc ] initWithImage:[UIImage imageNamed:@"Transition_Icon.png"]];
    [cell.accessoryView setFrame:CGRectMake(0, 0, 34, 34)];
    
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
        //NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        //DataObject *toPass = titles[path.row];
        rtvc.title = @"Research";
    }
    else if ([[segue identifier] isEqualToString:@"videos"])
    {
        VideosViewController *vvc = [segue destinationViewController];
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        DataObject *toPass = titles[path.row];
        vvc.textLabelString = [toPass info];
    }
    else if ([[segue identifier] isEqualToString:@"map"])
    {
        MapViewController *mvc = [segue destinationViewController];
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        DataObject *toPass = titles[path.row];
        mvc.textLabelString = [toPass info];
    }
    else if ([[segue identifier] isEqualToString:@"news"])
    {
        NewsViewController *nvc = [segue destinationViewController];
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        DataObject *toPass = titles[path.row];
        nvc.textLabelString = [toPass info];
    }
    else if ([[segue identifier] isEqualToString:@"ask"])
    {
        AskViewController *askvc = [segue destinationViewController];
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        DataObject *toPass = titles[path.row];
        askvc.textLabelString = [toPass info];
    }
    else
    {
        AboutViewController *aboutvc = [segue destinationViewController];
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        DataObject *toPass = titles[path.row];
        aboutvc.textLabelString = [toPass info];
    }
    
    
}



@end
