//
//  FirstViewController.m
//  CCN
//
//  Created by Zachary Hariton on 12/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ScheduleViewController.h"
#import "CCNAppDelegate.h"
#import "ScheduleDetailViewController.h"
#import "OverlayViewController.h"
#import "Day.h"
#import "Event.h"
#import "XMLParserSchedule.h"
#import "Reachability.h"
#import "ImageDownload.h"

@implementation ScheduleViewController

- (void)moveToNextEvent {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorian components:(NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:[NSDate date]];
    
    int dayOfTheWeek = [components weekday];
    if (dayOfTheWeek == 1)
        dayOfTheWeek = 7;
    else
        dayOfTheWeek--;
    selectedButton = dayOfTheWeek; //Remove after implementing current time code.
    [self daySelected:[daySelector viewWithTag:dayOfTheWeek]];
    
    int tableViewHeightSet = [currentDay indexOfEventAfterHour:[components hour] andMinute:[components minute]]*171 + 40;
    if (tableViewHeightSet != 40)
        [self.tableView setContentOffset:CGPointMake(0, tableViewHeightSet) animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatus:) name:kReachabilityChangedNotification object:nil];
    
//	hostReachable = [[Reachability reachabilityWithHostName: @"www.clarku.edu"] retain];
//	[hostReachable startNotifier];
	
	letUserSelectRow = YES;
    justLoaded = YES;
	Days = [[NSMutableArray alloc] init];
	
	[self loadShows];
	
	self.navigationItem.title = @"Schedule";
    
    [self moveToNextEvent];
}

- (BOOL) isThereData   {
    for (Day *dayTemp in Days) {
        if ([dayTemp.Events count] != 0)    {
            return YES;
        }
    }
    return NO;
}

- (void) viewDidAppear:(BOOL)animated  {
    if (!justLoaded && ![self isThereData])    {
        justLoaded = YES;
        [self loadShows];
        [self moveToNextEvent];
        justLoaded = NO;
    }
    else
        justLoaded = NO;
    //[self loadImagesForOnscreenRows];
}

-(void)loadShows	{
	NSURL *url = [[NSURL alloc] initWithString:@"http://www.clarku.edu/students/MOVED/ccn-move/App/Schedule.xml"];
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
    
    if (justLoaded) {
        daySelector = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
        [daySelector setShowsHorizontalScrollIndicator:NO];
        int Count = 0;
        [Days removeAllObjects];
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
        
        //Add the daySelector
        UIView *tableHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
        [tableHeader addSubview:daySelector];
        self.tableView.tableHeaderView = tableHeader;
    }
	
	[xmlParser release];
}

- (void) updateCurrentDayWithDay:(NSString *)newDay    {
    for (Day *dayTemp in Days)	{
        if ([[dayTemp getName] isEqualToString:newDay])
            currentDay = dayTemp;
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
    
    //The fix may need to be more robust than this.
    if ([Days count] >= tempButton.tag-1) {
        currentDay = [Days objectAtIndex:tempButton.tag-1];
    }
    [self.tableView reloadData];
    [self loadImagesForCurrentDay];
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
	return 171;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *CellIdentifier = @"Cell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil)
		cell = [self getCellContentView:CellIdentifier];
	
	UILabel *lblTemp1 = (UILabel *)[cell viewWithTag:1];
	UILabel *lblTemp2 = (UILabel *)[cell viewWithTag:2];
    UILabel *lblTemp3 = (UILabel *)[cell viewWithTag:4];
    
    cell.frame = CGRectMake(0, 0, 300, 171);
	
	// Set up the cell...
    NSString *Temp = [[[currentDay getEvents] objectAtIndex:indexPath.row] getDescription];
    lblTemp1.text = [[[currentDay getEvents] objectAtIndex:indexPath.row] getName];
    lblTemp2.numberOfLines = 8;
    CGSize lblTemp2Size = [Temp sizeWithFont:lblTemp2.font constrainedToSize:CGSizeMake(181, 130)];
    lblTemp2.frame = CGRectMake(10, 40, 181, lblTemp2Size.height);
    lblTemp2.text = Temp;
    
    lblTemp3.text = [[[[[currentDay getEvents] objectAtIndex:indexPath.row] getStartTime] stringByAppendingString:@" - "]stringByAppendingString:[[[currentDay getEvents] objectAtIndex:indexPath.row] getEndTime]];
    lblTemp3.frame = CGRectMake(10, 22, 181, 20);
        
    UIImageView *imageView = [[[currentDay getEvents] objectAtIndex:indexPath.row] getImageView];
    imageView.tag = 3;
    [cell addSubview:imageView];
	return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[currentDay getEvents] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	//Get the selected episode
	Event *selectedEvent = [[Event alloc] init];
	
    selectedEvent = [[currentDay getEvents] objectAtIndex:indexPath.row];
	//Initialize the detail view controller and display it.
	
	ScheduleDetailViewController *dvController = [[ScheduleDetailViewController alloc] initWithNibName:@"ScheduleDetailView" bundle:[NSBundle mainBundle]];
    [dvController setDay:selectedButton];
    dvController.selectedBody = [selectedEvent getBody];
    dvController.selectedEvent = selectedEvent;
    
    NSMutableArray *airTimes = [[NSMutableArray alloc] init];
    for (Day *tempDay in Days) {
        [airTimes addObjectsFromArray:[tempDay eventsWithName:[selectedEvent getName]]];
    }
    dvController.airTimes = airTimes;
    
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

- (void)loadImagesForCurrentDay {
    for (int Count = 0; Count < [self.tableView numberOfRowsInSection:0]; Count++) {
        UIImageView *imageView = [[[currentDay getEvents] objectAtIndex:Count] getImageView];
        if (imageView.image == nil && imageView.hidden == NO) {
            [self downloadIcon:imageView withURL:[[[currentDay getEvents] objectAtIndex:Count] getImage]];
        }
    }
}

- (void)downloadDidFinishDownloading:(ImageDownload *)download  {
    download.imageView.image = download.image;
}

#pragma mark -
#pragma mark Lazy Image Loading

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
	[ovController release];
	[super dealloc];
}

@end
