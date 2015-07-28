//
//  DataTableiPadViewController.h
//  frontier_scientists
//
//  Created by Bob Torgerson on 11/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DataTableiPadViewController : UIViewController <UITableViewDelegate> {
	IBOutlet UITableView *dataTable;
	CGSize cellSize;	
	NSMutableArray *dataArray;
	
	NSMutableDictionary *point;
	NSString *currentElement;
	NSMutableString * currentName, * currentSub, * currentText, * currentLink, *currentImage;
	NSMutableString *currentLatStr, *currentLonStr, *currentVidCountStr;
	NSMutableString *currentVidName, *currentVidLinks, *currentMapImg;
	UIActivityIndicatorView *progressIndicator;
	
}

@property (nonatomic, retain) UIActivityIndicatorView *progressIndicator;
@property (nonatomic, retain) IBOutlet UITableView *dataTable;
@property (nonatomic, retain) NSMutableArray *dataArray;

- (UIActivityIndicatorView *)progressIndicator;



@end