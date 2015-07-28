//
//  InfoTableViewController.m
//  FSDemo
//
//  Created by alandrews3 on 5/15/14.
//  Copyright (c) 2014 Andrew Clark. All rights reserved.
//

#import "InfoTableViewController.h"

@interface InfoTableViewController ()

@end



@implementation InfoTableViewController

@synthesize InfoView;
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
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"RiR_lined_iphone_V44px"]];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTableNotification:)
                                                 name:@"update"
                                               object:nil];
}


-(void)receiveTableNotification:(NSNotification *)pNotification
{
    NSLog(@"Reload About time!");
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    InfoView.text = [[[NSUserDefaults standardUserDefaults] objectForKey:@"researchDict" ] objectForKey:@"AboutPage"];
    InfoView.font = [UIFont fontWithName:@"Chalkduster" size:17.0];
    InfoView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"RiR_lined_iphone_V44px"]];
    if(cell == nil)
        cell = [[UITableViewCell alloc] init];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 300, 20)];
    UILabel *headerLabel =  [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 20)];
    headerLabel.backgroundColor = [UIColor clearColor];
                                   
    headerLabel.text = @"About the Frontier Scientists:";
    headerLabel.font = [UIFont fontWithName:@"Chalkduster" size:17.0];
    
    [customView addSubview:headerLabel];
    return customView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
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
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
