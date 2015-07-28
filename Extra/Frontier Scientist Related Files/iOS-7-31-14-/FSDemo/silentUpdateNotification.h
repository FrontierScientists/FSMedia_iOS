//
//  silentUpdateNotification.h
//  FSDemo
//
//  Created by alandrews3 on 7/11/14.
//  Copyright (c) 2014 Andrew Clark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMLParser.h"

@interface silentUpdateNotification : UILocalNotification <NSURLConnectionDelegate>

@property UILocalNotification *xmlUpdate;
@property NSMutableData *_responseData;
@property silentUpdateNotification *silentUpdate;

-(void)downloadXMLFile;

@end
