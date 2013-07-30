#import <UIKit/UIKit.h>

@interface SecondTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, NSXMLParserDelegate>

@property(nonatomic,strong) NSString *feedName;
@property(nonatomic,strong) NSString *feedURL;

@property(nonatomic,strong) NSXMLParser *parser;
@property(nonatomic,strong) NSMutableArray *feeds;
@property(nonatomic,strong) NSMutableDictionary *feed_item;
@property(nonatomic,strong) NSMutableString *feed_title;
@property(nonatomic,strong) NSMutableString *feed_link;
@property(nonatomic,strong) NSString *feed_element;

@end
