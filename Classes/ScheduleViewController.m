//
//  FirstViewController.m
//  CCN
//
//  Created by Zachary Hariton on 12/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ScheduleViewController.h"
#import "CCNAppDelegate.h"
#import "DetailViewController.h"
#import "OverlayViewController.h"
#import "Day.h"
#import "Event.h"
#import "XMLParserSchedule.h"
#import "Reachability.h"
#import "ImageDownload.h"

@implementation ScheduleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatus:) name:kReachabilityChangedNotification object:nil];
    
	hostReachable = [[Reachability reachabilityWithHostName: @"www.clarku.edu"] retain];
	[hostReachable startNotifier];
	
	Days = [[NSMutableArray alloc] init];
	
	[self loadShows];
	
	//Initialize the copy array.
	copyDays = [[NSMutableArray alloc] init];
	
	self.navigationItem.title = @"Schedule";
    
	searching = NO;
	letUserSelectRow = YES;
    selectedButton = 1; //Remove after implementing current time code.
    currentDay = [Days objectAtIndex:0];
}

- (void) viewDidAppear:(BOOL)animated  {
    [self loadImagesForOnscreenRows];
}

-(void)loadShows	{
	NSURL *url = [[NSURL alloc] initWithString:@"http://www.zackhariton.com/App/Schedule.xml"];
	UIApplication *app = [UIApplication sharedApplication];
	app.networkActivityIndicatorVisible = YES;
	NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:url];
	app.networkActivityIndicatorVisible = NO;
	[url release];
	
	//Initialize the delegate.
	XMLParserSchedule *parser = [[XMLParserSchedule alloc] initXMLParser];
	
	//Set delegate
	[xmlParser setDelegate:parser];
	
	[xmlParser parse];
    
    daySelector = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, 320, 40)];
    int Count = 0;
	for (Day *dayTemp in [parser getDays])	{
		[Days addObject:[dayTemp deepCopy]];
        UIButton *tempButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        tempButton.frame = CGRectMake(Count*70+5, 3, 65, 32);
        [tempButton setTitle:[dayTemp getName] forState:UIControlStateNormal];
        [tempButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        tempButton.tag = Count + 1;
        [tempButton addTarget:self action:@selector(daySelected:) forControlEvents:UIControlEventTouchUpInside];
        [daySelector addSubview:tempButton];
        Count++;
	}
    [daySelector setContentSize:CGSizeMake(Count*70+5, 40)];
    
    //Add the search bar and daySelector
    UIView *tableHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 84)];
    [tableHeader addSubview:searchBar];
    [tableHeader addSubview:daySelector];
	self.tableView.tableHeaderView = tableHeader;
	searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
	
	//[xmlParser release];
}

- (void) updateCurrentDayWithDay:(NSString *)newDay    {
    for (Day *dayTemp in Days)	{
        if ([[dayTemp getName] isEqualToString:newDay]) {
            currentDay = dayTemp;
            //break;
        }
    }
    [self.tableView reloadData];
}

