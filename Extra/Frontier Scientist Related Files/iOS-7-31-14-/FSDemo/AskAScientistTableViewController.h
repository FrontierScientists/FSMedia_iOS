//
//  AskAScientistTableViewController.h
//  FSApp
//
//  Created by alandrews3 on 4/9/14.
//  Copyright (c) 2014 alandrews3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UITextView.h>
#import <UIKit/UITextField.h>
#import <MessageUI/MessageUI.h>
#import <QuartzCore/QuartzCore.h>

@interface AskAScientistTableViewController : UITableViewController <MFMailComposeViewControllerDelegate, UITextViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *askTextLabelNew;
@property (weak, nonatomic) IBOutlet UILabel *askTextLabel;
@property (weak, nonatomic) IBOutlet UITextField *m_userName;
@property (weak, nonatomic) IBOutlet UITextField *m_userEmail;
@property (weak, nonatomic) IBOutlet UITextField *m_userSubject;
@property (weak, nonatomic) IBOutlet UITextView *m_userQuestion;
@property (weak, nonatomic) IBOutlet UIImageView *scientistPicture;
@property (weak, nonatomic) IBOutlet UITextView *scientistBio;
@property NSString *scientistName;
@property NSString *scientistBioText;

- (IBAction) backgroundTouched:(id)sender;

- (void) displayAlert:(NSString *)errorOrigin;
- (void) setOutputs;

@end
