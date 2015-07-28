//
//  RSSFeedViewController.h
//  frontier_scientists
//
//  Created by Bob Torgerson on 7/11/11.
//  Copyright 2011 ARSC. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RSSFeedViewController : UITableViewController <NSXMLParserDelegate>{
	
	IBOutlet UITableView * newsTable;
	
	UIActivityIndicatorView * activityIndicator;
	
	CGSize cellSize;
	
	NSXMLParser * rssParser;
	NSMutableArray * stories;
	
	
	// a temporary item; added to the "stories" array one at a time, and cleared for the next one
	NSMutableDictionary * item;
	
	// it parses through the document, from top to bottom...
	// we collect and cache each sub-element value, and then save each item to our array.
	// we use these to track each current item, until it's ready to be added to the "stories" array
	NSString * currentElement;
	NSMutableString * currentTitle, * currentDate, * currentSummary, * currentLink;
	
	UIActivityIndicatorView *progressIndicator;
	
	NSString * feed;
}

@property (nonatomic, retain) UIActivityIndicatorView *progressIndicator;

- (UIActivityIndicatorView *)progressIndicator;

@end