- (void) daySelected:(id) sender    {
    [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
    UIButton *tempButton = (UIButton*) [daySelector viewWithTag:selectedButton];
    [tempButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    tempButton = (UIButton*) sender;
    selectedButton = tempButton.tag;
    [tempButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    int offset = (tempButton.tag*70)-140;
    if (offset < 0) {
        offset = 0;
    } else if (offset + 320 > daySelector.contentSize.width)    {
        offset = daySelector.contentSize.width - 320;
    }
    [daySelector setContentOffset:CGPointMake(offset, 0) animated:YES];
    currentDay = [Days objectAtIndex:tempButton.tag-1];
    [self.tableView reloadData];
}

#pragma mark Table view methods

- (UITableViewCell *) getCellContentView:(NSString *)cellIdentifier {
	
    CGRect CellFrame = CGRectMake(0, 0, 300, 171);
	CGRect Label1Frame = CGRectMake(10, 2, 181, 20);
	CGRect Label2Frame = CGRectMake(10, 40, 181, 130);
    CGRect Label3Frame = CGRectMake(10, 24, 181, 20);
	UILabel *lblTemp;
	
	UITableViewCell *cell = [[[UITableViewCell alloc] initWithFrame:CellFrame reuseIdentifier:cellIdentifier] autorelease];
	
	//Initialize Label with tag 1.
	lblTemp = [[UILabel alloc] initWithFrame:Label1Frame];
	lblTemp.tag = 1;
	lblTemp.font = [UIFont boldSystemFontOfSize:17];
	[cell.contentView addSubview:lblTemp];
	[lblTemp release];
	
	//Initialize Label with tag 2.
	lblTemp = [[UILabel alloc] initWithFrame:Label2Frame];
	lblTemp.tag = 2;
	lblTemp.font = [UIFont systemFontOfSize:12];
	[cell.contentView addSubview:lblTemp];
	[lblTemp release];
    
    //Initialize Label with tag 4.
    lblTemp = [[UILabel alloc] initWithFrame:Label3Frame];
	lblTemp.tag = 4;
	lblTemp.font = [UIFont systemFontOfSize:14];
    lblTemp.textColor = [UIColor colorWithRed:122/255 green:228/255 blue:1 alpha:.85];
	[cell.contentView addSubview:lblTemp];
	[lblTemp release];
	
	return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (searching) {
		return 44;
	}
	return [self tableView:tableView cellForRowAtIndexPath:indexPath].frame.size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *CellIdentifier = @"Cell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil)
		cell = [self getCellContentView:CellIdentifier];
	
	UILabel *lblTemp1 = (UILabel *)[cell viewWithTag:1];
	UILabel *lblTemp2 = (UILabel *)[cell viewWithTag:2];
    UILabel *lblTemp3 = (UILabel *)[cell viewWithTag:4];
	
	// Set up the cell...
	if (searching)	{
		lblTemp1.text = [NSString stringWithFormat:@"%@%@%@",[[copyDays objectAtIndex:indexPath.row] getDay], @": ",[[copyDays objectAtIndex:indexPath.row] getName]];
		lblTemp2.frame = CGRectMake(10, 24, 290, 15);
		lblTemp2.numberOfLines = 1;
		[self tableView:tableView heightForRowAtIndexPath:indexPath];
		lblTemp2.text = [[copyDays objectAtIndex:indexPath.row] getDescription];
        [[cell viewWithTag:3] setHidden:YES];
        
        lblTemp3.text = [[[currentDay getEvents] objectAtIndex:indexPath.row] getStartTime];
        lblTemp3.frame = CGRectMake(10, 24, 181, 20);
	}
	else	{
		NSString *Temp = [[[currentDay getEvents] objectAtIndex:indexPath.row] getDescription];
		lblTemp1.text = [[[currentDay getEvents] objectAtIndex:indexPath.row] getName];
        lblTemp2.numberOfLines = 8;
        CGSize lblTemp2Size = [Temp sizeWithFont:lblTemp2.font constrainedToSize:CGSizeMake(181, 130)];
        lblTemp2.frame = CGRectMake(10, 40, 181, lblTemp2Size.height);
        cell.frame = CGRectMake(0, 0, 300, 171);
		lblTemp2.text = Temp;
        
        lblTemp3.text = [[[[[currentDay getEvents] objectAtIndex:indexPath.row] getStartTime] stringByAppendingString:@" - "] stringByAppendingString:[[[currentDay getEvents] objectAtIndex:indexPath.row] getEndTime]];
        lblTemp3.frame = CGRectMake(10, 22, 181, 20);
        
        
        UIImageView *imageView = [[[currentDay getEvents] objectAtIndex:indexPath.row] getImageView];;
        imageView.tag = 3;
        [cell addSubview:imageView];
	}
	return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (searching)
		return [copyDays count];
	else
        return [[currentDay getEvents] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	//Get the selected episode
	Event *selectedEvent = [[Event alloc] init];
	
	if (searching)
		selectedEvent = [copyDays objectAtIndex:indexPath.row];
	else
		selectedEvent = [[currentDay getEvents] objectAtIndex:indexPath.row];
	//Initialize the detail view controller and display it.
	
	DetailViewController *dvController = [[DetailViewController alloc] initWithNibName:@"DetailView" bundle:[NSBundle mainBundle]];
	dvController.selectedTitle = [selectedEvent getDay];
	dvController.selectedSubTitle = [selectedEvent getName];
    dvController.selectedImage = [selectedEvent getImage];
    dvController.selectedBody = [selectedEvent getBody];
	dvController.navigationBar = @"Selected Episode";
	[self.navigationController pushViewController:dvController animated:YES];
	[dvController release];
	dvController = nil;
}

- (NSIndexPath *)tableView :(UITableView *)theTableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if(letUserSelectRow)
		return indexPath;
	else
		return nil;
}

/*- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath {
 return UITableViewCellAccessoryDisclosureIndicator;
 }*/

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
	[self tableView:tableView didSelectRowAtIndexPath:indexPath];
}

#pragma mark -
#pragma mark Search Bar 

- (void) searchBarTextDidBeginEditing:(UISearchBar *)theSearchBar {
	//Add the overlay view.
	if(ovController == nil)
		ovController = [[OverlayViewController alloc] initWithNibName:@"OverlayView" bundle:[NSBundle mainBundle]];
	
	CGFloat yaxis = self.navigationController.navigationBar.frame.size.height;
	CGFloat width = self.view.frame.size.width;
	CGFloat height = self.view.frame.size.height;
	
	//Parameters x = origion on x-axis, y = origon on y-axis.
	CGRect frame = CGRectMake(0, yaxis, width, height);
	ovController.view.frame = frame;
	ovController.view.backgroundColor = [UIColor grayColor];
	ovController.view.alpha = 0.5;
	
	ovController.rvController = self;
	
	[self.tableView insertSubview:ovController.view aboveSubview:self.parentViewController.view];
	
	searching = YES;
	letUserSelectRow = NO;
	self.tableView.scrollEnabled = NO;
	
	//Add the done button.
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]
											   initWithBarButtonSystemItem:UIBarButtonSystemItemDone
											   target:self action:@selector(doneSearching_Clicked:)] autorelease];
}

