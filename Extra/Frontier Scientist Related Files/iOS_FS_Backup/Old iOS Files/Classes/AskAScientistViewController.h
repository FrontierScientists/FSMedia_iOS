//
//  FirstViewController.h
//  frontier_scientists
//
//  Created by Bob Torgerson on 7/11/11.
//  Copyright 2011 ARSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@class Reachability;

@interface AskAScientistViewController : UIViewController <MFMailComposeViewControllerDelegate, UITextViewDelegate, UITextFieldDelegate> {
	Reachability *internetReachable;
	Reachability *hostReachable;
	BOOL internetActive;
	BOOL hostActive;
	BOOL displayKeyboard;
	CGPoint  offset;
	IBOutlet UITextField *name;
	IBOutlet UITextField *email;
	IBOutlet UITextField *subject;
	IBOutlet UITextView *message;
	UITextField *Field;
	IBOutlet UIScrollView *scrollView;
	IBOutlet UIImageView *sciImage;
	IBOutlet UITextView *brief;
	NSString *brieftext;
}

@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) UITextField *name;
@property (nonatomic, retain) UITextField *email;
@property (nonatomic, retain) UITextField *subject;
@property (nonatomic, retain) UITextView *message;
@property (nonatomic, retain) UIImageView *sciImage;
@property (nonatomic, retain) NSString *brieftext;

-(IBAction)sendMessage:(id)sender;

@end
