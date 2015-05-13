/*
 
 Erica Sadun, http://ericasadun.com
 Gourmet Recipes
 
 */

@import UIKit;
#import "Essentials.h"
#import "CustomDynamicItem.h"

@interface TestBedViewController : UIViewController
@end

@implementation TestBedViewController
{
    UIDynamicAnimator *animator;
    NSDate *date;
    CustomDynamicItem *item;
}

- (void) tick: (NSTimer *) timer
{
    if ([[NSDate date] timeIntervalSinceDate:date] > 10)
        [timer invalidate];
    NSLog(@"%@", item);
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    item = [[CustomDynamicItem alloc] init];
    item.bounds = CGRectMake(0, 0, 100, 100);
    item.center = CGPointMake(50, 50);
    item.transform = CGAffineTransformIdentity;
    
    animator = [[UIDynamicAnimator alloc] init];
    
    UIPushBehavior *push = [[UIPushBehavior alloc] initWithItems:@[item] mode:UIPushBehaviorModeContinuous];
    push.angle = M_PI_4;
    push.magnitude = 0.1f;
    
    [animator addBehavior:push];
    push.active = YES;
    
    date = [NSDate date];
    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(tick:) userInfo:nil repeats:YES];

}
@end

#pragma mark - Application Setup -

@interface TestBedAppDelegate : NSObject <UIApplicationDelegate, UINavigationControllerDelegate>
@property (nonatomic, strong) UIWindow *window;
@end

@implementation TestBedAppDelegate
- (NSUInteger)navigationControllerSupportedInterfaceOrientations:(UINavigationController *)navigationController
{
    return UIInterfaceOrientationMaskPortrait;
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