//
//  FirstViewController.h
//  CCN
//
//  Created by Zachary Hariton on 12/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageDownload.h"

@class OverlayViewController;

@interface NewsViewController : UITableViewController <ImageDownloadDelegate> {
	NSMutableArray *NewsItems;
	NSMutableArray *copyNewsItems;
	IBOutlet UISearchBar *searchBar;
	BOOL searching, justLoaded;
	BOOL letUserSelectRow;
	
	OverlayViewController *ovController;
}

- (UITableViewCell *) getCellContentView:(NSString *)cellIdentifier;
- (void) loadNewsItems;
- (void) searchTableView;
- (void) doneSearching_Clicked:(id)sender;

@end