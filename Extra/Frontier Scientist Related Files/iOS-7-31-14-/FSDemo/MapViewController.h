//
//  MapViewController.h
//  FSDemo
//
//  Created by Andrew Clark on 4/2/14.
//  Copyright (c) 2014 Andrew Clark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>


@interface MapViewController : UIViewController <GMSMapViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *mapTextLabel;
@property NSString *textLabelString;
@property GMSCameraPosition *camera;
@property NSUserDefaults *defaults;
@property GMSMapView *mapView;

-(void)receiveMapNotification:(NSNotification *)mNotification;
-(void)reloadMapMarkers;

@end
