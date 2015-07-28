//
//  AskAScientistController.m
//  frontier_scientists
//
//  Created by Bob Torgerson on 7/11/11.
//  Copyright 2011 ARSC. All rights reserved.
//
#define SCROLLVIEW_CONTENT_HEIGHT 460
#define SCROLLVIEW_CONTENT_WIDTH  320

#import "AskAScientistViewController.h"
#import "Reachability.h"


/***************************************************
 The Ask A Scientists functionality is for allowing
 users of the program to ask a question via email.
 This is meant as a way of outreach for the client
 community.
 ***************************************************/

@implementation AskAScientistViewController

@synthesize name, email, subject, message, scrollView, sciImage, brieftext;

-(void) viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];

	// Setup Notifiers for when the keyboard is shown or hides, clicking on an input field opens the keyboard
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name: UIKeyboardDidShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name: UIKeyboardDidHideNotification object:nil];
	
	[self.message setBackgroundColor:[UIColor whiteColor]];
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 30200)
	
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		scrollView.contentSize = CGSizeMake(SCROLLVIEW_CONTENT_WIDTH, 1050);
	}
	else {
		scrollView.contentSize = CGSizeMake(SCROLLVIEW_CONTENT_WIDTH, SCROLLVIEW_CONTENT_HEIGHT);
	}
#endif
	
	displayKeyboard = NO;

}

- (void)viewDidLoad
{
	[super viewDidLoad];
	self.name.delegate = self;
	self.email.delegate = self;
	self.subject.delegate = self;
	self.message.delegate = self;
	
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 30200)
	
	// For the iPad, with the additional space, we show the Scientist On Call, and provide a bit of additional information
	// about them in this section
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		brief.text = self.brieftext;
		
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		NSString *appFile = [documentsDirectory stringByAppendingPathComponent:@"ScientistOnCall.jpg"];
		self.sciImage.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:appFile]];
	}
#endif
	
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
	[message setBackgroundColor:[UIColor whiteColor]];
    [scrollView scrollRectToVisible:[textView frame] animated:YES];
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 30200)
	
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		return YES;
	}
	else {
		//If on the iPhone a person presses the Return button
		// exit the text input on the keyboard and hide the 
		// keyboard. 
		if ([text isEqualToString:@"\n"]) {
			[textView resignFirstResponder];
			return NO;
		}
	}
#endif
	
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return NO;
}

// At one time there was more to the keyboardDidShow and keyboard
-(void) keyboardDidShow: (NSNotification *)notif {
	if (displayKeyboard) {
		return;
	}

	displayKeyboard = YES;
}

-(void) keyboardDidHide: (NSNotification *)notif {
	if (!displayKeyboard) {
		return; 
	}
	
	displayKeyboard = NO;
	
}

// This function checks to make sure that all fields have been entered on and sends the message out using 
// the MFMailComposeViewController class
- (IBAction)sendMessage:(id)sender
{
	if([MFMailComposeViewController canSendMail]) {
		MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
		mailController.mailComposeDelegate = self;
		
		// Set all input fields to white at the beginning of the function
		[name setBackgroundColor:[UIColor whiteColor]];
		[email setBackgroundColor:[UIColor whiteColor]];
		[subject setBackgroundColor:[UIColor whiteColor]];
		[message setBackgroundColor:[UIColor whiteColor]];

		NSMutableArray *errArray = [[NSMutableArray alloc] init];
		
		// These conditionals go through the process of figuring out which fields have not been completed and will not allow
		// a message to be sent until each field has text inside of it
		if ([[subject text] isEqualToString:@""] || [[name text] isEqualToString:@""] || [[message text] isEqualToString:@""] || [[email text] isEqualToString:@""]) {
			if ([[name text] isEqualToString:@""]) {
				[name setBackgroundColor:[UIColor redColor]];
				[errArray addObject:@"your name"];
		    }
				 
			if ([[email text] isEqualToString:@""]) {
				[email setBackgroundColor:[UIColor redColor]];
				[errArray addObject:@"your email address"];
			}
			
			if ([[subject text] isEqualToString:@""]) {
				[subject setBackgroundColor:[UIColor redColor]];
				[errArray addObject:@"the subject of the email"];
			}
			
			if ([[message text] isEqualToString:@""]) {
				[message setBackgroundColor:[UIColor redColor]];
				[errArray addObject:@"the message body"];
			}
			NSString *errMsg = @"You must provide ";
			int arrCount = [errArray count];
			
			// This for loop prints out the fields that need to be completed before the message will be accepted
			for (int i = 0; i < arrCount; i++) {
				
				if ((i+1) == arrCount) {
					if (arrCount == 1) {
						errMsg = [errMsg stringByAppendingString:[errArray objectAtIndex:i]];
					}
					else {
						errMsg = [errMsg stringByAppendingString:@"and "];
						errMsg = [errMsg stringByAppendingString:[errArray objectAtIndex:i]];
					}
				}
				else {
					errMsg = [errMsg stringByAppendingString:[errArray objectAtIndex:i]];
					errMsg = [errMsg stringByAppendingString:@", "];
				}
			}
			
			// Create an alert to show the missing information required to send a message
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Missing Required Information" message:errMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[alert show];
			[alert release];
		}
		else {
			[name setBackgroundColor:[UIColor whiteColor]];
			[email setBackgroundColor:[UIColor whiteColor]];
			[subject setBackgroundColor:[UIColor whiteColor]];
			[message setBackgroundColor:[UIColor yellowColor]];
			
			// All mail is sent to Liz (the P.I.) for this project and is forwarded to the scientist on call
			[mailController setToRecipients:[NSArray arrayWithObject:@"Liz@frontierscientists.com"]];

			// Set up the email message to show the person's input values as part of the body of the e-mail
			[mailController setSubject:[subject text]];
			NSString *msgbody = [[NSString alloc] initWithString:[NSString stringWithFormat:@"Name: %@\nReturn Email Address: %@\n\n%@",[name text],[email text],[message text]]];
		
			[mailController setMessageBody:msgbody isHTML:NO];
			[msgbody release];
		 
			if (mailController)
				[self presentViewController:mailController animated:YES completion:nil];
		}
		[mailController release];
	}
	else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cannot send mail" message:@"Check your connection to the Internet and your e-mail settings for your iOS device." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
}

-(void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error;
{
	// If successful, show an alert stating that the email was sent 
	if (result == MFMailComposeResultSent) {
		NSLog(@"Sent the mail!");
		[name setText:@""];
		[email setText:@""];
		[subject setText:@""];
		[message setText:@""];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email Sent" message:@"We will respond to your question at our earliest conviencence!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void) viewWillDisappear:(BOOL)animated
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
	[scrollView release];
	[name release];
	[email release];
	[subject release];
	[message release];
    [super dealloc];
}

@end
