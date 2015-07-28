//
//  DetailViewController.m
//  frontier_scientists
//
//  Created by Bob Torgerson on 6/28/11.
//  Copyright 2011 ARSC. All rights reserved.
//

#import "DetailViewController.h"

@implementation DetailViewController

@synthesize modText, theText, picture;

- (void)viewDidLoad
{
    [super viewDidLoad];
	if (picture) {
		int valHei = picHeight;
		int valWid = picWidth;
		if ((valHei == 0) && (valWid != 0))
			picture.frame = CGRectMake(0,0,picWidth,picture.frame.size.height);
		else if ((valHei != 0) && (valWid == 0))
			picture.frame = CGRectMake(0,0,modText.frame.size.width, picHeight);
		else if ((valHei == 0) && (valWid == 0))
			picture.frame = CGRectMake(0,0,modText.frame.size.width,picture.frame.size.height);
		else
			picture.frame = CGRectMake(0,0,picWidth,picHeight);

		[self.view addSubview:picture];
		modText.frame = CGRectMake(modText.frame.origin.x,picture.frame.size.height,modText.frame.size.width,modText.frame.size.height-picture.frame.size.height);
	}
	
	modText.font = [UIFont fontWithName:@"Tahome" size:30];
	modText.text = theText;
}

- (void)setDetailText:(NSString *)txt {
	theText = txt;
}

- (void)setImage:(NSString *)imgName setHeight:(CGFloat)frmHeight setWidth:(CGFloat)frmWidth {
	picture = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgName]];
	picHeight = frmHeight;	
	picWidth = frmWidth;
}

/*- (void)viewDidUnload
{
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}*/

- (void)dealloc
{
	[modText release];
	[theText release];
    [picture release];
	[super dealloc];
}


@end