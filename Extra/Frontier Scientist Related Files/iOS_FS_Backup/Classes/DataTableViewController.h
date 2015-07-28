//
//  DataTableViewController.h
//  frontier_scientists
//
//  Created by Bob Torgerson on 7/22/11.
//  Copyright 2011 ARSC. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "XMLParser.h"

@interface DataTableViewController : UITableViewController {
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

-(UIActivityIndicatorView *)progressIndicator;

-(void)downloadImages;

@end
