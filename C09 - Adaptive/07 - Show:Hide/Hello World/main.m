/*
 
 Erica Sadun, http://ericasadun.com
 Gourmet Recipes
 
 */

@import UIKit;
#import "Essentials.h"
#import "CannedTableViewController.h"
#import "DetailViewController.h"

@interface TestBedViewController : UIViewController <UISplitViewControllerDelegate>
@end

@implementation TestBedViewController
{
    UISplitViewController *split;
    CannedTableViewController *tvc;
    DetailViewController *detail;
}

// Respond to user taps by showing detail controller if needed
- (void) updateDetail: (NSNotification *) note
{
    NSDictionary *dict = note.object;
    if (!dict) return;
    [detail.view layoutIfNeeded];
    detail.label.text = dict[CannedValueKey];
    [tvc showDetailViewController:detail.navigationController sender:nil];
}

// Ensure that an empty detail view is not shown first. Called only on horizontally compact destinations
- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController
{
    if (!detail.label.text || !detail.label.text.length)
        return YES;
    return NO;
}

- (void) viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        // add coordinated changes here
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        // add completion tasks here
    }];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.view layoutIfNeeded];
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Create master and detail
    tvc = [CannedTableViewController controllerWithItems:@[@"Alpha", @"Bravo", @"Charlie", @"Delta", @"Echo", @"Foxtrot", @"Golf", @"Hotel", @"India", @"Juliett", @"Kilo"]];
    tvc.title = @"Table";
    detail = [DetailViewController new];
    
    // Embed them into navigation controllers
    UINavigationController *masterNav = [[UINavigationController alloc] initWithRootViewController:tvc];
    UINavigationController *detailNav = [[UINavigationController alloc] initWithRootViewController:detail];
    
    // Create split view controller
    split = [UISplitViewController new];
    split.viewControllers = @[masterNav, detailNav];
    split.preferredDisplayMode = UISplitViewControllerDisplayModeAllVisible;
    split.delegate = self;
    
    detail.navigationItem.rightBarButtonItem = split.displayModeButtonItem;
    
    // Add child VC
    [self addChildViewController:split];
    PlaceView(self, split.view, @"xx", 0, 0, 1000);
    [split didMoveToParentViewController:self];
    
    // Respond to user taps on master
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateDetail:) name:CannedTableTap object:nil];
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
    //    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    _window.rootViewController = vc;
    [_window makeKeyAndVisible];
    return YES;
}
@end

int main(int argc, char *argv[]) {
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, @"TestBedAppDelegate");
    }
}