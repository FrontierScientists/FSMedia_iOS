//
//  SessionUpdateHandler.h
//  FSDemo
//
//  Created by alandrews3 on 7/24/14.
//  Copyright (c) 2014 Andrew Clark. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMLParser.h"

@interface SessionUpdateHandler : NSURLSession<NSURLSessionDelegate>

@property UILocalNotification *xmlUpdate;
@property NSMutableData *_responseData;
@property NSUserDefaults *defaults;
@property NSMutableDictionary *researchDict;
@property BOOL parseAsWellBool;

-(void)createUpdateNotification:(NSString *)notificationName;
-(void)deleteCurrentNotifications;
-(void)checkForUpdates;
-(void)checkForXmlFile;
-(void)downloadAndParseXML;
-(void)downloadXMLFile;
-(NSMutableDictionary *)startParsing;

@end
