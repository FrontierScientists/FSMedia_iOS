//
//  ResearchPageTableViewController.h
//  FSDemo
//
//  Created by alandrews3 on 4/25/14.
//  Copyright (c) 2014 Andrew Clark. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResearchPageTableViewController : UITableViewController <UIAlertViewDelegate>

@property NSString *textLabelString;
@property (weak, nonatomic) IBOutlet UILabel *researchTextLabel;

@property (weak, nonatomic) IBOutlet UIImageView *rvcImage;
@property UIImage *rvcImagePic;

@property (weak, nonatomic) IBOutlet UITextView *textField;
@property NSString *textFieldContent;

@property (weak, nonatomic) IBOutlet UITextField *videosTextField;
@property (weak, nonatomic) IBOutlet UITextField *mapsTextField;

@property NSInteger pickedSection;
@property NSString *segueIdentifier;
@property NSString *mapOrVideoIdentifier;
@property NSUserDefaults *defaults;

@end
