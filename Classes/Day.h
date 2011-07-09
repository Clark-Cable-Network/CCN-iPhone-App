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
	NSMutableArray *Episodes;	//Array of Episodes
}

@property (nonatomic, retain) NSString *Name;
@property (nonatomic, retain) NSMutableArray *Events;

-(void)addEvent:(Event*)episode;
-(void)setEvents:(NSMutableArray *)newEpisodes;
-(void)setName:(NSString *)newName;
-(NSMutableArray*)getEvents;
-(NSMutableArray*)getEventNames;
-(NSString*)getName;
-(Day*)deepCopy;

@end