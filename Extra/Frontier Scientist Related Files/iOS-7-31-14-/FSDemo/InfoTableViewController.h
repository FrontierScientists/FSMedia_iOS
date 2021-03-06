//
//  InfoTableViewController.h
//  FSDemo
//
//  Created by alandrews3 on 5/15/14.
//  Copyright (c) 2014 Andrew Clark. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoTableViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UITextView *InfoView;
@property NSUserDefaults *defaults;

-(void)receiveTableNotification:(NSNotification *)pNotification;

@end