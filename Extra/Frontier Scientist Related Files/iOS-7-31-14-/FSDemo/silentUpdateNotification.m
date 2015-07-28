//
//  silentUpdateNotification.m
//  FSDemo
//
//  Created by alandrews3 on 7/11/14.
//  Copyright (c) 2014 Andrew Clark. All rights reserved.
//

#import "silentUpdateNotification.h"

@implementation silentUpdateNotification

@synthesize xmlUpdate;
@synthesize _responseData;
@synthesize silentUpdate;


#pragma mark NSURLConnection Delegate Methods
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self._responseData = [[NSMutableData alloc] init];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self._responseData appendData:data];
    NSLog(@"Data received.");
}

-(NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse
{
    return nil;
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"Request loaded successfully.");
    
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
        NSLog(@"File was saved and found!");
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSLog(@"Path to downloaded XML file: %@", xmlFile);
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Request has failed!");
}

-(BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
    return YES;
    
}

-(void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    if([challenge.protectionSpace.host isEqualToString:@"frontsci.arsc.edu"])
        [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
    NSLog(@"Authentication has been challenged.");
}

-(void)downloadXMLFile
{
    NSLog(@"HERE1.1");
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

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:@"parsingNeeded" forKey:@"parsingStatus"];
    [defaults synchronize];
}


@end
