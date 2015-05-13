/*
 
 Erica Sadun, http://ericasadun.com
 Gourmet Recipes
 
 */

@import UIKit;
#import "Essentials.h"
#import "Hello_World-Swift.h"

@interface TestBedViewController : UIViewController
@end

@implementation TestBedViewController
- (void) viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    MyCocoaClass *firstInstance = [MyCocoaClass new];
    [firstInstance test];
    
    MySwiftClass *secondInstance = [MySwiftClass new]; // Error
    [secondInstance test];
    
    MyComplexClass *thirdInstance = [MyComplexClass instance];
    [thirdInstance test];
    thirdInstance.myInt = 42;
    thirdInstance.string = @"Glorp!";
    thirdInstance.string = nil;
    
//    VisibleToObjectiveC *visible = nil;
//    NotVisibleToObjectiveC *invisible = nil;
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