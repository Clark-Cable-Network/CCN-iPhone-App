//
//  Day.h
//  CCN
//
//  Created by Zachary Hariton on 12/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Event.h"

@interface Day : NSObject {
	NSString *Name;	//Name of Day
	NSMutableArray *Events;	//Array of Episodes
}

@property (nonatomic, retain) NSString *Name;
@property (nonatomic, retain) NSMutableArray *Events;

-(void)addEvent:(Event*)event;
-(void)setEvents:(NSMutableArray *)newEvents;
-(void)setName:(NSString *)newName;
-(NSMutableArray*)getEvents;
-(NSMutableArray*)getEventNames;
-(NSString*)getName;
-(Event*)eventAfterHour:(int)hour andMinute:(int)minute;
-(int)indexOfEventAfterHour:(int)hour andMinute:(int)minute;
-(Day*)deepCopy;

@end