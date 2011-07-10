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
    int Month, Year;
    NSMutableArray *Body;
    UIImageView *imageView;
}

@property (nonatomic, retain) NSString *Name;
@property (nonatomic, retain) NSString *Day;
@property (nonatomic, retain) NSString *startTime;
@property (nonatomic, retain) NSString *endTime;
@property (nonatomic, retain) NSString *Image;
@property (nonatomic, retain) NSMutableArray *Body;
@property (nonatomic, retain) UIImageView *imageView;

- (void) setName:(NSString *)newName setDay:(NSString *)newDay setStartTime:(NSString *)newStartTime setEndTime:(NSString *)newEndTime setMonth:(int)newMonth setYear:(int)newYear setImage:(NSString *)newImage setBody:(NSMutableArray *)newBody;
- (void) setName:(NSString *)newName;
- (void) setDay:(NSString *)newDay;
- (void) setStartTime:(NSString *)newStartTime;
- (void) setEndTime:(NSString *)newEndTime;
- (void) setMonth:(int)newMonth;
- (void) setYear:(int)newYear;
- (void) setImage:(NSString *)newImage;
- (void) setBody:(NSMutableArray *)newBody;
- (void) setImageView:(UIImageView *)newImageView;
- (NSString*)getName;
- (NSString*)getDay;
- (NSString*)getStartTime;
- (NSString*)getEndTime;
- (int)getMonth;
- (int)getYear;
- (NSString*)getImage;
- (NSString*)getDescription;
- (NSMutableArray*)getBody;
- (UIImageView*)getImageView;
- (Event*)deepCopy;

@end