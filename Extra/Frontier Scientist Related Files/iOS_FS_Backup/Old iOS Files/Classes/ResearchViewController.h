//
//  ResearchViewController.h
//  frontier_scientists
//
//  Created by Bob Torgerson on 7/25/11.
//  Copyright 2011 ARSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class MyMapAnnotations;

@interface ResearchViewController : UIViewController <MKMapViewDelegate, UITableViewDelegate, UITextViewDelegate> {
	IBOutlet UITableView *movieTableView;
	IBOutlet UITableView *sciTableView;
	IBOutlet UIImageView *imageView;
	IBOutlet UIImageView *offlineMapView;
	NSMutableArray *movies;
	IBOutlet UITextView *titleView;
	IBOutlet UITextView *textView;
	IBOutlet MKMapView *mapView;
	IBOutlet UIButton *eye;
	NSMutableDictionary *item;
	MyMapAnnotations *currentPin;
}

@property (nonatomic, retain) NSMutableArray *movies;
@property (nonatomic, retain) NSMutableDictionary *item;
@property (nonatomic, retain) MyMapAnnotations *currentPin;
@property (nonatomic, retain) IBOutlet UITextView *titleView;
@property (nonatomic, retain) IBOutlet UITextView *textView;
@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) IBOutlet UITableView *movieTableView;
@property (nonatomic, retain) IBOutlet UITableView *sciTableView;
@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) IBOutlet UIImageView *offlineMapView;
@property (nonatomic, retain) IBOutlet UIButton *eye;

-(BOOL)connectedToNetwork;
-(void)zoomToLocation;

-(IBAction)clickedEye:(id)sender;

@end