- (void)searchBar:(UISearchBar *)theSearchBar textDidChange:(NSString *)searchText {
	//Remove all objects first.
	[copyDays removeAllObjects];
	
	if([searchText length] > 0) {
		[ovController.view removeFromSuperview];
		searching = YES;
		letUserSelectRow = YES;
		self.tableView.scrollEnabled = YES;
		[self searchTableView];
	}
	else {
		[self.tableView insertSubview:ovController.view aboveSubview:self.parentViewController.view];
		
		searching = NO;
		letUserSelectRow = NO;
		self.tableView.scrollEnabled = NO;
	}
	
	[self.tableView reloadData];
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)theSearchBar {
	[self searchTableView];
}

- (void) searchTableView {
	NSString *searchText = searchBar.text;
	NSMutableArray *searchArray = [[NSMutableArray alloc] init];
	NSMutableArray *array = [[NSMutableArray alloc] init];
	
	for (Day *currentDay in Days)
	{
		array = [currentDay getEvents];
		[searchArray addObjectsFromArray:array];
	}
	
	int Count = 0;
	for (Event *eventTemp in searchArray)
	{
		BOOL added = NO;
		NSString *sTemp = [eventTemp getName];
		NSRange titleResultsRange = [sTemp rangeOfString:searchText options:NSCaseInsensitiveSearch];
		
		if (titleResultsRange.length > 0)	{
			[copyDays addObject:[searchArray objectAtIndex:Count]];
			added = YES;
		}
		
		sTemp = [eventTemp getDay];
		titleResultsRange = [sTemp rangeOfString:searchText options:NSCaseInsensitiveSearch];
		if (titleResultsRange.length > 0 && !added)
			[copyDays addObject:[searchArray objectAtIndex:Count]];
		
		Count++;
	}
	
	[searchArray release];
	searchArray = nil;
}

- (void) doneSearching_Clicked:(id)sender {
	searchBar.text = @"";
	[searchBar resignFirstResponder];
	
	letUserSelectRow = YES;
	searching = NO;
	self.navigationItem.rightBarButtonItem = nil;
	self.tableView.scrollEnabled = YES;
	
	[ovController.view removeFromSuperview];
	[ovController release];
	ovController = nil;
	
	[self.tableView reloadData];
}

#pragma mark -
#pragma mark Image Download

- (void)downloadIcon:(UIImageView *)imageView withURL:(NSString *)URL  {
    ImageDownload *ImageDownloader = [[ImageDownload alloc] init];
    ImageDownloader.urlString = URL;
    ImageDownloader.imageView = imageView;
    if (ImageDownloader.image == nil) {
        ImageDownloader.delegate = self;
    }
    [ImageDownloader release];
}

// this method is used in case the user scrolled into a set of cells that don't have their app icons yet
- (void)loadImagesForOnscreenRows
{
    NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];
    for (int i = 0; i < [visiblePaths count]; i++)  {
        NSIndexPath *indexPath = [visiblePaths objectAtIndex:i];
        UIImageView *imageView = [[[currentDay getEvents] objectAtIndex:indexPath.row] getImageView];;
        if (imageView.image == nil && imageView.hidden == NO) {
            [self downloadIcon:imageView withURL:[[[currentDay getEvents] objectAtIndex:indexPath.row] getImage]];
        }
    }
}

- (void)downloadDidFinishDownloading:(ImageDownload *)download  {
    download.imageView.image = download.image;
}

#pragma mark -
#pragma mark Lazy Image Loading

// Load images for all onscreen rows when scrolling is finished
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
	{
        [self loadImagesForOnscreenRows];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadImagesForOnscreenRows];
}

- (void) checkNetworkStatus:(NSNotification *)notice
{
	// called after network status changes
	
	NetworkStatus hostStatus = [hostReachable currentReachabilityStatus];
	if (hostStatus == NotReachable) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Failed"
														message:@"The connection to the server failed. Unable to download data"
													   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alert show];
		[alert release];
	}
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


-(void)dealloc	{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[Days release];
	[searchBar release];
	[ovController release];
	[copyDays release];
	[super dealloc];
}

@end
