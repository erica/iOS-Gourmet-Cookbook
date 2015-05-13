/*
 
 Erica Sadun, http://ericasadun.com
 Gourmet Recipes
 
 */

@import UIKit;
#import "Essentials.h"
#import "CustomView.h"
#import "CustomLayer.h"

@interface TestBedViewController : UIViewController
@end

@implementation TestBedViewController
{
    CustomView *customView;
}

- (void) go
{
    BOOL direction = customView.layer.cornerRadius < 32;
    CustomLayer *layer = (CustomLayer *) customView.layer;
    layer.cornerRadius = direction ? 32 : 0;
    layer.logoLevel = direction ? @(1.0) : @(0.0);
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = BARBUTTON(@"Go", @selector(go));
    customView = [CustomView new];
    customView.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:0.3];
    customView.layer.borderWidth = 2;
    PlaceView(self, customView, @"cc", 0, 0, 1000);
    SizeView(customView, CGSizeMake(200, 200), 1000);
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