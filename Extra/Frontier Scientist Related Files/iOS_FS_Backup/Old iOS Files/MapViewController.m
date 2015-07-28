//
//  MapViewController.m
//  frontier_scientists
//
//  Created by Bob Torgerson on 6/20/11.
//  Copyright 2011 ARSC. All rights reserved.
//

#import "MapViewController.h"
#import "MyMapAnnotations.h"
#import "VideoViewController.h"
#import "HTMLViewController.h"
#import "ResearchViewController.h"
#import "frontier_scientistsAppDelegate.h"

@implementation MapViewController

@synthesize mapView, videoViewController, currentMapAnnotation, htmlViewController;

+ (CGFloat)annotationPadding;
{
    return 10.0f;
}
+ (CGFloat)calloutHeight;
{
    return 40.0f;
}

- (void)goToAlaska
{
    // start off in Alaska
    MKCoordinateRegion newRegion;
    newRegion.center.latitude = 64.283670;
    newRegion.center.longitude = -151.787109;
    newRegion.span.latitudeDelta = 18.000000;
    newRegion.span.longitudeDelta = 18.000000;
	
    [self.mapView setRegion:newRegion animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:(BOOL)animated];
    //hide the navigation bar
    [self.navigationController setNavigationBarHidden:YES animated:NO];
	self.mapView.mapType = MKMapTypeHybrid;   // also MKMapTypeSatellite or MKMapTypeHybrid
	self.mapView.delegate = self;
	[self.navigationController setNavigationBarHidden:YES animated:NO];
	
	frontier_scientistsAppDelegate *appDelegate = (frontier_scientistsAppDelegate *)[[UIApplication sharedApplication] delegate];
	[self.mapView addAnnotations:appDelegate.mapData];
	
	// zoom in on Alaska
    [self goToAlaska];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)showResearch:(id)sender {
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 30200)
	
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		ResearchViewController *researchViewController = [[ResearchViewController alloc] initWithNibName:@"ResearchViewController-iPad" bundle:nil];
		self.currentMapAnnotation = [[self.mapView annotations] objectAtIndex:[sender tag]];
		[researchViewController setItem:[self.currentMapAnnotation researchDictionary]];
		
		[[self navigationController] pushViewController:researchViewController animated:YES];
		[researchViewController release];
		[self.navigationController setNavigationBarHidden:NO animated:NO];
    } else {
		ResearchViewController *researchViewController = [[ResearchViewController alloc] init];
		self.currentMapAnnotation = [[self.mapView annotations] objectAtIndex:[sender tag]];
		[researchViewController setItem:[self.currentMapAnnotation researchDictionary]];
		
		[[self navigationController] pushViewController:researchViewController animated:YES];
		[researchViewController release];
		[self.navigationController setNavigationBarHidden:NO animated:NO];
	}
	
#endif
}

- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MyMapAnnotations class]])
    {
        // try to dequeue an existing pin view first
        MKPinAnnotationView* pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"Normal"];
        if (!pinView)
        {
            // if an existing pin view was not available, create one
            MKPinAnnotationView* customPinView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Normal"] autorelease];
            customPinView.pinColor = MKPinAnnotationColorRed;
            customPinView.animatesDrop = YES;
            customPinView.canShowCallout = YES;
			
			int total = [[theMapView annotations] count];
			int counter = 0;
			
			while (counter < total) {
				if([[[theMapView annotations] objectAtIndex:counter] mytitle] == [annotation title]) {
					break;
				}
				counter++;
			}
			
			UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
			[rightButton addTarget:self
                            action:@selector(showResearch:)
				  forControlEvents:UIControlEventTouchUpInside];
			rightButton.tag = counter;
			customPinView.rightCalloutAccessoryView = rightButton;
			
			return customPinView;
        }
        else
        {
            pinView.annotation = annotation;
        }
        return pinView;
    }
	return nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return YES;
}

- (void)dealloc 
{
	[htmlViewController release];
    [mapView release];
	[videoViewController release];
	[currentMapAnnotation release];
    [super dealloc];
}

@end

