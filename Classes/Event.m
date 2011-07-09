//
//  Episode.m
//  CCN
//
//  Created by Zachary Hariton on 12/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Event.h"

@implementation Event

@synthesize Name, startTime, endTime, Image, Body, imageView;

- (id) init   {
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(240, 6, 58, 58)];
    [imageView setBackgroundColor:[UIColor lightGrayColor]];
    return self;
}

- (void) setName:(NSString *)newName setStartTime:(NSString *)newStartTime setEndTime:(NSString *)newEndTime setImage:(NSString *)newImage setBody:(NSMutableArray *)newBody	{
	Name = newName;
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

- (NSString*)getStartTime	{
	return startTime;
}

- (NSString*)getEndTime	{
	return endTime;
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