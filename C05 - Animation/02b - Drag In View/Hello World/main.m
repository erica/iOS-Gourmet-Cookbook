/*
 
 Erica Sadun, http://ericasadun.com
 Gourmet Recipes
 
 */

@import UIKit;
#import "Essentials.h"
#import "DragInView.h"

@interface TestBedViewController : UIViewController
@end

@implementation TestBedViewController
{
    DragInView *dragInView;
}

- (void) tap: (UIButton *) button
{
    NSLog(@"tapped");
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.extendLayoutUnderBars = NO;
    
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:@"Button" forState:UIControlStateNormal];
    [button setTitleColor:APP_TINT_COLOR forState:UIControlStateNormal];
    [button addTarget:self action:@selector(tap:) forControlEvents:UIControlEventTouchUpInside];

    dragInView = [DragInView viewWithParent:self side:NSLayoutAttributeTop];
    [dragInView addSubview:button];
    PlaceViewInSuperview(button, @"bc", 0, 60, 1000);
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