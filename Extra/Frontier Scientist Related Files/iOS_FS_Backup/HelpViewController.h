//
//  HelpViewController.h
//  frontier_scientists
//
//  Created by Bob Torgerson
//  Copyright ARSC 2011. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HelpViewController : UIViewController {

	IBOutlet UITextView *helpTextView;
	NSString *texthelp;
	UIFont *font;
	
}

@property(nonatomic,readonly,retain) UITextView *helpTextView;
@property(nonatomic,retain) UIFont *font;
@property(nonatomic,retain) NSString *texthelp;

@end
