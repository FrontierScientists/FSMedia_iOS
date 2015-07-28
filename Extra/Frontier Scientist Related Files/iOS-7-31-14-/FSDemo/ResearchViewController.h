//
//  ResearchViewController.h
//  FSDemo
//
//  Created by Andrew Clark on 4/2/14.
//  Copyright (c) 2014 Andrew Clark. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResearchViewController : UIViewController

@property NSString *textLabelString;
@property (weak, nonatomic) IBOutlet UILabel *researchTextLabel;

@property (weak, nonatomic) IBOutlet UIImageView *rvcImage;
@property UIImage *rvcImagePic;

@property (weak, nonatomic) IBOutlet UITextView *textField;
@property NSString *textFieldContent;
@property NSUserDefaults *defaults;

@end
