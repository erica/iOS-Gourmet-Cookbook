/*
 
 Erica Sadun, http://ericasadun.com
 Gourmet Recipes
 
 */

@import UIKit;
#import "Essentials.h"
#import "DynamicType.h"

#define CellAlreadySetUp   999

@interface TestBedViewController : UITableViewController
@end

@implementation TestBedViewController
{
    NSArray *items;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return items.count;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    int topLabelTag = 101;
    int bottomLabelTag = 102;
    
    // Set up cell if needed
    if (cell.tag != CellAlreadySetUp)
    {
        // Dynamic labels will respond to dynamic type notifications
        // In iOS 8, auto layout automatically adjusts the cell height
        
        DynamicLabel *label1 = [DynamicLabel labelWithTextStyle:UIFontTextStyleHeadline];
        label1.text = @"Headline";
        [cell.contentView addSubview:label1];
        PlaceViewInSuperview(label1, @"tx", 4, 4, 1000);
        label1.tag = topLabelTag;
        
        DynamicLabel *label2 = [DynamicLabel labelWithTextStyle:UIFontTextStyleCaption2];
        label2.text = @"Caption 2";
        [cell.contentView addSubview:label2];
        PlaceViewInSuperview(label2, @"bx", 4, 4, 1000);
        label2.tag = bottomLabelTag;
        
        ConstrainViews(1000, @"V:[label1]-2-[label2]", label1, label2);
        
        cell.tag = CellAlreadySetUp;
    }
    
    // Initialize with model data
    DynamicLabel *label1 = (DynamicLabel *) [cell.contentView viewWithTag:topLabelTag];
    label1.text = items[indexPath.row];
    DynamicLabel *label2 = (DynamicLabel *) [cell.contentView viewWithTag:bottomLabelTag];
    label2.text = [NSString stringWithFormat:@"Caption text for %@", items[indexPath.row]];
    
    return cell;
}

- (void) loadView
{
    [super loadView];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    items = [@"alpha bravo charlie delta echo foxtrot golf" componentsSeparatedByString:@" "];
}
@end

#pragma mark - Application Setup -

@interface TestBedAppDelegate : NSObject <UIApplicationDelegate>
@property (nonatomic, strong) UIWindow *window;
@end

@implementation TestBedAppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    TestBedViewController *vc = [[TestBedViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    _window.rootViewController = nav;
    [_window makeKeyAndVisible];
    return YES;
}
@end

int main(int argc, char *argv[]) {
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, @"TestBedAppDelegate");
    }
}