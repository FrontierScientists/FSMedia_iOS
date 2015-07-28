//
//  UpdateHandler.m
//  FSDemo
//
//  Created by alandrews3 on 7/18/14.
//  Copyright (c) 2014 Andrew Clark. All rights reserved.
//

#import "UpdateHandler.h"

@implementation UpdateHandler


@synthesize xmlUpdate;
@synthesize _responseData;
@synthesize defaults;
@synthesize researchDict;
@synthesize parseAsWellBool;
@synthesize downloadIsFinished;
@synthesize downloadData;
@synthesize downloadSession;
@synthesize task;
@synthesize imageData;

//These are the notification functions
-(void)createUpdateNotification:(NSString *)notificationName
{
    NSDate *dateToUpdate = [[NSDate alloc] init];
    xmlUpdate = [[UILocalNotification alloc] init];
    
    if([notificationName isEqualToString:@"updateAtMidnight"])
    {
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        [calendar setTimeZone:[NSTimeZone timeZoneWithName:@"US/Alaska"]];
        
        NSDateComponents *dateComps = [calendar components:(NSDayCalendarUnit) fromDate:[NSDate date]];
        //[dateComps setHour:23];
        //[dateComps setMinute:59];
        //[dateComps setSecond:59];
        dateToUpdate = [calendar dateFromComponents:dateComps];
        
        xmlUpdate.repeatInterval = NSMinuteCalendarUnit;
        //xmlUpdate.repeatInterval = NSHourCalendarUnit;
    }
    else
    {
    }
    
    xmlUpdate.fireDate = dateToUpdate;
    xmlUpdate.timeZone = [NSTimeZone timeZoneWithName:@"US/Alaska"];
    NSMutableDictionary *dummyDict = [[NSMutableDictionary alloc] init];
    [dummyDict setObject:notificationName forKey:@"name"];
    xmlUpdate.userInfo = dummyDict;
    [[UIApplication sharedApplication] scheduleLocalNotification:xmlUpdate];
    
    NSLog(@"Notification %@ created", notificationName);
}


-(void)deleteCurrentNotificationsNamed:(NSString *)name
{
    for(UILocalNotification *notification in [[[UIApplication sharedApplication] scheduledLocalNotifications] copy])
    {
        if([[notification.userInfo objectForKey:@"name" ] isEqualToString:name])
        {
            [[UIApplication sharedApplication] cancelLocalNotification:notification];
            NSLog(@"Canceled %@ notification.", [notification.userInfo objectForKey:@"name" ]);
        }
    }
}


//These are the xml update functions
-(void)checkForUpdates
{
    NSDate *currentDate = [NSDate date];
    NSDate *lastUpdate = [[[NSUserDefaults standardUserDefaults] objectForKey:@"researchDict"] objectForKey:@"last_update"];
    NSComparisonResult result;
    result = [currentDate compare: lastUpdate];
    
    //NSLog(@"Checked for updates.");
    if(result == NSOrderedDescending)
    {
        NSLog(@"Update needed.");
        [self readydownloadSession];
        [task resume];
    }
}

-(void)checkForXmlFile
{
    NSString *documentsDir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
	NSString *xmlFile = [documentsDir stringByAppendingString:@"/dumpedSelectQuery.xml"];
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    if(![fileMgr fileExistsAtPath:xmlFile])
    {
        [self readydownloadSession];
        [task resume];
    }
}

-(NSMutableDictionary *)startParsing
{
    NSLog(@"Parsing began");
    NSString *documentsDir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
	NSString *xmlFile = [documentsDir stringByAppendingString:@"/dumpedSelectQuery.xml"];
    //NSLog(@"Path to get the XML file: %@", xmlFile);
    
    NSData *xmlData = [[NSData alloc] initWithContentsOfFile:xmlFile];
    //NSLog(@"Data of the XML file: %@", xmlData);
	XMLParser *parser = [[XMLParser alloc] init];
	[parser parseXMLData:xmlData];
    NSLog(@"Parsing finished.");
    return [parser researchDict];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask willCacheResponse:(NSCachedURLResponse *)proposedResponse completionHandler:(void (^)(NSCachedURLResponse *cachedResponse))completionHandler
{
    NSLog(@"Got here 2.");
    [self saveData:downloadData];
}

-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    NSLog(@"Got data");
    [downloadData appendData:data];
}

