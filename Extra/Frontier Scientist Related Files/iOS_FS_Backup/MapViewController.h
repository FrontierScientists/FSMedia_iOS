//
//  MapViewController.h
//  frontier_scientists
//
//  Created by Bob Torgerson on 6/20/11.
//  Copyright 2011 ARSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class VideoViewController;
@class MyMapAnnotations;
@class HTMLViewController;

@interface MapViewController : UIViewController <MKMapViewDelegate>
{
    IBOutlet MKMapView *mapView;
	IBOutlet VideoViewController *videoViewController;
	NSData *data;
	MyMapAnnotations *currentMapAnnotation;
	IBOutlet HTMLViewController *htmlViewController;
}

@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) IBOutlet VideoViewController *videoViewController;
@property (nonatomic, retain) MyMapAnnotations *currentMapAnnotation;
@property (nonatomic, retain) IBOutlet HTMLViewController *htmlViewController;

@end