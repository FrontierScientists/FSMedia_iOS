//
//  VideoTableViewController.h
//  FSDemo
//
//  Created by Andrew Clark on 4/17/14.
//  Copyright (c) 2014 Andrew Clark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoTableViewController.h"
#import "VideosViewController.h"

@interface VideoTableViewController : UITableViewController

@property NSMutableArray *vtvcParsedData;
@property NSMutableArray *videoNameArray;
@property NSMutableArray *videoMP4Array;
@property NSMutableArray *video3GPArray;
@property NSMutableArray *videoUTubeArray;
@property NSString *vidLink;
@property NSString *youTubeLink;
-(void)parseForVideoData;
@end
