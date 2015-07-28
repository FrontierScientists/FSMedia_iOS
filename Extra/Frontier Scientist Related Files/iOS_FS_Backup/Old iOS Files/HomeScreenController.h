//
//  HomeScreenController.h
//  frontier_scientists
//
//  Created by Bob Torgerson on 7/13/11.
//  Copyright 2011 ARSC. All rights reserved.
//

@class AskAScientistViewController;
@class Reachability;
@class HelpViewController;

#import <UIKit/UIKit.h>

@interface HomeScreenController : UIViewController <UITableViewDelegate> {
	IBOutlet UITableView *movieTableView;
	//CGSize cellSize;	
	NSMutableArray *dataArray;
	NSMutableArray *movieNameArray;
	NSMutableArray *movieMP4Array;
	NSMutableArray *movie3GPArray;
	NSMutableArray *movieUTubeArray;
	Reachability *internetReachable;
	Reachability *hostReachable;
	BOOL internetActive;
	BOOL hostActive;
	BOOL downloaded;
	IBOutlet AskAScientistViewController *askAScientistViewController;
	IBOutlet HelpViewController *helpViewController;
	IBOutlet UIImageView *imageView;
	IBOutlet UIImageView *topImageView;
	UIActivityIndicatorView *progressIndicator;
	UIImageView *tempImg;
	NSMutableDictionary *oncallDict;
}

@property (nonatomic, retain) IBOutlet UITableView *movieTableView;
@property (nonatomic, retain) IBOutlet AskAScientistViewController *askAScientistViewController;
@property (nonatomic, retain) IBOutlet HelpViewController *helpViewController;
@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) IBOutlet UIImageView *topImageView;
@property (nonatomic, retain) NSMutableArray *dataArray;
@property (nonatomic, retain) NSMutableArray *movieNameArray;
@property (nonatomic, retain) NSMutableArray *movieMP4Array;
@property (nonatomic, retain) NSMutableArray *movie3GPArray;
@property (nonatomic, retain) NSMutableArray *movieUTubeArray;
@property (nonatomic, retain) UIActivityIndicatorView *progressIndicator;
@property (nonatomic, retain) UIImageView *tempImg;
@property BOOL downloaded;
@property (nonatomic, retain) NSMutableDictionary *oncallDict;

- (UIActivityIndicatorView *)progressIndicator;
NSArray *PerformHTMLXPathQuery(NSData *document, NSString *query);
NSArray *PerformXMLXPathQuery(NSData *document, NSString *query);

//- (void) checkNetworkStatus:(NSNotification *)notice;
- (BOOL) connectedToNetwork;
- (void) choosePicture;
- (void) startParsing;

-(IBAction)pushHelpView:(id)sender;
-(IBAction)pushScientist:(id)sender;
  
@end
