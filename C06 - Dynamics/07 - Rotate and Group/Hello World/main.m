/*
 
 Erica Sadun, http://ericasadun.com
 Gourmet Recipes
 
 */

@import UIKit;
#import "Essentials.h"
#import "DynamicUtilities.h"
#import "DragView.h"

@interface TestBedViewController : UIViewController <UIDynamicAnimatorDelegate>
@end

@implementation TestBedViewController
{
    NSMutableArray *views;
    BOOL isCentered;
    NSMutableArray *observers;
}

- (void) dealloc
{
    for (id observer in observers)
        [[NSNotificationCenter defaultCenter] removeObserver:observer];
}

- (void) go
{
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    // Remove constraints
    for (UIView *view in self.view.realSubviews)
        RemoveConstraints(view.externalConstraintReferences);
    
    if (!isCentered)
        SnapViewsToPoint(self.view.realSubviews, RectGetCenter(self.view.bounds), YES);
    else
        SnapViewsToStoredPositions(self.view.realSubviews);
    isCentered = !isCentered;
    
    id __block temporaryObserver = nil;
    ESTABLISH_WEAK_SELF;
    temporaryObserver = [[NSNotificationCenter defaultCenter] addObserverForName:AnimationsDidPause object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        ESTABLISH_STRONG_SELF;
        strongSelf.navigationItem.rightBarButtonItem.enabled = YES;        
        [[NSNotificationCenter defaultCenter] removeObserver:temporaryObserver];
    }];
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.extendLayoutUnderBars = NO;
    self.navigationItem.rightBarButtonItem = BARBUTTON(@"Go", @selector(go));
    
    views = @[].mutableCopy;
    for (int i = 0; i < 9; i++)
    {
        NSInteger h = 20 + RandomInteger(220);
        NSInteger v = 20 + RandomInteger(220);
        UIView *view = [[DragView alloc] initWithFrame:CGRectMake(h, v, 60, 60)];
        view.layer.cornerRadius = 12;
        view.layer.borderWidth = 1;
        view.backgroundColor = Random_Color();
        [self.view addSubview:view];
        view.tag = h * kMultiplier + v;
    }
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