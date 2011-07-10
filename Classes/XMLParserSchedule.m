//
//  XMLParserVideo.m
//  CCN
//
//  Created by Zachary Hariton on 1/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "XMLParserSchedule.h"
#import "FirstViewController.h"
#import "Day.h"
#import "Event.h"

@implementation XMLParserSchedule

@synthesize Days;

- (XMLParserSchedule *) initXMLParser {
	
	[super init];
	
	appDelegate = (XMLAppDelegate *)[[UIApplication sharedApplication] delegate];
	Days = [[NSMutableArray alloc] init];
	firstElement = YES;
	
	return self;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName
	attributes:(NSDictionary *)attributeDict {
	if ([elementName isEqualToString:@"Article"])
        useThisElement = YES;
	else
		useThisElement = NO;
}
					 
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string { 
	if (useThisElement) {
		if(!currentElementValue)
			currentElementValue = [[NSMutableString alloc] initWithString:string];
		else
			[currentElementValue setString:string];
		currentElementValue = [currentElementValue stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
		currentElementValue = [currentElementValue stringByReplacingOccurrencesOfString:@"</p>" withString:@""];
	}
}
					 
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName 
namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	if (useThisElement) {
        NSMutableArray *data = [[currentElementValue componentsSeparatedByString:@"~"] mutableCopy];
		Event *eventTemp = [[Event alloc] init];
        [eventTemp setName:[data objectAtIndex:0]];
        [eventTemp setDay:[data objectAtIndex:1]];
        [eventTemp setStartTime:[data objectAtIndex:2]];
        [eventTemp setEndTime:[data objectAtIndex:3]];
        [eventTemp setMonth:[[data objectAtIndex:4] intValue]];
        [eventTemp setYear:[[data objectAtIndex:5] intValue]];
        [eventTemp setImage:[data objectAtIndex:6]];
        [data removeObjectAtIndex:0];
        [data removeObjectAtIndex:0];
        [data removeObjectAtIndex:0];
        [data removeObjectAtIndex:0];
        [data removeObjectAtIndex:0];
        [data removeObjectAtIndex:0];
        [data removeObjectAtIndex:0];
        [eventTemp setBody:data];
        
        int Count = 0;
		currentElementShowLocation = -1;
        
        for (Day *dayTemp in Days)	{
			if ([[dayTemp getName] isEqualToString:[eventTemp getDay]]) {
				currentElementShowLocation = Count;
			}
			Count++;
		}
        
		if (currentElementShowLocation == -1)	{
			Day *dayTemp = [[Day alloc] init];
			NSMutableArray *eventsTemp = [[NSMutableArray alloc] init];
			[eventsTemp addObject:dayTemp];
            [dayTemp setEvents:eventsTemp];
			[dayTemp setName:[eventTemp getDay]];
			[Days addObject:dayTemp];
			[dayTemp release];	//Might cause crash
			//[episodesTemp release];
		}
		else	{
			[[Days objectAtIndex:currentElementShowLocation] addEvent:eventTemp];
		}
		[currentElementValue setString:@""];
		[eventTemp release];	//Might cause crash
        useThisElement = NO;
	}
}

-(NSMutableArray*)getDays	{
	return Days;
}

- (void) dealloc {
	[Days release];
	[currentElementValue release];
	[appDelegate release];
	[super dealloc];
}

@end
