//
//  XMLParser.m
//  frontier_scientists
//
//  Created by Bob Torgerson on 7/1/11.
//  Copyright 2011 ARSC. All rights reserved.
//

#import "XMLParser.h"
#import "MyMapAnnotations.h"
#import "HomeScreenController.h"

@implementation XMLParser

@synthesize mpAnnotations;
@synthesize theMapAnnotation;
@synthesize currentProperty;
@synthesize currentValue;
@synthesize dataArray;
@synthesize researchDict;
@synthesize vidArray;
@synthesize vidDict;
@synthesize oncallDict;
@synthesize scientistArray;
@synthesize scientistDict;


- (void)parseXMLData:(NSData *)data {
	NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
	
	[parser setDelegate:self];
    [parser setShouldProcessNamespaces:NO];
    [parser setShouldReportNamespacePrefixes:NO];
    [parser setShouldResolveExternalEntities:NO];
	
	self.oncallDict = [[NSMutableDictionary alloc] init];
	self.dataArray = [[NSMutableArray alloc] init];
	self.theMapAnnotation = nil;
	self.mpAnnotations = [[NSMutableArray alloc] init];
    
    [parser parse];
    
	[parser release];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    if (qName) {
        elementName = qName;
    }
	
	if ([elementName isEqualToString:@"research"]) {
		self.researchDict = [[NSMutableDictionary alloc] init];
		self.theMapAnnotation = [[MyMapAnnotations alloc] init];
	}
	
	if ([elementName isEqualToString:@"research_title"] || [elementName isEqualToString:@"content"] || [elementName isEqualToString:@"title"] || [elementName isEqualToString:@"utubeurl"] || [elementName isEqualToString:@"oncall_brief"]) { 
		self.currentProperty = [[NSMutableString alloc] init];
	}

	if ([elementName isEqualToString:@"downloadMP4"] || [elementName isEqualToString:@"subtitle"] || [elementName isEqualToString:@"download3GP"] || [elementName isEqualToString:@"preview"] || [elementName isEqualToString:@"research_image"]) {
		self.currentProperty = [[NSMutableString alloc] init];
	}
	
	if ([elementName isEqualToString:@"oncall_image"] || [elementName isEqualToString:@"longitude"] || [elementName isEqualToString:@"latitude"] || [elementName isEqualToString:@"name"] || [elementName isEqualToString:@"link"]) {
		self.currentProperty = [[NSMutableString alloc] init];
	}
	
	if ([elementName isEqualToString:@"video-all"]) {
		self.vidArray = [[NSMutableArray alloc] init];
	}
	
	if ([elementName isEqualToString:@"video"]) {
		self.vidDict = [[NSMutableDictionary alloc] init];
	}
	
	if ([elementName isEqualToString:@"scientists-all"]) {
		self.scientistArray = [[NSMutableArray alloc] init];
	}
	
	if ([elementName isEqualToString:@"scientists"]) {
		self.scientistDict = [[NSMutableDictionary alloc] init];
	}
}



- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if (self.currentProperty && string && [string length] > 0) {
        [currentProperty appendString:string];
    }
}



- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	
	if ([elementName isEqualToString:@"research_title"]) {
		[self.theMapAnnotation setMytitle:self.currentProperty];
		[self.researchDict setObject:self.currentProperty forKey:@"research_title"];
	} else if ([elementName isEqualToString:@"latitude"]) {
		self.currentValue = [[NSNumber alloc] initWithDouble:[self.currentProperty doubleValue]];
		[self.theMapAnnotation setLatitude:self.currentValue];
		[self.currentValue release];
		[self.researchDict setObject:self.currentProperty forKey:@"latitude"];
	} else if ([elementName isEqualToString:@"longitude"]) {
		self.currentValue = [[NSNumber alloc] initWithDouble:[self.currentProperty doubleValue]];
		[self.theMapAnnotation setLongitude:self.currentValue];
		[self.researchDict setObject:self.currentProperty forKey:@"longitude"];
		[self.currentValue release];
	} else if ([elementName isEqualToString:@"subtitle"]) {
		[self.theMapAnnotation setSubttl:self.currentProperty];
		[self.researchDict setObject:self.currentProperty forKey:@"subtitle"];
	} else if ([elementName isEqualToString:@"title"]) {
		[self.vidDict setObject:self.currentProperty forKey:@"title"];
	} else if ([elementName isEqualToString:@"utubeurl"]) {
		[self.vidDict setObject:self.currentProperty forKey:@"utubeurl"];
	} else if ([elementName isEqualToString:@"downloadMP4"]) {
		[self.vidDict setObject:self.currentProperty forKey:@"downloadMP4"];
	} else if ([elementName isEqualToString:@"download3GP"]) {
		[self.vidDict setObject:self.currentProperty forKey:@"download3GP"];
	} else if ([elementName isEqualToString:@"preview"]) {
		[self.vidDict setObject:self.currentProperty forKey:@"preview"];
	} else if ([elementName isEqualToString:@"research_image"]) {
		[self.theMapAnnotation setImageName:self.currentProperty];
		[self.researchDict setObject:self.currentProperty forKey:@"image"];
	} else if ([elementName isEqualToString:@"content"]) {
		[self.theMapAnnotation setText:self.currentProperty];
		[self.researchDict setObject:self.currentProperty forKey:@"text"];
    } else if ([elementName isEqualToString:@"name"]) {
		[self.scientistDict setObject:self.currentProperty forKey:@"name"];
	} else if ([elementName isEqualToString:@"link"]) {
		[self.scientistDict setObject:self.currentProperty forKey:@"link"];
	} else if ([elementName	isEqualToString:@"scientists"]) {
		[self.scientistArray addObject:[self.scientistDict copy]];
	} else if ([elementName isEqualToString:@"scientists-all"]) {
		[self.researchDict setObject:self.scientistArray forKey:@"scientists"];
	} else if ([elementName isEqualToString:@"oncall_image"]) {
		[self.oncallDict setObject:self.currentProperty forKey:@"image"];
	} else if ([elementName isEqualToString:@"oncall_brief"]) {
		[self.oncallDict setObject:self.currentProperty forKey:@"oncall_brief"];
	} else if ([elementName isEqualToString:@"video"]) {
		[self.vidArray addObject:[self.vidDict copy]];
	} else if ([elementName isEqualToString:@"video-all"]) {
		[self.researchDict setObject:[self.vidArray copy] forKey:@"videos"];
	} else if ([elementName isEqualToString:@"research"]) {
		[self.theMapAnnotation setResearchDictionary:[self.researchDict copy]];
		[self.mpAnnotations addObject:self.theMapAnnotation];
		[self.dataArray addObject:[self.researchDict copy]];
	}
	
	self.currentProperty = nil;
}


- (void)dealloc {
	[currentValue release];
	[currentProperty release];
	[theMapAnnotation release];
	[mpAnnotations release];
	[dataArray release];
	[researchDict release];
	[vidArray release];
	[vidDict release];
	[oncallDict release];
	[scientistArray release];
	[scientistDict release];
	[super dealloc];
}

@end
