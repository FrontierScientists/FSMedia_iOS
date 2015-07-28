//
//  NewsViewController.h
//  FSDemo
//
//  Created by Andrew Clark on 4/4/14.
//  Copyright (c) 2014 Andrew Clark. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *newsTextLabel;
@property NSString *textLabelString;
@end
