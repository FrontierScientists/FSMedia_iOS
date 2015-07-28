//
//  MyMapAnnotations.m
//  frontier_scientists
//
//  Created by Bob Torgerson on 6/24/11.
//  Copyright 2011 ARSC. All rights reserved.
//

#import "MyMapAnnotations.h"

@implementation MyMapAnnotations

@synthesize longitude;
@synthesize latitude;
@synthesize mytitle;
@synthesize subttl;
@synthesize type;
@synthesize text;
@synthesize imageName;
@synthesize link;
@synthesize videos;
@synthesize researchDictionary;

- (CLLocationCoordinate2D)coordinate;
{
    CLLocationCoordinate2D theCoordinate;
    theCoordinate.latitude = (CLLocationDegrees)[latitude doubleValue];
    theCoordinate.longitude = (CLLocationDegrees)[longitude doubleValue];
	
    return theCoordinate; 
}

// required if you set the MKPinAnnotationView's "canShowCallout" property to YES
- (NSString *)title
{
	if(!mytitle) {
		return @"";
	}
    return mytitle;
}

// optional
- (NSString *)subtitle
{
	if(!subttl) {
		return @"";
	}
    return subttl;
}

- (void)dealloc {
	[longitude release];
	[latitude release];
	[mytitle release];
	[subttl release];
	[type release];
	[text release];
	[imageName release];
	[link release];
	[videos release];
    [super dealloc];
}


@end
