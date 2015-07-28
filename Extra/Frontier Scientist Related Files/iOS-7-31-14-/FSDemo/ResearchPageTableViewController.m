//
//  ResearchPageTableViewController.m
//  FSDemo
//
//  Created by alandrews3 on 4/25/14.
//  Copyright (c) 2014 Andrew Clark. All rights reserved.
//

#import "ResearchPageTableViewController.h"
#import "InitialTableViewController.h"

@interface ResearchPageTableViewController ()

@end

@implementation ResearchPageTableViewController

@synthesize researchTextLabel;
@synthesize textLabelString;
@synthesize rvcImage;
@synthesize rvcImagePic;
@synthesize textField;
@synthesize textFieldContent;
@synthesize videosTextField, mapsTextField;
@synthesize pickedSection;
@synthesize segueIdentifier, mapOrVideoIdentifier;
@synthesize defaults;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"RiR_lined_iphone_V44px"]];
    
    videosTextField.borderStyle = UITextBorderStyleNone;
    mapsTextField.borderStyle = UITextBorderStyleNone;
    textField.text = textFieldContent;
    [self.rvcImage setImage:rvcImagePic];
    
}

-(void)receiveTableNotification:(NSNotification *)pNotification
{
    NSLog(@"Reload Research Page time!");
    if(pickedSection < [[[[NSUserDefaults standardUserDefaults] objectForKey:@"researchDict"] objectForKey:@"projects"] count])
    {
        textField.text = [[[[NSUserDefaults standardUserDefaults]  objectForKey:@"researchDict"] objectForKey:@"projects"][pickedSection] objectForKey: @"post_content"];
        self.rvcImage = [[[[NSUserDefaults standardUserDefaults]  objectForKey:@"researchDict"] objectForKey:@"projects"][pickedSection] objectForKey: @"picture"];
    }
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 2)
    {
        int topicVidCount = 0;
        int vidCount = [[[[NSUserDefaults standardUserDefaults] objectForKey:@"researchDict"] objectForKey:@"videos"] count];
        
        for (int ii=0; ii < vidCount; ++ii)
        {
            if([self.title isEqualToString: [[[[NSUserDefaults standardUserDefaults] objectForKey:@"researchDict"] objectForKey:@"videos"][ii] objectForKey:@"name"]])
            {
                ++topicVidCount;
                break;
            }
        }
        if(topicVidCount > 0)
        {
            [self performSegueWithIdentifier:@"researchPageToVideos" sender:indexPath];
        }
        else
        {
            mapOrVideoIdentifier = @"video";
            segueIdentifier = @"researchPageToVideos";
            [self displayAlert];
        }
    }
    else if(indexPath.row == 3)
    {
        int topicMapCount = 0;
        
        int mapCount = [[[[NSUserDefaults standardUserDefaults] objectForKey:@"researchDict"] objectForKey:@"maps"] count];
        
        for (int ii=0; ii < mapCount; ++ii)
        {
            if([self.title isEqualToString: [[[[NSUserDefaults standardUserDefaults] objectForKey:@"researchDict"] objectForKey:@"maps"][ii] objectForKey:@"name"]])
            {
                ++topicMapCount;
                break;
            }
        }
        if(topicMapCount > 0)
        {
            [self performSegueWithIdentifier:@"researchPageToMap" sender:indexPath];
        }
        else
        {
            self.mapOrVideoIdentifier = @"map";
            self.segueIdentifier = @"researchPageToMap";
            [self displayAlert];
        }
    }
}


#pragma mark - Navigation
 // In a story board-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
     if ([[segue identifier] isEqualToString:@"researchPageToMap"])
     {
         MapViewController *mvc = [segue destinationViewController];
         
         // Check if a map for this project exists
         // researchDict -> maps(Array) count
         int mapCount = [[[[NSUserDefaults standardUserDefaults] objectForKey:@"researchDict"] objectForKey:@"maps"] count];
         
         double lat = 0.0;
         double lon = 0.0;
         for (int ii=0; ii < mapCount; ++ii)
         {
             // researchDict -> maps(Array) -> mapsDict -> (maps)name
             if([self.title isEqualToString: [[[[NSUserDefaults standardUserDefaults] objectForKey:@"researchDict"] objectForKey:@"maps"][ii] objectForKey:@"name"]])
             {
                 // researchDict -> maps(Array) -> mapsDict -> latitude/longitude doubleValue
                 lat = [[[[[NSUserDefaults standardUserDefaults] objectForKey:@"researchDict"] objectForKey:@"maps"][ii] objectForKey:@"latitude"] doubleValue];
                 lon = [[[[[NSUserDefaults standardUserDefaults] objectForKey:@"researchDict"] objectForKey:@"maps"][ii] objectForKey:@"longitude"] doubleValue];
                 break;
             }
         }
         
         // in the case of no maps for this research topic
         if(lat == 0 && lon == 0)
         {
             mvc.camera = [GMSCameraPosition cameraWithLatitude:64.8436111 longitude:-150.72305555555556 zoom:3.375];
             mvc.title = @"Research Locations";
         }
         else
         {
             NSLog(@"lat: %f, lon: %f", lat, lon);
             mvc.camera = [GMSCameraPosition cameraWithLatitude:lat longitude:lon zoom:5];
             mvc.title = self.title;
         }
     }
     else
     {
         VideoTableViewController *vtvc = [segue destinationViewController];
     }
 }

- (void)displayAlert
{
    NSString *alertMessage = [NSString stringWithFormat:@"Sorry, there is no %@ data for this research topic.", mapOrVideoIdentifier];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:alertMessage delegate:self cancelButtonTitle:@"Stay here." otherButtonTitles:@"Continue", nil];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        [self performSegueWithIdentifier:self.segueIdentifier sender:self];
    }
}

@end
