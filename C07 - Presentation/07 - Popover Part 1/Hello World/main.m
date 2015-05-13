/*
 
 Erica Sadun, http://ericasadun.com
 Gourmet Recipes
 
 */
@import UIKit;
#import "Essentials.h"

@interface TestBedViewController : UIViewController <UIAdaptivePresentationControllerDelegate>
@end

@implementation TestBedViewController
- (UIViewController *) buildPopoverController
{
    // Build the view controller
    UIViewController *vc = [UIViewController new];
    
    // Set its presentation style to popover
    vc.modalPresentationStyle = UIModalPresentationPopover;
    vc.preferredContentSize = CGSizeMake(200, 200);
    vc.popoverPresentationController.barButtonItem = self.navigationItem.rightBarButtonItem;
    vc.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    vc.presentationController.delegate = self;
    
    // Set up its contents
    [vc.view layoutIfNeeded];
    UILabel *testLabel = [UILabel new];
    testLabel.text = @"Hello World";
    testLabel.font = [UIFont fontWithName:@"AmericanTypewriter-Bold" size:24];
    [vc.view addSubview:testLabel];
    PlaceViewInSuperview(testLabel, @"cc", 0, 0, 1000);
    
    return vc;
}

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller
{
    return UIModalPresentationNone;
}

- (void) go
{
    UIViewController *presentationVC = [self buildPopoverController];
    [self presentViewController:presentationVC animated:YES completion:nil];
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = BARBUTTON(@"Go", @selector(go));
    TestForIOS8;
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