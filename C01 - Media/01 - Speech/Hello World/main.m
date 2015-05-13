/*
 
 Erica Sadun, http://ericasadun.com
 Gourmet Recipes

 */

@import UIKit;
#import "Essentials.h"
#import "SpeechHelper.h"

#if TARGET_IPHONE_SIMULATOR
#error This is a device-only project. It will not work on the simulator.
#endif

@interface TestBedViewController : UIViewController
@end

@implementation TestBedViewController
- (void) sayHello
{
    [SpeechHelper speakModalString:@"Hello!"];
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = BARBUTTON(@"Hello", @selector(sayHello));
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