#import "FirstTableViewController.h"
#import "DetailViewManager.h"
#import "SecondTableViewController.h"
#import "FirstDetailViewController.h"

#import "AFNetworking.h"

@implementation FirstTableViewController

@synthesize feed_names;
@synthesize feed_urls;

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    return YES;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section 
{
    if (self.feed_names && self.feed_names.count)
	{
        return self.feed_names.count;
    }
	else
	{
        return 0;
    }
}

-(void) showLoginPrompt
{
	loginPrompt = [[UIAlertView alloc] initWithTitle:@"Login"
                                                      message:@"Please log in to view your feeds"
                                                     delegate:self
                                            cancelButtonTitle:@"Cancel"
                                            otherButtonTitles:@"Submit", nil];
	

    [loginPrompt setAlertViewStyle:UIAlertViewStyleLoginAndPasswordInput];
	//[[loginPrompt textFieldAtIndex:1] setSecureTextEntry:NO];
	
    UITextField *usernameField = [loginPrompt textFieldAtIndex:0];
    usernameField.placeholder=@"Username";
	
    UITextField *passwordField= [loginPrompt textFieldAtIndex:1];
    passwordField.placeholder=@"Password";
	
    [loginPrompt show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	
	if (alertView == loginPrompt)
	{
        if (buttonIndex == 1)
		{
			NSLog(@"Submit");
			
			static NSString *const BaseURLString = @"http://www.nimbusbg.com//projects//inews//";
			//static NSString *const BaseURLString = @"http://www.inews.site40.net//";
			
			NSURL *url = [NSURL URLWithString: BaseURLString];
			
			AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
			
			NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
									[loginPrompt textFieldAtIndex:0 ].text, @"username",
									[loginPrompt textFieldAtIndex:1 ].text, @"password",
									nil];
			
			[httpClient postPath:@"login.php"
					  parameters:params
			success:
			 ^(AFHTTPRequestOperation *operation, id responseObject)
			 {
				 NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
				 NSLog(@"Request Successful, response '%@'", responseStr);
				 
				 
				 
				 
				 
				 
				 //user has been authorised, now we have to get his feeds
				 
				 //NSURL *url = [[NSURL alloc] initWithString:@"http://www.inews.site40.net/get_feeds.php"];
				 NSURL *url = [[NSURL alloc] initWithString:@"http://www.nimbusbg.com/projects/inews/get_feeds.php"];
				 NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
				 
				 AFJSONRequestOperation *operation2 = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
																									 success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
													  {
														  NSLog(@"Json is: %@", JSON);
														  
														  int i = 0;
														  for(i=0; i< [JSON count]; i++)
														  {
															  NSDictionary *feedLineObj = [JSON objectAtIndex:i];
															  
															  NSLog(@"Feed line obj for key : %@", [feedLineObj objectForKey:@"feed_name"]);
															  
															  [self.feed_names addObject:[feedLineObj objectForKey:@"feed_name"]];
															  
															  [self.feed_urls addObject:[feedLineObj objectForKey:@"feed_url"]];
															  
														  }
														  
														  //[self.activityIndicatorView stopAnimating];
														  //[self.tableView setHidden:NO];
														  [self.tableView reloadData];
													  }
																									 failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON)
													  {
														  NSLog(@"Request Failed with Error: %@, %@", error, error.userInfo);
													  }];
				 
				 [operation2 start];
				 
				 

				 
				 
				 
				 
			 }
			failure:
			 ^(AFHTTPRequestOperation *operation, NSError *error)
			 {
				 NSLog(@"[HTTPClient Error]: %@", error.localizedDescription);
				 
				 
				 UIAlertView *loginError = [[UIAlertView alloc] initWithTitle:operation.responseString
																   message:error.localizedDescription
																  delegate:self
														 cancelButtonTitle:@"OK"
														 otherButtonTitles:nil];
				 [loginError show];
			 }
			 ];
		}
		else
		{
			NSLog(@"cancel");
		}
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    // Initializing Data Source
    self.feed_names = [[NSMutableArray alloc] init];
	self.feed_urls = [[NSMutableArray alloc] init];

	
	//showLoginPrompt;
	loginPrompt = [[UIAlertView alloc] initWithTitle:@"Login"
											 message:@"Please log in to view your feeds"
											delegate:self
								   cancelButtonTitle:@"Cancel"
								   otherButtonTitles:@"Submit", nil];
	
	
    [loginPrompt setAlertViewStyle:UIAlertViewStyleLoginAndPasswordInput];
	//[[loginPrompt textFieldAtIndex:1] setSecureTextEntry:NO];
	
    UITextField *usernameField = [loginPrompt textFieldAtIndex:0];
    usernameField.placeholder=@"Username";
	
    UITextField *passwordField= [loginPrompt textFieldAtIndex:1];
    passwordField.placeholder=@"Password";
	
    [loginPrompt show];
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *cellID = @"Cell Identifier";
    UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
	{
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
	
	//add a title
	
	NSString *theFeedName = [self.feed_names objectAtIndex:indexPath.row];
	cell.textLabel.text = theFeedName;
	
	NSString *theFeedUrl = [self.feed_urls objectAtIndex:indexPath.row];
	cell.detailTextLabel.text = theFeedUrl;
	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	//DetailViewManager *detailViewManager = (DetailViewManager*)self.splitViewController.delegate;
    
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	
	SecondTableViewController *newTableViewController = [[SecondTableViewController alloc] init];

	newTableViewController.feedName = cell.textLabel.text;
    newTableViewController.feedURL = cell.detailTextLabel.text;
	
	[self.navigationController pushViewController:newTableViewController animated:YES];
}

@end