-(void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler
{
    NSLog(@"Got here 4.");
    NSURLCredential *cred = [NSURLCredential credentialWithUser:@"" password:@"" persistence:NSURLCredentialPersistencePermanent];
    completionHandler(NSURLSessionAuthChallengeUseCredential, cred);
}

-(void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(NSError *)error
{
    NSLog(@"Session encountered errors.");
}

+(NSString *)localizedStringForStatusCode:(NSString *)statusCode
{
    NSLog(@"Status code: %@", statusCode);
    return statusCode;
}

-(void)readydownloadSession
{
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    downloadSession = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:nil];
    NSURLRequest *urlRquest = [[NSURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:@"https://frontsci.arsc.edu/dumpedSelectQuery.xml"]];
    
    task = [downloadSession dataTaskWithRequest:urlRquest];
    
    //[downloadSession invalidateAndCancel];
}

-(void)saveData:(NSData *)data
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:@"dumpedSelectQuery.xml"];
    if([data writeToFile:appFile atomically:YES])
    {
        NSLog(@"Write using NSURLSession is successful.");
        [self parseAndSaveImages:data];
    }
}

-(void)parseData
{
    // Parse the downloaded file so the app will be ready for the user at its next use
    researchDict = [[NSMutableDictionary alloc] init];
    researchDict = [self startParsing];
    defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"researchDict"];
    [defaults setObject:researchDict forKey:@"researchDict"];
    [defaults synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"update" object:nil];
    NSLog(@"Update finished");
}



-(void)parseAndSaveImages:(NSData *)data
{
    NSLog(@"Parsing images began");
    NSXMLParser *imageParser = [[NSXMLParser alloc] initWithData:data];
	[imageParser setDelegate:self];
    [imageParser setShouldProcessNamespaces:NO];
    [imageParser setShouldReportNamespacePrefixes:NO];
    [imageParser setShouldResolveExternalEntities:NO];
    [self createTempFolder];
    [imageParser parse];
    NSLog(@"Parsing images finished.");
}


- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    if ([elementName isEqualToString:@"picture"] || [elementName isEqualToString:@"meta_value"] || [elementName isEqualToString:@"research_image"])
    {
		self.imageData = [[NSMutableString alloc] init];
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if (string && [string length] > 0)
    {
        [self.imageData appendString:string];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
	//NSLog(@"ended element: %@", elementName);
    if ([elementName isEqualToString:@"picture"] || [elementName isEqualToString:@"meta_value"] || [elementName isEqualToString:@"research_image"])
    {
        NSURL *url = [NSURL URLWithString:self.imageData];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *image = [UIImage imageWithData:data];
        [self saveImage:image inDirectory:@"temp" withFileName:[self getImageName:self.imageData] asExtension:[url pathExtension]];
    }
}

-(NSString *)getImageName:(NSString *)url
{
    NSArray *compArray = [url pathComponents];
    int size = [compArray count];
    return compArray[size-1];
}

- (void)saveImage:(UIImage *)image inDirectory:(NSString *)directory withFileName:(NSString *)name asExtension:(NSString *)extension
{
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@", directory]];
    
    if([[extension lowercaseString] isEqualToString:@"png"])
    {
        [UIImagePNGRepresentation(image) writeToFile:[filePath stringByAppendingPathComponent:name] options:NSAtomicWrite error:nil];
    }
    else if([[extension lowercaseString] isEqualToString:@"jpg"] || [[extension lowercaseString] isEqualToString: @"jpeg"])
    {
        [UIImageJPEGRepresentation(image, 1.0) writeToFile:[filePath stringByAppendingPathComponent:name] options:NSAtomicWrite error:nil];
    }
}

- (void)createTempFolder
{
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSString *filePathAndDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/temp"];
    NSError *error;
    if([fileMgr fileExistsAtPath:filePathAndDirectory])
    {
        return;
    }
    if (![[NSFileManager defaultManager] createDirectoryAtPath:filePathAndDirectory
                                   withIntermediateDirectories:NO
                                                    attributes:nil
                                                         error:&error])
    {
        NSLog(@"Create directory error: %@", error);
    }
}

- (void)replaceImagesFolderWithTemp
{
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSString *filePathAndDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/"];//temp"];
    [fileMgr replaceItemAtURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/images", filePathAndDirectory]]
                withItemAtURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/temp", filePathAndDirectory]]
               backupItemName:nil
                      options:NSFileManagerItemReplacementUsingNewMetadataOnly
             resultingItemURL:nil
                        error:nil];
}

@end
