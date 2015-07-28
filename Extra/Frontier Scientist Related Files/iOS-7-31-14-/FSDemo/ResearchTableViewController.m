//
//  ResearchTableViewController.m
//  FSDemo
//
//  Created by Andrew Clark on 4/9/14.
//  Copyright (c) 2014 Andrew Clark. All rights reserved.
//

#import "ResearchTableViewController.h"
#import "CustomResearchTableViewCell.h"

@interface ResearchTableViewController ()

@end

@implementation ResearchTableViewController

@synthesize pickedSection;
@synthesize selectionImage;
@synthesize defaults;

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
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"RiR_lined_iphone_V44px"]];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTableNotification:)
                                                 name:@"update"
                                               object:nil];
    
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    //Creates the background image
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"RiR_lined_iphone_V44px"]];
}

-(void)receiveTableNotification:(NSNotification *)pNotification
{
    NSLog(@"Reload Research Tabletime!");
    [self.tableView reloadData];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    // researchDict -> projects(Array) count
    NSLog(@"count: %lu", (unsigned long)[[[[NSUserDefaults standardUserDefaults] objectForKey:@"researchDict"] objectForKey:@"projects"] count]);
    return [[[[NSUserDefaults standardUserDefaults] objectForKey:@"researchDict"] objectForKey:@"projects"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"researchTopic";
    CustomResearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor clearColor];
    //researchDict -> projects(Array) -> projectsDict -> (projects)Name
    cell.researchImage.image = [UIImage imageWithData:[[[[NSUserDefaults standardUserDefaults] objectForKey:@"researchDict"] objectForKey:@"projects"][indexPath.row] objectForKey: @"picture"]];

    //researchDict -> projects(Array) -> projectsDict -> (projects)Name
    cell.researchLabel.text = [[[[NSUserDefaults standardUserDefaults] objectForKey:@"researchDict"] objectForKey:@"projects"][indexPath.row] objectForKey: @"name"];
    
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Medium_CellBorder.png"]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    pickedSection = indexPath.row;
    //researchDict -> projects(Array) -> projectsDict -> (projects)Name
    self.selectionImage = [UIImage imageWithData:[[[[NSUserDefaults standardUserDefaults]  objectForKey:@"researchDict"] objectForKey:@"projects"][indexPath.row] objectForKey: @"picture"]];
    
    [self performSegueWithIdentifier:@"researchViewController" sender:self];

}

- (double) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88;
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
    self.navigationItem.backBarButtonItem.title = @"";
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([[segue identifier] isEqualToString:@"researchViewController"])
    {
        ResearchPageTableViewController *rptvc = [segue destinationViewController];
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        
        // researchDict -> projects(Array) -> projectsDict -> (projects)Content
        NSString *researchTextToPass = [[[[NSUserDefaults standardUserDefaults]  objectForKey:@"researchDict"] objectForKey:@"projects"][path.row] objectForKey: @"post_content"];
        
        rptvc.textFieldContent = researchTextToPass;
        
        // researchDict -> projects(Array) -> projectsDict -> (projects)Name
        rptvc.title = [[[[NSUserDefaults standardUserDefaults]  objectForKey:@"researchDict"] objectForKey:@"projects"][path.row] objectForKey: @"name"];
        
        rptvc.pickedSection = pickedSection;
        rptvc.rvcImagePic = self.selectionImage;
    }
}


@end
