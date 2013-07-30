#import "SecondTableViewController.h"
#import "DetailViewManager.h"
#import "SecondDetailViewController.h"

@implementation SecondTableViewController

@synthesize feedName;
@synthesize feedURL;

@synthesize parser;
@synthesize feeds;
@synthesize feed_item;
@synthesize feed_title;
@synthesize feed_link;
@synthesize feed_element;

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	
	/*
	self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.tableView.hidden = YES;
    [self.view addSubview:self.tableView];
	 */
	
    // Initializing Data Source
    self.feeds = [[NSMutableArray alloc] init];
	self.feed_item = [[NSMutableDictionary alloc] init];
	self.feed_title = [[NSMutableString alloc] init];
	self.feed_link = [[NSMutableString alloc] init];
	
	
	
	
	NSLog(@"%@", feedURL);
	
	
	//[self.tableView setHidden:NO];
	[self.tableView reloadData];
}

-(void)viewWillAppear:(BOOL)animated
{
	UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Check for new feeds?"
													  message:@"Do you want to check if new feeds are available?"
													 delegate:self
											cancelButtonTitle:@"No"
											otherButtonTitles:@"Yes", nil];
	[message show];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section 
{
    return [self.feeds count];
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  /*
    static NSString *CellIdentifier = @"SecondTableViewController";
    
    // Dequeue or create a cell of the appropriate type.
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Set appropriate labels for the cells.
    if (indexPath.row == 0) {
        cell.textLabel.text = @"Detail View Controller One";
    }
    else {
        cell.textLabel.text = @"Detail View Controller Two";
    }
    
    return cell;
	
	
	
	*/
	
	
	static NSString *cellID = @"Cell Identifier";
    UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
	// Configure the cell...
	//add a title
	
	NSString *theFeedName = [[self.feeds objectAtIndex:indexPath.row] objectForKey: @"title"];
	cell.textLabel.text = theFeedName;
	
	NSString *theFeedUrl = [[self.feeds objectAtIndex:indexPath.row] objectForKey: @"link"];
	cell.detailTextLabel.text = theFeedUrl;
	
	
	return cell;	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
	
	/*
	 
	 UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	 
	 SecondTableViewController *newTableViewController = [[SecondTableViewController alloc] init];
	 
	 newTableViewController.feedName = cell.textLabel.text;
	 newTableViewController.feedURL = cell.detailTextLabel.text;
	 
	 [self.navigationController pushViewController:newTableViewController animated:YES];
	 
	 */
	
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	
	
	
	
    // Get a reference to the DetailViewManager.  
    // DetailViewManager is the delegate of our split view.
    DetailViewManager *detailViewManager = (DetailViewManager*)self.splitViewController.delegate;
    
    // Create and configure a new detail view controller appropriate for the selection.
    UIViewController <SubstitutableDetailViewController> *detailViewController = nil;
    
    SecondDetailViewController *newDetailViewController = [[SecondDetailViewController alloc] initWithNibName:@"SecondDetailView" bundle:nil];
    detailViewController = newDetailViewController;
    
    detailViewController.title = cell.textLabel.text;
	detailViewController.feedUrlString = cell.detailTextLabel.text;
	[detailViewController openLink:detailViewController.feedUrlString];
	
    if (indexPath.row == 0) {
        detailViewController.view.backgroundColor = [UIColor purpleColor];
    }
    else {
        detailViewController.view.backgroundColor = [UIColor orangeColor];
    }
    
    // DetailViewManager exposes a property, detailViewController.  Set this property
    // to the detail view controller we want displayed.  Configuring the detail view
    // controller to display the navigation button (if needed) and presenting it
    // happens inside DetailViewManager.
    detailViewManager.detailViewController = detailViewController;
}










// cashing and loading code
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	NSURL *url = [NSURL URLWithString:feedURL];
	NSString *feedSource = [[NSString alloc] initWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *docDir = [paths objectAtIndex: 0];
	NSString *filePath = [docDir stringByAppendingPathComponent: feedName];
	
	NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"Yes"])
    {
        NSLog(@"Yes was selected. Cash feeds locally");
		
		//todo: remove last instance of this file from memory
		
		//cashe the contents of the url to documents folder
		[feedSource writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
		
		
    }
    else if([title isEqualToString:@"No"])
    {
        NSLog(@"No was selected. Load feeds from xml files");
    }
	
	//now read from the stored copy
	NSFileHandle *file;
	NSData *databuffer;
	
	file = [NSFileHandle fileHandleForReadingAtPath: filePath];
	
	if (file == nil)
		NSLog(@"Failed to open file %@", filePath);
	else
	{
		databuffer = [file readDataToEndOfFile];
		[file closeFile];
		
		//now try to parse it
		
		parser = [[NSXMLParser alloc] initWithData:databuffer];
		
		[parser setDelegate:self];
		[parser setShouldResolveExternalEntities:NO];
		[parser parse];
		
		
		NSLog(@"Feeds: %@",self.feeds);
		NSLog(@"Item: %@",self.feed_item);
		NSLog(@"TITLE: %@",self.feed_title);
		NSLog(@"Link: %@",self.feed_link);
	}
}





// XML FEED PARSER CODE

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    feed_element = elementName;
    
    if ([feed_element isEqualToString:@"item"])
	{
        feed_item    = [[NSMutableDictionary alloc] init];
        feed_title   = [[NSMutableString alloc] init];
        feed_link    = [[NSMutableString alloc] init];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if ([feed_element isEqualToString:@"title"])
	{
        [feed_title appendString:string];
    }
	else if ([feed_element isEqualToString:@"link"])
	{
        [feed_link appendString:string];
    }
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"item"])
	{
        [feed_item setObject:feed_title forKey:@"title"];
        [feed_item setObject:feed_link forKey:@"link"];
        
        [feeds addObject:[feed_item copy]];
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    [self.tableView reloadData];
}

@end
