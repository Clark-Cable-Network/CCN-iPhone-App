//
//  XMLParserVideo.h
//  CCN
//
//  Created by Zachary Hariton on 1/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>

@class XMLAppDelegate, Book;

@interface XMLParserSchedule : NSObject {
	
	NSMutableString *currentElementValue;
	int currentElementShowLocation;
	BOOL useThisElement, firstElement;
	
	XMLAppDelegate *appDelegate;
	NSMutableArray *Days;
}

@property (nonatomic, retain) NSMutableArray *Days;

- (XMLParserSchedule *) initXMLParser;
-(NSMutableArray*)getDays;

@end