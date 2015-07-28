//
//  XMLParser.h
//  frontier_scientists
//
//  Created by Bob Torgerson on 7/1/11.
//  Copyright 2011 ARSC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MyMapAnnotations;

@interface XMLParser : NSObject <NSXMLParserDelegate> {
	NSMutableArray *mpAnnotations;
	MyMapAnnotations *theMapAnnotation;
	NSMutableString *currentProperty;
	NSNumber *currentValue;
	NSMutableArray *dataArray;
	NSMutableDictionary *researchDict;
	NSMutableArray *vidArray;
	NSMutableDictionary *vidDict;
	NSMutableDictionary *oncallDict;
	NSMutableArray *scientistArray;
	NSMutableDictionary *scientistDict;
}
	
@property (nonatomic, retain) NSMutableArray *mpAnnotations;
@property (nonatomic, retain) MyMapAnnotations *theMapAnnotation;
@property (nonatomic, retain) NSMutableString *currentProperty;
@property (nonatomic, retain) NSNumber *currentValue;
@property (nonatomic, retain) NSMutableArray *dataArray;
@property (nonatomic, retain) NSMutableDictionary *researchDict;
@property (nonatomic, retain) NSMutableDictionary *vidDict;
@property (nonatomic, retain) NSMutableArray *vidArray;
@property (nonatomic, retain) NSMutableDictionary *oncallDict;
@property (nonatomic, retain) NSMutableArray *scientistArray;
@property (nonatomic, retain) NSMutableDictionary *scientistDict;

- (void)parseXMLData:(NSData *)data;

@end
