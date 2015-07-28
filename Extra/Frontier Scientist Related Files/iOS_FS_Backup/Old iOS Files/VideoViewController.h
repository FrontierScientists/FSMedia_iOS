//
//  VideoViewController.h
//  frontier_scientists
//
//  Created by Bob Torgerson on 6/30/11.
//  Copyright 2011 ARSC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YouTubeView;

@interface VideoViewController : UIViewController {
	NSString *videoName;
	NSString *saveName;
	NSString *selection;
	UILabel *selectedVidName;
	//UIActivityIndicatorView *progressIndicator;
	UIProgressView *progressView;
	UIButton *playButton, *deleteButton, *downloadButton, *closeButton;
	YouTubeView *youTubeView;
	NSString *youTubeName;
	CGRect tabBarFrame;
}

@property (nonatomic, retain) NSString *videoName;
@property (nonatomic, retain) NSString *saveName;
@property (nonatomic, retain) NSString *selection;
//@property (nonatomic, retain) UIActivityIndicatorView *progressIndicator;
@property (nonatomic, retain) IBOutlet UIProgressView *progressView;
@property (nonatomic, retain) IBOutlet UIButton *playButton;
@property (nonatomic, retain) IBOutlet UILabel *selectedVidName;
@property (nonatomic, retain) IBOutlet UIButton *deleteButton;
@property (nonatomic, retain) IBOutlet UIButton *downloadButton;
@property (nonatomic, retain) NSString *youTubeName;

- (IBAction) playMovie;
- (IBAction) deleteMovie;
- (IBAction) downloadHiResMovie;
- (IBAction) downloadLoResMovie;
- (IBAction) streamMovie;
- (IBAction) streamYouTube;
- (void)downloadHiVid;
- (BOOL)connectedToNetwork;
- (BOOL)connectedToWiFi;

@end
