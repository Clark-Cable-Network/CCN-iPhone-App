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
	if ([elementName isEqualToString:@"Event"])
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
        NSMutableArray *data = [[currentElementValue componentsSeparatedByString:@"~S~"] mutableCopy];
        NSMutableArray *preBody = [[[data objectAtIndex:0] componentsSeparatedByString:@"~"] mutableCopy];
        NSString *Name = [preBody objectAtIndex:0];
        NSString *Image = [preBody objectAtIndex:1];
        NSMutableArray *Body = [[[data objectAtIndex:1] componentsSeparatedByString:@"~"] mutableCopy];
        [preBody removeObjectAtIndex:0];
        [preBody removeObjectAtIndex:0];
        for (int Count = 0; Count < [preBody count]; Count = Count+3) {
            Event *eventTemp = [[Event alloc] init];
            [eventTemp setName:Name];
            [eventTemp setImage:Image];
            [eventTemp setBody:Body];
            [eventTemp setAllTimes:preBody];
            [eventTemp setDay:[preBody objectAtIndex:Count]];
            [eventTemp setStartTime:[preBody objectAtIndex:Count+1]];
            [eventTemp setEndTime:[preBody objectAtIndex:Count+2]];
            BOOL newDay = YES;
            for (Day *dayTemp in Days) {
                if (newDay && [dayTemp.Name isEqualToString:eventTemp.Day])    {
                    newDay = NO;
                    [dayTemp addEvent:eventTemp];
                }
            }
            if (newDay) {
                Day *newDay = [[Day alloc] init];
                [newDay setName:eventTemp.Day];
                [newDay addEvent:eventTemp];
                [Days addObject:newDay];
                //Need to develop method to reorder days in the correct order.
            }
        }
		[currentElementValue setString:@""];
        useThisElement = NO;
	}
}

-(int)numberForDayOfTheWeek:(NSString*)dayOfTheWeek   {
    if ([dayOfTheWeek isEqualToString:@"Mon"])
        return 0;
    else
        if ([dayOfTheWeek isEqualToString:@"Tue"])
            return 1;
        else
            if ([dayOfTheWeek isEqualToString:@"Wed"])
                return 2;
            else
                if ([dayOfTheWeek isEqualToString:@"Thu"] || [dayOfTheWeek isEqualToString:@"Thur"])
                    return 3;
                else
                    if ([dayOfTheWeek isEqualToString:@"Fri"])
                        return 4;
                    else
                        if ([dayOfTheWeek isEqualToString:@"Sat"])
                            return 5;
                        else
                            if ([dayOfTheWeek isEqualToString:@"Sun"])
                                return 6;
                            else
                                return -1;
}

-(NSMutableArray*)getDays	{
    NSMutableArray *tempDays = [[NSMutableArray alloc] initWithArray:Days];
    for (int dayCount = 0; dayCount < [Days count]; dayCount++) {
        Day *dayTemp = [Days objectAtIndex:dayCount];
        NSMutableArray *tempEvents = [[NSMutableArray alloc] init];
        int numberOfEvents = [dayTemp.Events count];
        for (int Count = 0; Count < numberOfEvents; Count++) {
            int indexOfSoonest = 0;
            int currentStartHour = [[dayTemp.Events objectAtIndex:0] getStartHour];
            int currentStartMinute = [[dayTemp.Events objectAtIndex:0] getStartMinute];
            for (int Count2 = 0; Count2 < [dayTemp.Events count]; Count2++) {
                int startHour = [[dayTemp.Events objectAtIndex:Count2] getStartHour];
                int startMinute = [[dayTemp.Events objectAtIndex:Count2] getStartMinute];
                if (startHour < currentStartHour || (startHour == currentStartHour && (startMinute < currentStartMinute))) {
                    indexOfSoonest = Count2;
                    currentStartHour = startHour;
                    currentStartMinute = startMinute;
                }
            }
            [tempEvents addObject:[dayTemp.Events objectAtIndex:indexOfSoonest]];
            [dayTemp.Events removeObjectAtIndex:indexOfSoonest];
        }
        [dayTemp setEvents:tempEvents];
        int indexOfDay = [self numberForDayOfTheWeek:dayTemp.Name];
        if (indexOfDay != -1)
            [tempDays replaceObjectAtIndex:indexOfDay withObject:dayTemp];
        else
            [tempDays addObject:dayTemp];
    }
	return tempDays;
}

- (void) dealloc {
	[Days release];
	[currentElementValue release];
	[appDelegate release];
	[super dealloc];
}

@end
