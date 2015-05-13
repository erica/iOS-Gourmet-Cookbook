/*
 
 Erica Sadun, http://ericasadun.com
 Gourmet Recipes
 
 */

@import UIKit;
#import "Essentials.h"
#import "CustomTransitioning.h"
#import "TransitionView.h"
#import "FlipTransition.h"
#import "Utility.h"

static NSInteger animationChoice = 0;

@interface TestBedViewController : UIViewController
@end

@implementation TestBedViewController
{
    UIImageView *imageView;
    UISegmentedControl *segmentedControl;
}

- (void) go
{
    TestBedViewController *tbvc = [self.class new];
    [self.navigationController pushViewController:tbvc animated:YES];
}

- (void) viewWillAppear:(BOOL)animated
{
    segmentedControl.selectedSegmentIndex = animationChoice;
}

- (void) updateAnimation: (UISegmentedControl *) seg
{
    animationChoice = seg.selectedSegmentIndex;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.extendLayoutUnderBars = YES;
    self.navigationItem.rightBarButtonItem = BARBUTTON(@"Go", @selector(go));
    
    imageView = [[UIImageView alloc] init];
    PlaceView(self, imageView, @"xx", 0, 0, 1000);
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = BlockImage();
    
    segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"flip", @"cube", @"copy", @"ping"]];
    [segmentedControl addTarget:self action:@selector(updateAnimation:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = segmentedControl;
}
@end

#pragma mark - Application Setup -

@interface TestBedAppDelegate : NSObject <UIApplicationDelegate, UINavigationControllerDelegate>
@property (nonatomic, strong) UIWindow *window;
@end

@implementation TestBedAppDelegate
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    CustomTransitioning *transitioning = [[CustomTransitioning alloc] init];
    BOOL forward = operation == UINavigationControllerOperationPush;
    switch (animationChoice)
    {
        case 0:
            transitioning.transitionType = forward ? kCustomFlipInTransition : kCustomFlipOutTransition;
            transitioning.duration = 1.0;
            break;
        case 1:
            transitioning.transitionType = forward ? kCustomCubeForwardTransition : kCustomCubeBackTransition;
            transitioning.duration = 1.0;
            break;
        case 2:
            transitioning.transitionType = forward ? kCustomCopyMachineForwardTransition : kCustomCopyMachineBackTransition;
            transitioning.duration = 1.5;
            break;
        case 3:
            transitioning.transitionType = forward ? kCustomBounceInTransition : kCustomBounceOutTransition;
            transitioning.duration = 0.6f;
            break;
        default:
            transitioning.transitionType = kCustomFadeTransition;
            transitioning.duration = 1.0;
            break;
    }
    return transitioning;
}

/*
 // Book
 - (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
 {
 FlipTransition *transition = [[FlipTransition alloc] init];
 BOOL forward = (operation == UINavigationControllerOperationPush);
 transition.forward = forward;
 transition.duration = 0.6f;
 return transition;
 }
 */

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