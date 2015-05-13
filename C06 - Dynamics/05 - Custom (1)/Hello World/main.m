/*
 
 Erica Sadun, http://ericasadun.com
 Gourmet Recipes
 
 */

@import UIKit;
#import "Essentials.h"
#import "ViewWatcher.h"
#import "BoundsDynamicBehavior.h"

@interface TestBedViewController : UIViewController <ViewWatcherDelegate, UIDynamicAnimatorDelegate>
@end

@implementation TestBedViewController
{
    UIView *testView;
    UIDynamicAnimator *animator;
    NSDate *date;
}

- (void) dynamicAnimatorDidPause:(UIDynamicAnimator *)anAnimator
{
    NSLog(@"XPaused: %f", [[NSDate date] timeIntervalSinceDate:date]);
    [animator removeAllBehaviors];
    [testView.gestureRecognizers.lastObject setEnabled:YES];
}

- (void) viewDidPause: (UIView *) view
{
    [animator removeAllBehaviors];
}

- (void) handleTap: (UITapGestureRecognizer *) tap
{
    if (tap.state == UIGestureRecognizerStateRecognized)
    {
        tap.enabled = NO;
        date = [NSDate date];
        
        // Clean up constraints
        RemoveConstraints(testView.internalConstraintReferences);
        RemoveConstraints(testView.externalConstraintReferences);
        testView.autoLayoutEnabled = NO;
        testView.bounds = CGRectMake(0, 0, 60, 60);
        
        ResizableDynamicBehavior *behavior = [[ResizableDynamicBehavior alloc] initWithView:testView];
        [animator addBehavior:behavior];
        [[ViewWatcher sharedInstance] startWatchingView:testView withDelegate:self];
    }
    
}

- (void) viewDidAppear:(BOOL)animated
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    tap.numberOfTapsRequired = 1;
    [testView addGestureRecognizer:tap];
    self.title = @"Tap the Red View";
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.extendLayoutUnderBars = NO;
    
    testView = BuildView(self, 60, 60, @"red", 1, YES);
    PlaceView(self, testView, @"cc", 0, 0, 100);
    
    animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    animator.delegate = self;
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