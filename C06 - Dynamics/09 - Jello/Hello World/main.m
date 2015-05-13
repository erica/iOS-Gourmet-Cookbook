/*
 
 Erica Sadun, http://ericasadun.com
 Gourmet Recipes
 
 */

@import UIKit;
#import "Essentials.h"
#import "JellyView.h"
#import "Utility.h"

@interface TestBedViewController : UIViewController <UIDynamicAnimatorDelegate>
@end

@implementation TestBedViewController
{
    UIDynamicAnimator *animator;
    JellyView *jellyView;
}

- (void) dynamicAnimatorDidPause:(UIDynamicAnimator *)anAnimator
{
    [animator removeAllBehaviors];
}

- (void) close: (UIButton *) sender
{
    [UIView animateWithDuration:1.0 animations:^{
        jellyView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [jellyView removeFromSuperview];
        jellyView = nil;
    }];
}

- (void) resetJelly
{
    if (jellyView) [jellyView removeFromSuperview];
    
    // Create and place a new Jelly View
    CGSize jellySize = CGSizeMake(200, 200);
    jellyView = [JellyView view:jellySize];
    jellyView.color = [[UIColor purpleColor] colorWithAlphaComponent:0.5];
    [self.view addSubview:jellyView];
    jellyView.center = CGPointMake(CGRectGetMidX(self.view.bounds), -200);
    
    // Populate the view with interesting things
    BOOL addChildren = YES;
    if (addChildren)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button setTitle:@"Done" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
        button.autoLayoutEnabled = YES;
        [jellyView addSubview:button];
        
        UILabel *title = [UILabel new];
        title.text = @"Bouncy Alert";
        [jellyView addSubview:title];
        title.autoLayoutEnabled = YES;
        
        UISwitch *mySwitch = [UISwitch new];
        [jellyView addSubview:mySwitch];
        mySwitch.autoLayoutEnabled = YES;
        CenterViewInSuperview(mySwitch, YES, YES, 1000);
        
        AlignViews(500, title, mySwitch, NSLayoutAttributeCenterX);
        AlignViews(500, title, button, NSLayoutAttributeCenterX);
        ConstrainViews(500, @"V:[title]-[mySwitch]-[button]", title, mySwitch, button);
        [jellyView layoutIfNeeded];
    }
}

- (void) go
{
    [animator removeAllBehaviors];
    [self resetJelly];
    [jellyView establishDynamics:animator];
    
    UICollisionBehavior *boundary = [[UICollisionBehavior alloc] initWithItems:@[jellyView]];
    CGFloat y = CGRectGetMidY(self.view.bounds) + 100;
    [boundary addBoundaryWithIdentifier:@"boundary" fromPoint:CGPointMake(0, y) toPoint:CGPointMake(self.view.bounds.size.width, y)];
    [animator addBehavior:boundary];
    
    UIGravityBehavior *gravity = [[UIGravityBehavior alloc] initWithItems:@[jellyView]];
    [animator addBehavior:gravity];
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = BARBUTTON(@"Button", @selector(go));
    self.extendLayoutUnderBars = YES;
    [self.view layoutIfNeeded];
    
    animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    [animator setDelegate:self];
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