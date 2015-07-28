//
//  MapViewController.m
//  FSDemo
//
//  Created by Andrew Clark on 4/2/14.
//  Copyright (c) 2014 Andrew Clark. All rights reserved.
//



#import "MapViewController.h"

@interface MapViewController ()
{
    NSArray *sortedKeysFromPlist;
}
@end

@implementation MapViewController
@synthesize mapTextLabel;
@synthesize textLabelString;
@synthesize camera;
@synthesize mapView;
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
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveMapNotification:)
                                                 name:@"update"
                                               object:nil];
    [self reloadMapMarkers];
    [super viewDidLoad];
}

-(void)receiveMapNotification:(NSNotification *)mNotification
{
    NSLog(@"Reload map time!");
    [self reloadMapMarkers];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)reloadMapMarkers
{
    mapTextLabel.text = textLabelString;
    [mapView clear];
    mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView.myLocationEnabled = NO;
    
    // Make sure a map for this project exists
    // researchDict -> maps(Array) count
    int mapCount = [[[[NSUserDefaults standardUserDefaults] objectForKey:@"researchDict"] objectForKey:@"maps"] count];
    
    CLLocationCoordinate2D t_coord;
    double lat, lon;
    GMSMarker *t_Marker = [[GMSMarker alloc] init];
    NSMutableArray *markerArray;
    
    for(int ii=0; ii<mapCount; ++ii)
    {
        // researchDict -> maps(Array) -> mapsDict -> latitude/longitude doubleValue
        lat = [[[[[NSUserDefaults standardUserDefaults] objectForKey:@"researchDict"] objectForKey:@"maps"][ii] objectForKey:@"latitude"] doubleValue];
        lon = [[[[[NSUserDefaults standardUserDefaults] objectForKey:@"researchDict"] objectForKey:@"maps"][ii] objectForKey:@"longitude"] doubleValue];
        
        t_coord = CLLocationCoordinate2DMake(lat, lon);
        t_Marker = [[GMSMarker alloc] init];
        t_Marker.position = t_coord;
        t_Marker.appearAnimation = YES;
        t_Marker.icon = [UIImage imageNamed:@"Mini_Ask_A_Scientist_Icon.png"];
        
        // researchDict -> maps(Array) -> mapsDict -> (maps)name
        t_Marker.title = [[[[NSUserDefaults standardUserDefaults] objectForKey:@"researchDict"] objectForKey:@"maps"][ii] objectForKey:@"name"];
        
        [markerArray addObject:t_Marker];
        t_Marker.map = mapView;
    }
    self.view = mapView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
