//
//  Day.m
//  CCN
//
//  Created by Zachary Hariton on 12/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Day.h"
#import "Event.h"

@implementation Day

@synthesize Name, Events;

-(void)addEvent:(Event*)event	{
	if (Events) {
		[Events addObject:event];
	}
	else {
		Events = [[NSMutableArray alloc] init];
		[Events addObject:event];
	}
}

-(void)setEvents:(NSMutableArray *)newEvents	{
	Events = newEvents;
}

-(NSMutableArray*)getEvents	{
	return Events;
}

-(NSMutableArray*)getEventNames	{
	NSMutableArray *EventNames;
	for (Event *currentEvent in Events)	{
		[EventNames addObject:[currentEvent getName]];
	}
	return EventNames;
}

-(NSString*)getName	{
	return Name;
}

-(void)setName:(NSString *)newName	{
	Name = newName;
}

-(Day*)deepCopy	{
	Day *copy = [[Day alloc] init];
	[copy setName:[Name copy]];
	for (Event *tempEvent in Events)	{
		[copy addEvent:[tempEvent deepCopy]];
	}
	return copy;
}

-(void)dealloc	{
	[Name release];
	[Events release];
	[super dealloc];
}

@end