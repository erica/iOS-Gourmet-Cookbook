/*
 
 Erica Sadun, http://ericasadun.com
 
 */

#import "CannedTableViewController.h"
NSString *const CannedTableTap = @"CannedTableTap";
NSString *const CannedValueKey = @"CannedValueKey";
NSString *const CannedIndexPathKey = @"CannedIndexPathKey";


@interface CannedTableViewController ()

@end

@implementation CannedTableViewController

#pragma mark - Init

- (id)initWithStyle:(UITableViewStyle)style
{
    if (!(self = [super initWithStyle:style])) return self;
    _items = [NSMutableArray array];
    return self;
}

- (void) loadView
{
    [super loadView];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}

+ (instancetype) controllerWithItems: (NSArray *) items
{
    CannedTableViewController *tvc = [self new];
    [tvc.items addObjectsFromArray:items];
    return tvc;
}

#pragma mark - Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _items.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = [_items[indexPath.row] description];
    return cell;
}

#pragma mark - Delegation
- (void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[NSNotificationCenter defaultCenter] postNotificationName:CannedTableTap object:nil];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dictionary = @{
                                 CannedIndexPathKey:indexPath,
                                 CannedValueKey:_items[indexPath.row]
                                 };
    [[NSNotificationCenter defaultCenter] postNotificationName:CannedTableTap object:dictionary];
}
@end
