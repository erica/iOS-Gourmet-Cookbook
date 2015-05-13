/*
 
 Erica Sadun, http://ericasadun.com
 
 */

@import UIKit;
extern NSString *const CannedTableTap;
extern NSString *const CannedValueKey;
extern NSString *const CannedIndexPathKey;

@interface CannedTableViewController : UITableViewController
+ (instancetype) controllerWithItems: (NSArray *) items;
@property (nonatomic, readonly) NSMutableArray *items;
@end
