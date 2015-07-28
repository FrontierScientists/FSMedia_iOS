//
//  SessionUpdateHandler.m
//  FSDemo
//
//  Created by alandrews3 on 7/24/14.
//  Copyright (c) 2014 Andrew Clark. All rights reserved.
//

#import "SessionUpdateHandler.h"

@implementation SessionUpdateHandler


@synthesize xmlUpdate;
@synthesize _responseData;
@synthesize defaults;
@synthesize researchDict;
@synthesize parseAsWellBool;

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
    }
    
    xmlUpdate.fireDate = dateToUpdate;
    xmlUpdate.timeZone = [NSTimeZone timeZoneWithName:@"US/Alaska"];
    NSMutableDictionary *dummyDict = [[NSMutableDictionary alloc] init];
    [dummyDict setObject:notificationName forKey:@"name"];
    xmlUpdate.userInfo = dummyDict;
    [[UIApplication sharedApplication] scheduleLocalNotification:xmlUpdate];
    
    NSLog(@"Notification %@ created", notificationName);
}


-(void)deleteCurrentNotifications
{
    for(UILocalNotification *notification in [[[UIApplication sharedApplication] scheduledLocalNotifications] copy])
    {
        if([[notification.userInfo objectForKey:@"name" ] isEqualToString:@"updateAtMidnight"])
        {
            [[UIApplication sharedApplication] cancelLocalNotification:notification];
            NSLog(@"Canceled update notification.");
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
        [self downloadAndParseXML];
    }
}

-(void)checkForXmlFile
{
    NSString *documentsDir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
	NSString *xmlFile = [documentsDir stringByAppendingString:@"/dumpedSelectQuery.xml"];
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    if(![fileMgr fileExistsAtPath:xmlFile])
    {
        [self downloadAndParseXML];
    }
}

-(void)downloadAndParseXML
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Frontier Scientists"
                                                        message:@"Update in progress"
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:nil, nil];
    NSLog(@"scientist name before: %@",[[[[NSUserDefaults standardUserDefaults] objectForKey:@"researchDict"] objectForKey:@"scientist_on_call"] objectForKey:@"name"]);
    
    [alertView show];
    
    parseAsWellBool = YES;
    [self downloadXMLFile];
    
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
}

-(void)downloadXMLFile
{
    NSURLRequest *theRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://frontsci.arsc.edu/dumpedSelectQuery.xml"]
                                                cachePolicy:NSURLRequestUseProtocolCachePolicy
                                            timeoutInterval:60.0];
    _responseData = [NSMutableData dataWithCapacity:0];
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    /*
     NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:@"https://frontsci.arsc.edu/dumpedSelectQuery.xml"]];
     NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
     NSString *documentsDirectory = [paths objectAtIndex:0];
     
     // the path to write file
     NSString *appFile = [documentsDirectory stringByAppendingPathComponent:@"dumpedSelectQuery.xml"];
     NSLog(@"Path to the XML file: %@", appFile);
     [data writeToFile:appFile atomically:YES];
     NSLog(@"Content of the XML file: %@", data);
     */
    
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
    NSLog(@"Update finished.");
    return [parser researchDict];
}


#pragma mark NSURLConnection Delegate Methods
-(void)session:(NSURLSession *)session didReceiveResponse:(NSURLResponse *)response
{
    self._responseData = [[NSMutableData alloc] init];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self._responseData appendData:data];
    //NSLog(@"Data received.");
}

-(NSCachedURLResponse *)session:(NSURLSession *)session willCacheResponse:(NSCachedURLResponse *)cachedResponse
{
    return nil;
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //NSLog(@"Request loaded successfully.");
    
    NSData *data = [NSData dataWithData:_responseData];
    
    NSFileManager *fileMgr = [NSFileManager defaultManager];
	NSString *documentsDir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
	
    NSString *xmlFile = [documentsDir stringByAppendingPathComponent:@"dumpedSelectQuery.xml"];
    
    if([data writeToFile:xmlFile atomically:YES])
    {
        NSLog(@"Write is successful.");
    }
    
    if([fileMgr fileExistsAtPath:xmlFile])
    {
        //NSLog(@"File was saved and found!");
    }
    NSLog(@"Download finished");
    
    if(parseAsWellBool)
    {
        researchDict = [[NSMutableDictionary alloc] init];
        researchDict = [self startParsing];
        defaults = [NSUserDefaults standardUserDefaults];
        [defaults removeObjectForKey:@"researchDict"];
        [defaults setObject:self.researchDict forKey:@"researchDict"];
        [defaults synchronize];
        NSLog(@"scientist name after: %@",[[[[NSUserDefaults standardUserDefaults] objectForKey:@"researchDict"] objectForKey:@"scientist_on_call"] objectForKey:@"name"]);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"update" object:nil];
    }
    NSLog(@" ");
    NSLog(@" ");
}

-(void)session:(NSURLSession *)session didFailWithError:(NSError *)error
{
    NSLog(@"Request has failed!");
}

-(BOOL)session:(NSURLSession *)session canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
    return YES;
    
}

-(void)session:(NSURLSession *)session didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    if([challenge.protectionSpace.host isEqualToString:@"frontsci.arsc.edu"])
        [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
    //NSLog(@"Authentication has been challenged.");
}



@end
