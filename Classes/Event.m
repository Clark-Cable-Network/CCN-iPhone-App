//
//  Episode.m
//  CCN
//
//  Created by Zachary Hariton on 12/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Event.h"

@implementation Event

@synthesize Name, Day, startTime, endTime, Image, Body, imageView;

- (id) init   {
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(204, 6, 107, 159)];
    [imageView setBackgroundColor:[UIColor lightGrayColor]];
    return self;
}

- (void) setName:(NSString *)newName setDay:(NSString *)newDay setStartTime:(NSString *)newStartTime setEndTime:(NSString *)newEndTime setImage:(NSString *)newImage setBody:(NSMutableArray *)newBody	{
	Name = newName;
    Day = newDay;
	startTime = newStartTime;
    endTime = newEndTime;
    Image = newImage;
    Body = newBody;
}

- (void) setBody:(NSMutableArray *)newBody  {
    Body = newBody;
}

- (void) setName:(NSString *)newName    {
    Name = newName;
}
- (void) setDay:(NSString *)newDay  {
    Day = newDay;
}
- (void) setStartTime:(NSString *)newStartTime    {
    startTime = newStartTime;
}
- (void) setEndTime:(NSString *)newEndTime    {
    endTime = newEndTime;
}
- (void) setImage:(NSString *)newImage  {
    Image = newImage;
}
- (void) setImageView:(UIImageView *)newImageView   {
    imageView = newImageView;
}
- (NSMutableArray*) getBody {
    return Body;
}
- (NSString*)getName	{
	return Name;
}
- (NSString*)getDay {
    return Day;
}
- (NSString*)getStartTime	{
	return startTime;
}
- (int)getStartHour {
    if ([[[startTime componentsSeparatedByString:@" "] objectAtIndex:1] isEqualToString:@"AM"]) {
        int startHour = [[[startTime componentsSeparatedByString:@":"] objectAtIndex:0] intValue];
        if (startHour == 12)
            return 0;
        else
            return startHour;
    }
    else    {
        return [[[startTime componentsSeparatedByString:@":"] objectAtIndex:0] intValue]+12;
    }
}
- (int)getStartMinute   {
    return [[[[[startTime componentsSeparatedByString:@":"] objectAtIndex:1] componentsSeparatedByString:@" "] objectAtIndex:0] intValue];
}
- (NSString*)getEndTime	{
	return endTime;
}
- (int)getEndHour   {
    if ([[[endTime componentsSeparatedByString:@" "] objectAtIndex:1] isEqualToString:@"AM"]) {
        int endHour = [[[endTime componentsSeparatedByString:@":"] objectAtIndex:0] intValue];
        if (endHour == 12)
            return 0;
        else
            return endHour;
    }
    else    {
        return [[[endTime componentsSeparatedByString:@":"] objectAtIndex:0] intValue]+12;
    }
}
- (int)getEndMinute {
    return [[[[[endTime componentsSeparatedByString:@":"] objectAtIndex:1] componentsSeparatedByString:@" "] objectAtIndex:0] intValue];
}
- (NSString*)getImage   {
    return Image;
}

- (NSString*)getDescription {
    NSString *Result = [[NSString alloc] init];
    BOOL UseNext = NO;
    for (NSString *currentString in Body)   {
        if ([currentString isEqualToString:@"D"]) {
            UseNext = YES;
        }
        else if (UseNext)    {
            if (Result == nil)
                Result = [NSString stringWithFormat:@"%@%@", currentString, @" "];
            else
                Result = [NSString stringWithFormat:@"%@%@%@", Result, currentString, @" "];
            UseNext = NO;
        }
    }
    return Result;
}

- (UIImageView*)getImageView    {
    return imageView;
}

- (Event*)deepCopy	{
	Event *copy = [[Event alloc] init];
    NSMutableArray *bodyCopy = [[NSMutableArray alloc] initWithArray:Body copyItems:YES];
    [copy setName:[Name copy]];
    [copy setDay:[Day copy]];
    [copy setStartTime:[startTime copy]];
    [copy setEndTime:[endTime copy]];
    [copy setImage:[Image copy]];
    [copy setBody:bodyCopy];
	return copy;
}

-(void)dealloc	{
	[Name release];
	[startTime release];
    [endTime release];
    [Body release];
	[super dealloc];
}

@end