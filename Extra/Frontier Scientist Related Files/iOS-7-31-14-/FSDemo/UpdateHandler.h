//
//  UpdateHandler.h
//  FSDemo
//
//  Created by alandrews3 on 7/18/14.
//  Copyright (c) 2014 Andrew Clark. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMLParser.h"

@interface UpdateHandler : NSURLConnection<NSURLConnectionDelegate, NSURLSessionDelegate, NSURLSessionTaskDelegate, NSURLSessionDataDelegate, NSXMLParserDelegate>

@property UILocalNotification *xmlUpdate;
@property NSMutableData *_responseData;
@property NSUserDefaults *defaults;
@property NSMutableDictionary *researchDict;
@property BOOL parseAsWellBool;
@property BOOL downloadIsFinished;
@property NSMutableData *downloadData;
@property NSURLSession *downloadSession;
@property NSURLSessionDataTask *task;
@property NSMutableString *imageData;


-(void)createUpdateNotification:(NSString *)notificationName;
-(void)deleteCurrentNotificationsNamed:(NSString *)name;
-(void)checkForUpdates;
-(void)checkForXmlFile;
-(NSMutableDictionary *)startParsing;
-(void)saveAndParseData:(NSData *)data;
-(void)saveData:(NSData *)data;
-(void)parseData;
-(void)readydownloadSession;
-(void)parseAndSaveImages:(NSData *)data;
-(NSString *)getImageName:(NSString *)url;
-(void)saveImage:(UIImage *)image inDirectory:(NSString *)directory withFileName:(NSString *)name asExtension:(NSString *)extension;
- (void)createTempFolder;
- (void)replaceImagesFolderWithTemp;

@end
