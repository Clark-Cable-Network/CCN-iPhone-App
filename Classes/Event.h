//
//  Event.h
//  CCN
//
//  Created by Zachary Hariton on 12/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Event : NSObject {
	NSString *Name, *Day, *startTime, *endTime, *Image;
    NSMutableArray *Body, *allTimes;
    UIImageView *imageView;
}

@property (nonatomic, retain) NSString *Name;
@property (nonatomic, retain) NSString *Day;
@property (nonatomic, retain) NSString *startTime;
@property (nonatomic, retain) NSString *endTime;
@property (nonatomic, retain) NSString *Image;
@property (nonatomic, retain) NSMutableArray *Body;
@property (nonatomic, retain) NSMutableArray *allTimes;
@property (nonatomic, retain) UIImageView *imageView;

- (void) setName:(NSString *)newName setDay:(NSString *)newDay setStartTime:(NSString *)newStartTime setEndTime:(NSString *)newEndTime setImage:(NSString *)newImage setBody:(NSMutableArray *)newBody setAllTimes:(NSMutableArray *)newAllTimes;
- (void) setName:(NSString *)newName;
- (void) setDay:(NSString *)newDay;
- (void) setStartTime:(NSString *)newStartTime;
- (void) setEndTime:(NSString *)newEndTime;
- (void) setImage:(NSString *)newImage;
- (void) setBody:(NSMutableArray *)newBody;
- (void) setAllTimes:(NSMutableArray *)newAllTimes;
- (void) setImageView:(UIImageView *)newImageView;
- (NSString*)getName;
- (NSString*)getDay;
- (NSString*)getStartTime;
- (int)getStartHour;
- (int)getStartMinute;
- (NSString*)getEndTime;
- (int)getEndHour;
- (int)getEndMinute;
- (NSString*)getImage;
- (NSString*)getDescription;
- (UIImageView*)getImageView;
- (NSMutableArray*)getBody;
- (NSMutableArray*)getAllTimes;
- (NSMutableArray*)getDays;
- (NSMutableArray*)getStartTimes;
- (NSMutableArray*)getEndTimes;
- (Event*)deepCopy;

@end