/*
 
 Erica Sadun, http://ericasadun.com
 Gourmet Recipes
 
 */

@import UIKit;
#import "Essentials.h"

@interface TestBedViewController : UIViewController
@end

@implementation TestBedViewController

- (void) go
{
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Title" message:@"Message" preferredStyle:UIAlertControllerStyleActionSheet];
    if (!controller) {
        NSLog(@"Unable to create controller");
        return;
    }
    
    __weak typeof(controller) weakController = controller;
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"Action 1" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        __strong typeof(controller) strongController = weakController;
        NSLog(@"Action1: %@", action);
        [strongController dismissViewControllerAnimated:YES completion:nil];
    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"Action 2" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        __strong typeof(controller) strongController = weakController;
        NSLog(@"Action2: %@", action);
        [strongController dismissViewControllerAnimated:YES completion:nil];
    }];
    
    //    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"Action 3" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    //        __strong typeof(controller) strongController = weakController;
    //        NSLog(@"Action3: %@", action);
    //        [strongController dismissViewControllerAnimated:YES completion:nil];
    //    }];
    
    
    UIAlertAction *destructive1 = [UIAlertAction actionWithTitle:@"Destructive Action" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        __strong typeof(controller) strongController = weakController;
        NSLog(@"Destruct1: %@", action);
        [strongController dismissViewControllerAnimated:YES completion:nil];
    }];
    
    UIAlertAction *destructive2 = [UIAlertAction actionWithTitle:@"Destructive Action2" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        __strong typeof(controller) strongController = weakController;
        NSLog(@"Destruct2: %@", action);
        [strongController dismissViewControllerAnimated:YES completion:nil];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        __strong typeof(controller) strongController = weakController;
        NSLog(@"Cancel Action: %@", action);
        [strongController dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [controller addAction:action1];
    [controller addAction:action2];
    //    [controller addAction:action3];
    [controller addAction:destructive1];
    [controller addAction:destructive2];
    [controller addAction:cancelAction];
    
    //    destructive1.enabled = NO; // <-- Use with great care. No visual feedback
    //    action1.enabled = NO;
    
    // If you want your action sheet to appear in the right place on your iPad and look right, make sure to include these two lines
    controller.popoverPresentationController.barButtonItem = self.navigationItem.rightBarButtonItem;
    controller.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    
    [self presentViewController:controller animated:YES completion:nil];
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = BARBUTTON(@"Button", @selector(go));
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