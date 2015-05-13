/*
 
 Erica Sadun, http://ericasadun.com
 Gourmet Recipes
 
 */

@import UIKit;
#import "Essentials.h"
#import "StackButton.h"

@interface TestBedViewController : UIViewController
@end

@implementation TestBedViewController
- (void) go
{
    for (StackButton *button in self.view.subviews)
    {
        button.cornerRadius = (button.cornerRadius == 4) ? 16 : 4;
    }
}

- (void) tap: (StackButton *) button
{
    NSLog(@"Tap");
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = BARBUTTON(@"Go", @selector(go));
    
    StackButton *topButton = [StackButton topButton];
    StackButton *centerButton = [StackButton centerButton];
    StackButton *bottomButton = [StackButton bottomButton];
    
    for (StackButton *button in @[topButton, centerButton, bottomButton])
    {
//        button.borderColor = [UIColor darkGrayColor];
//        button.textColor = [UIColor darkGrayColor];
        [button addTarget:self action:@selector(tap:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [topButton setTitle:@"Top" forState:UIControlStateNormal];
    [centerButton setTitle:@"Center" forState:UIControlStateNormal];
    [bottomButton setTitle:@"Bottom" forState:UIControlStateNormal];
    
    PlaceView(self, topButton, @"-c", 0, 0, 1000);
    PlaceView(self, centerButton, @"cc", 0, 0, 1000);
    PlaceView(self, bottomButton, @"-c", 0, 0, 1000);
    
    for (NSString *format in @[@"V:[topButton(==centerButton)][centerButton(==80)][bottomButton(==centerButton)]",
                               @"H:[centerButton(==200)]",
                               @"H:[topButton(==centerButton)]",
                               @"H:[bottomButton(==centerButton)]"])
    {
        ConstrainViews(1000, format, topButton, centerButton, bottomButton);
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