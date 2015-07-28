//
//  XMLParser.m
//  frontier_scientists
//
//  Created by Bob Torgerson on 7/1/11.
//  Copyright 2011 ARSC. All rights reserved.
//

#import "XMLParser.h"
#import "InitialTableViewController.h"

@implementation XMLParser

@synthesize mpAnnotations;
@synthesize currentProperty;
@synthesize currentValue;
@synthesize researchDict;
@synthesize dataArray;
@synthesize projectArray;
@synthesize vidArray;
@synthesize mapArray;
@synthesize oncallDict;
@synthesize scientistArray;
@synthesize scientistDict;
@synthesize element;
@synthesize articleImage;
@synthesize currentDict;


- (void)parseXMLData:(NSData *)data {
	NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
	
	[parser setDelegate:self];
    [parser setShouldProcessNamespaces:NO];
    [parser setShouldReportNamespacePrefixes:NO];
    [parser setShouldResolveExternalEntities:NO];
	
	self.oncallDict = [[NSMutableDictionary alloc] init];
	self.dataArray = [[NSMutableArray alloc] init];
	self.mpAnnotations = [[NSMutableArray alloc] init];

    [parser parse];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    if (qName) {
        elementName = qName;
    }
    
    //NSLog(@"start: %@", elementName);
    
	if ([elementName isEqualToString:@"research"]) {
		researchDict = [[NSMutableDictionary alloc] init];
        projectArray = [[NSMutableArray alloc] init];
        vidArray = [[NSMutableArray alloc] init];
        mapArray = [[NSMutableArray alloc] init];
	}
    
    if([elementName isEqualToString:@"projects"] || [elementName isEqualToString:@"maps"] || [elementName isEqualToString:@"scientist_on_call"] || [elementName isEqualToString:@"videos"]) {
        currentDict = [[NSMutableDictionary alloc] init];
    }
	
    if([elementName isEqualToString:@"AboutPage"] || [elementName isEqualToString:@"last_update"])
    {
        self.currentProperty = [[NSMutableString alloc] init];
    }
    
	if ([elementName isEqualToString:@"name"] || [elementName isEqualToString:@"post_content"] || [elementName isEqualToString:@"post_title"] || [elementName isEqualToString:@"utubeurl"] || [elementName isEqualToString:@"picture"] || [elementName isEqualToString:@"bio"] || [elementName isEqualToString:@"meta_value"]) {
		self.currentProperty = [[NSMutableString alloc] init];
	}

	if ([elementName isEqualToString:@"downloadMP4"] ||  [elementName isEqualToString:@"download3GP"] || [elementName isEqualToString:@"preview"]) {
		self.currentProperty = [[NSMutableString alloc] init];
	}
	
	if ([elementName isEqualToString:@"longitude"] || [elementName isEqualToString:@"latitude"]) {
		self.currentProperty = [[NSMutableString alloc] init];
	}
}


- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if (string && [string length] > 0) {
        [self.currentProperty appendString:string];
    }
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    //NSLog(@"NSXMLParser ERROR: %@ - %@", [parseError localizedDescription], [parseError localizedFailureReason]);
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    //NSLog(@"end: %@", elementName);
    
    if ([elementName isEqualToString:@"research"]) {
        [self.researchDict setObject:self.projectArray forKey:@"projects"];
        [self.researchDict setObject:self.vidArray forKey:@"videos"];
        [self.researchDict setObject:self.mapArray forKey:@"maps"];
	}
    else if ([elementName isEqualToString:@"projects"]) {
        vidArray = [[NSMutableArray alloc] init];
        [self.projectArray addObject:[self.currentDict copy]];
	}
    else if ([elementName isEqualToString:@"videos"]) {
		[self.vidArray addObject:[self.currentDict copy]];
	}
    else if ([elementName isEqualToString:@"utubeurl"]) {
		[self.currentDict setObject:self.currentProperty forKey:@"utubeurl"];
	}
    else if ([elementName isEqualToString:@"name"]) {
        //NSLog(@"name: %@", self.currentProperty);
		[self.currentDict setObject:self.currentProperty forKey:@"name"];
	}
    else if ([elementName isEqualToString:@"post_title"]) {
		[self.currentDict setObject:self.currentProperty forKey:@"post_title"];
	}
    else if ([elementName isEqualToString:@"post_content"]) {
		[self.currentDict setObject:self.currentProperty forKey:@"post_content"];
	}
    else if ([elementName isEqualToString:@"maps"]) {
		[self.mapArray addObject:[self.currentDict copy]];
	}
    else if ([elementName isEqualToString:@"longitude"]) {
		self.currentValue = [[NSNumber alloc] initWithDouble:[self.currentProperty doubleValue]];
		[self.currentDict setValue:self.currentValue forKey:@"longitude"];
	}
    else if ([elementName isEqualToString:@"latitude"]) {
		self.currentValue = [[NSNumber alloc] initWithDouble:[self.currentProperty doubleValue]];
		[self.currentDict setValue:self.currentValue forKey:@"latitude"];
	}
    else if ([elementName isEqualToString:@"scientist_on_call"]) {
		[self.researchDict setObject:self.currentDict forKey:@"scientist_on_call"];
	}
    else if ([elementName isEqualToString:@"picture"] || [elementName isEqualToString:@"meta_value"] || [elementName isEqualToString:@"research_image"]) {
        NSURL *url = [NSURL URLWithString:self.currentProperty];
        NSData *data = [[NSData alloc] init];
            NSLog(@"in here");
            //pull picture from database on phone
            data = [self loadImage:[self getImageName:self.currentProperty] inDirectory:@"temp" asExtension:[url pathExtension]];
        //}
        /*else
        {
            //save image to database on phone
            UIImage *image = [UIImage imageWithData:data];
            [self saveImage:image inDirectory:@"temp" withFileName:[self getImageName:self.currentProperty] asExtension:[url pathExtension]];
        }*/
        //UIImage *image = [UIImage imageWithData:data];
		//[self.currentDict setObject:image forKey:@"picture"];
        [self.currentDict setObject:data forKey:@"picture"];
	}
    else if ([elementName isEqualToString:@"bio"]) {
        [self.currentDict setObject:self.currentProperty forKey:@"bio"];
	}
    else if ([elementName isEqualToString:@"downloadMP4"]) {
		[self.currentDict setObject:self.currentProperty forKey:@"downloadMP4"];
	}
    else if ([elementName isEqualToString:@"download3GP"]) {
		[self.currentDict setObject:self.currentProperty forKey:@"download3GP"];
	}
    else if ([elementName isEqualToString:@"research_image"]) {
        NSURL *url = [NSURL URLWithString:self.currentProperty];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *image = [UIImage imageWithData:data];
		[self.currentDict setObject:image forKey:@"picture"];
	}
    else if ([elementName isEqualToString:@"AboutPage"]) {
		[self.researchDict setObject:self.currentProperty forKey:@"AboutPage"];
	}
    else if ([elementName isEqualToString:@"last_update"]){
        NSDateFormatter *myFormatter = [[NSDateFormatter alloc] init];
        myFormatter.dateFormat = @"MM/dd/yyyy";
        NSDate *theDate = [myFormatter dateFromString:self.currentProperty];
        [self.researchDict setObject:theDate forKey:@"last_update"];
    }
	self.currentProperty = nil;
}

-(NSString *)getImageName:(NSString *)url
{
    NSArray *compArray = [url pathComponents];
    int size = [compArray count];
    return compArray[size-1];
}

/*
- (void)saveImage:(UIImage *)image inDirectory:(NSString *)directory withFileName:(NSString *)name asExtension:(NSString *)extension;
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
}*/

- (NSData *)loadImage:(NSString *)name inDirectory:(NSString *)directory asExtension:(NSString *)extension
{
    
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@", directory]];
    NSData *data = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", filePath, name]];
    
    return data;
}



@end