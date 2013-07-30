#import "SecondDetailViewController.h"

@implementation SecondDetailViewController

@synthesize feedUrlString;
@synthesize webView;

- (void)dealloc 
{
    self.navigationBar = nil;
    self.navigationPaneBarButtonItem = nil;
    //[super dealloc];
}

// -------------------------------------------------------------------------------
//	setNavigationPaneBarButtonItem:
//  Custom implementation for the navigationPaneBarButtonItem setter.
//  In addition to updating the _navigationPaneBarButtonItem ivar, it
//  reconfigures the navigationBar to either show or hide the 
//  navigationPaneBarButtonItem.
// -------------------------------------------------------------------------------
- (void)setNavigationPaneBarButtonItem:(UIBarButtonItem *)navigationPaneBarButtonItem
{
    if (navigationPaneBarButtonItem != _navigationPaneBarButtonItem)
	{
        // Add the popover button to the left navigation item.
        [self.navigationBar.topItem setLeftBarButtonItem:navigationPaneBarButtonItem animated:NO];
    }
}

- (void)viewDidLoad
{
    // -setNavigationPaneBarButtonItem may have been invoked when before the
    // interface was loaded.  This will occur when setNavigationPaneBarButtonItem
    // is called as part of DetailViewManager preparing this view controller
    // for presentation as this is before the view is unarchived from the NIB.
    // When viewidLoad is invoked, the interface is loaded and hooked up.
    // Check if we are supposed to be displaying a navigationPaneBarButtonItem
    // and if so, add it to the navigationBar.
    if (self.navigationPaneBarButtonItem)
        [self.navigationBar.topItem setLeftBarButtonItem:self.navigationPaneBarButtonItem animated:NO];
	
	NSURL *myURL = [NSURL URLWithString: [feedUrlString stringByAddingPercentEscapesUsingEncoding:
                                          NSUTF8StringEncoding]];
    NSURLRequest *request = [NSURLRequest requestWithURL:myURL];
	
    [self.webView loadRequest:request];
	NSLog(@"%@", webView);
	
	
	
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationBar.topItem.title = self.title;
}

- (void)viewDidUnload {
	[super viewDidUnload];
	self.navigationBar = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

-(void) openLink:(NSString *)link
{
	
	
}

@end
