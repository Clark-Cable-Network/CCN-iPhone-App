//
//  DetailViewController.h
//  CCN
//
//  Created by Zachary Hariton on 12/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"

@interface ScheduleDetailViewController : UIViewController {
	IBOutlet UILabel *Title, *subTitle, *startTimeLabel, *endTimeLabel, *alsoPlayingLabel;
	IBOutlet UIScrollView *ScrollView;
	IBOutlet UIImageView *Image;
    Event *selectedEvent;
    int day;
	NSString *selectedTitle, *selectedImage, *navigationBar;
    NSMutableArray *selectedBody, *airTimes;
	NSThread *loadImage;
	BOOL videoExists;
}

- (void)embedYouTube:(NSString *)urlString frame:(CGRect)frame;
- (void)setDay:(int)newDay;

@property (nonatomic, retain) NSString *selectedTitle;
@property (nonatomic, retain) NSString *selectedImage;
@property (nonatomic, retain) NSString *navigationBar;
@property (nonatomic, retain) NSMutableArray *selectedBody;
@property (nonatomic, retain) NSMutableArray *airTimes;
@property (nonatomic, retain) UIScrollView *ScrollView;
@property (nonatomic, retain) UIImageView *Image;
@property (nonatomic, retain) Event *selectedEvent;
@property (nonatomic, retain) NSThread *loadImage;
@property (assign) IBOutlet UILabel *Title;
@property (assign) IBOutlet UILabel *subTitle;
@property (assign) IBOutlet UILabel *startTimeLabel;
@property (assign) IBOutlet UILabel *endTimeLabel;
@property (assign) IBOutlet UILabel *alsoPlayingLabel;

@end