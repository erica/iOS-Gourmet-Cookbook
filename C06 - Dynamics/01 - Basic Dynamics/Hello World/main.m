/*
 
 Erica Sadun, http://ericasadun.com
 Gourmet Recipes
 
 */

@import UIKit;
#import "Essentials.h"
#import "WatcherBehavior.h"

@interface TestBedViewController : UIViewController <UIDynamicAnimatorDelegate>
@end

@implementation TestBedViewController
{
    UIDynamicAnimator *animator;
    UIView *testView;
    NSDate *date;
    NSTimer *timer;
    BOOL useWatcher;
}

- (void) dynamicAnimatorDidPause:(UIDynamicAnimator *) anAnimator
{
    // Remove behaviors
    [animator removeAllBehaviors];
    
    // Log and display the elapsed time
    Log(@"Elapsed time: %f", [[NSDate date] timeIntervalSinceDate:date]);
    self.title = [NSString stringWithFormat:@"%0.2f", [[NSDate date] timeIntervalSinceDate:date]];
    [timer invalidate];
    
    // Restore the interface
    self.navigationItem.rightBarButtonItem.enabled = YES;
    self.navigationItem.leftBarButtonItem.enabled = YES;
}

// Return a percent-based point within the rectangle
CGPoint RectGetPointAtPercents(CGRect rect, CGFloat xPercent, CGFloat yPercent)
{
    CGFloat dx = xPercent * rect.size.width;
    CGFloat dy = yPercent * rect.size.height;
    return CGPointMake(rect.origin.x + dx, rect.origin.y + dy);
}

- (void) go
{
    // Prepare interface
    self.navigationItem.rightBarButtonItem.enabled = NO;
    self.navigationItem.leftBarButtonItem.enabled = NO;
    self.title = @"";
    
    // Toggle destination
    static BOOL left = NO; left = !left;
    CGPoint p = (left) ? RectGetPointAtPercents(self.view.bounds, 0.25, 0.5) : RectGetPointAtPercents(self.view.bounds, 0.75, 0.5);
    
    // Store the date at the start of the behavior
    date = [NSDate date];
    
    // Add the behavior
    UISnapBehavior *snapBehavior = [[UISnapBehavior alloc] initWithItem:testView snapToPoint:p];
    [animator addBehavior:snapBehavior];
    
    // Optionally enable the watcher to shortcut the interaction
    if (useWatcher)
    {
        WatcherBehavior *watcher = [[WatcherBehavior alloc] initWithView:testView behavior:snapBehavior];
        [animator addBehavior:watcher];
    }
}

- (void) toggle
{
    useWatcher = !useWatcher;
    self.navigationItem.leftBarButtonItem = BARBUTTON(useWatcher ? @"DisableWatcher" : @"Enable Watcher", @selector(toggle));
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.extendLayoutUnderBars = NO;
    self.navigationItem.rightBarButtonItem = BARBUTTON(@"Go", @selector(go));
    self.navigationItem.leftBarButtonItem = BARBUTTON(@"Enable Watcher", @selector(toggle));
    
    // Layout self.view
    [self.view layoutIfNeeded];
    
    // Add a test view
    testView = BuildView(self, 60, 60, @"cyan", 0.4f, YES);
    PlaceView(self, testView, @"cc", 0, 0, 1000);
    [self.view layoutIfNeeded];
    
    // Prepare for dynamic animation by removing constraints
    RemoveConstraints(testView.externalConstraintReferences);

    // Establish the dynamic animator
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