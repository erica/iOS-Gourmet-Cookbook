/*
 
 Erica Sadun, http://ericasadun.com
 Gourmet Recipes
 
 */

@import UIKit;
#import "Essentials.h"
#import "SnapZoneHandler.h"
#import "UIView+Dragging.h"

/*
 
 KNOWN BUG: From iOS 7.x to iOS 8.x, Apple made some changes to auto layout participation, breaking the view dragging implementation. That's why the view now has its translatesAutoresizingMaskIntoConstraints property enabled and disabled in the moving routine. As a side-effect, expect to see a few minor errors in the console if you use size constraints on your draggable views. You can safely ignore these.
*/

@interface TestBedViewController : UIViewController <UIDynamicAnimatorDelegate>
@end

@implementation TestBedViewController
{
    UIView *testView;
    SnapZoneHandler *handler;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.extendLayoutUnderBars = NO;
    
    // Place a drop zone in each corner
    NSMutableArray *dropZones = [@[] mutableCopy];
    for (int i = 0; i < 4; i++)
    {
        UIView *dropZone = BuildView(self, 100, 100, @"lightGray", 1, NO);
        NSString *position = @[@"tl", @"tr", @"bl", @"br"][i];
        PlaceView(self, dropZone, position, 20, 20, 500);
        dropZone.tag = i + 1;
        [dropZones addObject:dropZone];
    }
    
    // Place a draggable view in the center
    testView = BuildView(self, 80, 80, @"cyan", 0.5, YES);
    testView.draggingEnabled = YES;
    testView.sendDragNotifications = YES;
    PlaceView(self, testView, @"cc", 0, 0, 500);
    
    handler = [SnapZoneHandler handlerWithReferenceView:self.view];
    handler.dropZones = [dropZones copy];
    
    [self.view layoutIfNeeded];
    testView.autoLayoutEnabled = NO;
    RemoveConstraints(testView.externalConstraintReferences);
}
@end

#pragma mark - Application Setup -

@interface TestBedAppDelegate : NSObject <UIApplicationDelegate, UINavigationControllerDelegate>
@property (nonatomic, strong) UIWindow *window;
@end

@implementation TestBedAppDelegate
- (NSUInteger)navigationControllerSupportedInterfaceOrientations:(UINavigationController *)navigationController
{
    return UIInterfaceOrientationMaskLandscape;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    TestBedViewController *vc = [[TestBedViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    nav.delegate = self;
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