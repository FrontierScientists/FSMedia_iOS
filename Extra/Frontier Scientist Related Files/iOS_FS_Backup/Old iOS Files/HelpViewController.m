//
//  HelpViewController.m
//  frontier_scientists
//
//  Created by Bob Torgerson
//  Copyright 2011 ARSC. All rights reserved.
//

#import "HelpViewController.h"

/********************************************************************\
| The Help View Controller is used to provide information about our  |
| app. This will be used to acquaint new users with the              |
| functionality of the application.                                  |
\********************************************************************/

@implementation HelpViewController

@synthesize helpTextView, font, texthelp;

// This function occurs when the view loads, only once per new object
- (void)viewDidLoad
{
	[super viewDidLoad];
    self.title = @"Help";
	helpTextView.font = [UIFont fontWithName:@"Tahome" size:18];
    helpTextView.text = self.texthelp;
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
	[self viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

// This is the destructor function, release all retained memory
- (void)dealloc {
	[helpTextView release];
	[font release];
	[texthelp release];
    [super dealloc];
}


@end
