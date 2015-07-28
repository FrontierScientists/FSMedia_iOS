//
//  ResearchTableViewController.h
//  FSDemo
//
//  Created by Andrew Clark on 4/9/14.
//  Copyright (c) 2014 Andrew Clark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResearchPageTableViewController.h"
#import "VideosViewController.h"
#import "DataObjectTwo.h"

@interface ResearchTableViewController : UITableViewController
@property NSInteger pickedSection;
@property UIImage *selectionImage;
@property (weak, nonatomic) IBOutlet UILabel *reseachLabel;
@property (weak, nonatomic) IBOutlet UIImageView *researchImage;
@property NSUserDefaults *defaults;

@end
