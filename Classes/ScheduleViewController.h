//
//  FirstViewController.h
//  CCN
//
//  Created by Zachary Hariton on 12/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Day.h"

@class Reachability;
@class OverlayViewController;

@interface ScheduleViewController : UITableViewController {
	NSMutableArray *Days;
	NSMutableArray *searchEvents;
	IBOutlet UISearchBar *searchBar;
	BOOL searching, justLoaded, letUserSelectRow;
    UIScrollView *daySelector;
    int selectedButton;
    Day *currentDay;
	
	OverlayViewController *ovController;
    Reachability* hostReachable;
}

- (UITableViewCell *) getCellContentView:(NSString *)cellIdentifier;
- (void) loadShows;
- (void) searchTableView;
- (void) doneSearching_Clicked:(id)sender;
- (void) checkNetworkStatus:(NSNotification *)notice;

@end