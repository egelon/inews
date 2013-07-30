#import <UIKit/UIKit.h>

@interface FirstTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate >
{
	UIAlertView *loginPrompt;
}
@property (nonatomic, strong) NSMutableArray *feed_names;
@property (nonatomic, strong) NSMutableArray *feed_urls;
@end
