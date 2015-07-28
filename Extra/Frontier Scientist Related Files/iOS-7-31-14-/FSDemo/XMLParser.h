//
//  XMLParser.h
//  frontier_scientists
//
//  Created by Bob Torgerson on 7/1/11.
//  Copyright 2011 ARSC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMLParser : NSObject <NSXMLParserDelegate> {
	NSMutableArray *mpAnnotations;
	NSMutableString *currentProperty;
	NSNumber *currentValue;
    NSMutableDictionary *researchDict;
	NSMutableArray *dataArray;
	NSMutableArray *vidArray;
    NSMutableArray *mapArray;
	NSMutableDictionary *oncallDict;
	NSMutableArray *scientistArray;
	NSMutableDictionary *scientistDict;
}
	
@property (nonatomic, retain) NSMutableArray *mpAnnotations;
//@property (nonatomic, retain) MyMapAnnotations *theMapAnnotation;
@property (nonatomic, retain) NSMutableString *currentProperty;
@property (nonatomic, retain) NSNumber *currentValue;
@property (nonatomic, retain) NSMutableDictionary *researchDict;
@property (nonatomic, retain) NSMutableArray *dataArray;
@property (nonatomic, retain) NSMutableArray *projectArray;
@property (nonatomic, retain) NSMutableArray *mapArray;
@property (nonatomic, retain) NSMutableArray *vidArray;
@property (nonatomic, retain) NSMutableDictionary *oncallDict;
@property (nonatomic, retain) NSMutableArray *scientistArray;
@property (nonatomic, retain) NSMutableDictionary *scientistDict;
@property (nonatomic, retain) NSMutableString *element;
@property (nonatomic, retain) UIImage *articleImage;
@property (nonatomic, retain) NSMutableDictionary *currentDict;
@property NSString *imageFileName;

- (void)parseXMLData:(NSData *)data;
- (void)indexVideos;
- (NSString *)getImageName:(NSString *)url;
- (void)saveImage:(NSString *)name inDirectory:(NSString *)directory asExtension:(NSString *)extension;
- (NSData *)loadImage:(NSString *)name inDirectory:(NSString *)directory asExtension:(NSString *)extension;
- (void)alternateSaveFile;
- (void)addAlertView;
- (void)saveImageToTemp:(NSString *)image :(NSData *)data;

@end
