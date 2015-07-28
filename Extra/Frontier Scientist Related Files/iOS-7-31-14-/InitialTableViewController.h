//
//  InitialTableViewController.h
//  FSDemo
//
//  Created by Andrew Clark on 4/2/14.
//  Copyright (c) 2014 Andrew Clark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataObject.h"
#import "ResearchViewController.h"
#import "VideosViewController.h"
#import "MapViewController.h"
#import "ArticlesTableViewController.h"
#import "AskAScientistTableViewController.h"
#import "InfoTableViewController.h"
#import "ResearchTableViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "VideoTableViewController.h"
#import "XMLParser.h"
#import "silentUpdateNotification.h"

@interface InitialTableViewController : UITableViewController
{
    //NSMutableData *_responseData;
}

@property UIImageView *customDisclosureView;
@property UIImage *customDisclosureImage;
@property GMSCameraPosition *camera;
@property NSData *rawData;
@property NSMutableData *_responseData;
@property UILocalNotification *xmlUpdate;
@property NSDate *updateIntervalDate;
@property NSUserDefaults *defaults;


@end
