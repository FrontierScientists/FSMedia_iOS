//
//  ArticlesTableViewController.h
//  FSDemo
//
//  Created by alandrews3 on 5/15/14.
//  Copyright (c) 2014 Andrew Clark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArticlesViewController.h"

@interface ArticlesTableViewController : UITableViewController
{
    UIActivityIndicatorView *activityIndicator;
    
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


@property NSString *storyLink;
@property NSUInteger storyIndex;
@property (nonatomic, retain) UIActivityIndicatorView *progressIndicator;
- (UIActivityIndicatorView *)progressIndicator;


@end
