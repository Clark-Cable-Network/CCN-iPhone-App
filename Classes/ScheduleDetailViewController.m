//
//  DetailViewController.m
//  CCN
//
//  Created by Zachary Hariton on 12/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ScheduleDetailViewController.h"
#import "ImageDownload.h"

@implementation ScheduleDetailViewController

@synthesize Title, subTitle, startTimeLabel, endTimeLabel, alsoPlayingLabel, selectedEvent, selectedBody, airTimes, Image, loadImage, ScrollView;

int Height;   //Add to this for each new element.

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSString *)dayStringGenerator    {
    if (day == 1)
        return @"Monday";
    else if (day == 2)
        return @"Tuesday";
    else if (day == 3)
        return @"Wednesday";
    else if (day == 4)
        return @"Thursday";
    else if (day == 5)
        return @"Friday";
    else if (day == 6)
        return @"Saturday";
    else if (day == 7)
        return @"Sunday";
    else
        return nil;
}

- (void)viewDidLoad {
	[super viewDidLoad];

    Height = 165;
    BOOL First = YES;
    Title.text = selectedEvent.Name;
	subTitle.text = [self dayStringGenerator];
    self.navigationItem.title = [selectedEvent getName]; //Set the title of the navigation bar
    
    ImageDownload *ImageDownloader = [[ImageDownload alloc] init];
    ImageDownloader.urlString = [selectedEvent getImage];
    ImageDownloader.imageView = Image;
    if (ImageDownloader.image == nil) {
        ImageDownloader.delegate = self;
    }
    
    startTimeLabel.text = [startTimeLabel.text stringByAppendingString:[selectedEvent getStartTime]];
    endTimeLabel.text = [endTimeLabel.text stringByAppendingString:[selectedEvent getEndTime]];
    alsoPlayingLabel.text = [alsoPlayingLabel.text stringByAppendingString:[selectedEvent getDaysString]];
    if (alsoPlayingLabel.text.length < 22)
        [alsoPlayingLabel setFrame:CGRectMake(8, 104, 185, 20)];
    else    {
        [alsoPlayingLabel setFrame:CGRectMake(8, 104, 185, 40)];
        [alsoPlayingLabel setNumberOfLines:2];
    }
    
    NSString *NextIdentifier;
    for (NSString *currentString in selectedBody)   {
        if (First)
            First = NO;
        else if ([NextIdentifier isEqualToString:@"D"]) {
            UITextView *newDescription = [[UITextView alloc] initWithFrame:CGRectMake(0, Height, 320, 25)];
            newDescription.text = currentString;
            
            [self.view addSubview:newDescription];
            [newDescription release];
            
            [newDescription setFont:[UIFont systemFontOfSize:16]];
            CGRect tempFrame = newDescription.frame;
            tempFrame.size.height = newDescription.contentSize.height;
            newDescription.frame = tempFrame;
            newDescription.scrollEnabled = NO;
            newDescription.editable = NO;
            
            Height += newDescription.contentSize.height;
        }
        else if ([NextIdentifier isEqualToString:@"I"]) {
            UIImageView *newImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, Height, 300, 245)];
            [newImage setBackgroundColor:[UIColor lightGrayColor]];
            [self.view addSubview:newImage];
            [newImage release];
            Height += 240;
            
            ImageDownload *ImageDownloader = [[ImageDownload alloc] init];
            ImageDownloader.urlString = currentString;
            ImageDownloader.imageView = newImage;
            
            UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            [activityIndicator setCenter:CGPointMake(160, Height - 123)];
            [self.view addSubview:activityIndicator];
            ImageDownloader.activityIndicator = activityIndicator;
            [activityIndicator startAnimating];
            if (ImageDownloader.image == nil) {
                ImageDownloader.delegate = self;
            }
        }
        else if ([NextIdentifier isEqualToString:@"V"]) {
            [self embedYouTube:currentString frame:CGRectMake(10, Height, 300, 245)];
            Height += 240;
        }
        NextIdentifier = currentString;
    }
    
    if ([[selectedBody objectAtIndex:([selectedBody count] - 2)] isEqualToString:@"V"] || [[selectedBody objectAtIndex:([selectedBody count] - 2)] isEqualToString:@"I"]) {
        Height += 15;
    }
    
    [ScrollView setContentSize:CGSizeMake(320, Height)];
}

- (void)downloadDidFinishDownloading:(ImageDownload *)download  {
    if (download.image != nil && [download.activityIndicator isAnimating]) {
        [download.activityIndicator stopAnimating];
        [download.activityIndicator release];
    }
    download.imageView.image = download.image;
}

- (void)embedYouTube:(NSString *)urlString frame:(CGRect)frame {
	NSString *embedHTML = @"\
    <html><head>\
	<style type=\"text/css\">\
	body {\
	background-color: transparent;\
	color: white;\
	}\
	</style>\
	</head><body style=\"margin:0\">\
    <embed id=\"yt\" src=\"%@\" type=\"application/x-shockwave-flash\" \
	width=\"%0.0f\" height=\"%0.0f\"></embed>\
    </body></html>";
	NSString *html = [NSString stringWithFormat:embedHTML, urlString, frame.size.width, frame.size.height];
	UIWebView *videoView = [[UIWebView alloc] initWithFrame:frame];
	[videoView loadHTMLString:html baseURL:nil];
    [[[videoView subviews] lastObject] setScrollEnabled:NO];
	[self.view addSubview:videoView];
	[videoView release];
}

- (void)setDay:(int)newDay  {
    day = newDay;
}

- (void)viewDidUnload {
    [super viewDidUnload];
}


- (void)dealloc {
    [selectedBody release];
	[Image release];
	[ScrollView release];
	[super dealloc];
}


@end
