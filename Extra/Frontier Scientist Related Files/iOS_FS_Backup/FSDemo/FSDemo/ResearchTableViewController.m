//
//  ResearchTableViewController.m
//  FSDemo
//
//  Created by Andrew Clark on 4/9/14.
//  Copyright (c) 2014 Andrew Clark. All rights reserved.
//

#import "ResearchTableViewController.h"

@interface ResearchTableViewController ()
{
    NSDictionary *keysFromPlist;
    NSArray *infoFromPlist;
    NSArray *textFromPlist;
}

@end

@implementation ResearchTableViewController

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
    
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RiR_lined_iphone_V44px"]];
    [self.view addSubview:backgroundView];
    [self.view sendSubviewToBack:backgroundView];
    
    NSURL *url = [[NSBundle mainBundle]URLForResource:@"ResearchInfo" withExtension:@"plist"];
    keysFromPlist = [NSDictionary dictionaryWithContentsOfURL:url];
    infoFromPlist = keysFromPlist.allKeys;
    textFromPlist = keysFromPlist.allValues;
    
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
    return [keysFromPlist count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = infoFromPlist[indexPath.row];
    
    // Configure the cell...
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row)
    {
        case 0:
            [self performSegueWithIdentifier:@"researchViewController" sender:self];
            break;
        case 1:
            [self performSegueWithIdentifier:@"researchViewController" sender:self];
            break;
        case 2:
            [self performSegueWithIdentifier:@"researchViewController" sender:self];
            break;
        case 3:
            [self performSegueWithIdentifier:@"researchViewController" sender:self];
            break;
        case 4:
            [self performSegueWithIdentifier:@"researchViewController" sender:self];
            break;
        default:
            [self performSegueWithIdentifier:@"researchTabletoVideos" sender:self];
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
    
    if([[segue identifier] isEqualToString:@"researchViewController"])
    {
        ResearchViewController *rvc = [segue destinationViewController];
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
//        DataObjectTwo *toPass = researchTopics[path.row];
//        rvc.textLabelString = toPass.info;
        //rvc.rvcImagePic = [UIImage imageNamed:@"mountainsAndField"];
        rvc.title = @"Research Topics";
        rvc.textFieldContent = textFromPlist[path.row];
    }
    else if ([[segue identifier] isEqualToString:@"researchTabletoVideos"])
    {
        VideosViewController *vvc = [segue destinationViewController];
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
//        DataObjectTwo *toPass = researchTopics[path.row];
//        vvc.textLabelString = toPass.info;
        vvc.title = @"Videos";
        vvc.textLabelString = infoFromPlist[path.row];
    }

}


@end
