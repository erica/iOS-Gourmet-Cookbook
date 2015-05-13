/*
 
 Erica Sadun, http://ericasadun.com
 Gourmet Recipes
 
 */

@import UIKit;
#import "Essentials.h"
#import "MotionEffects.h"
#import "AirPlayMotionEffectEnabler.h"

@interface TestBedViewController : UIViewController
@end

@implementation TestBedViewController
- (void) go
{
    [AirplayMotionEffectEnabler reenableMotionEffects];
}

CGFloat Random01()
{
    return ((CGFloat) arc4random() / (CGFloat) UINT_MAX);
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = BARBUTTON(@"Enable", @selector(go));
    
    for (int i = 0; i < 3; i++)
    {
        UIView *testView = [UIView new];
        PlaceView(self, testView, @"cc", 0, 0, 1000);
        SizeView(testView, CGSizeMake((3 - i) * 50, (3 - i) * 50), 1000);
        testView.backgroundColor = [UIColor colorWithRed:Random01() green:Random01() blue:Random01() alpha:1.0f];

        testView.layer.shadowOffset = CGSizeZero;
        testView.layer.shadowOpacity = 1.0f;
        testView.layer.shadowColor = [UIColor blackColor].CGColor;
        [testView addMotionEffect:[ShadowMotionEffect effectWithMagnitude:20]];
    }
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