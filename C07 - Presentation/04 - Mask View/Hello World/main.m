/*
 
 Erica Sadun, http://ericasadun.com
 Gourmet Recipes
 
 */

@import UIKit;
#import "Essentials.h"
#import "MaskedImageView.h"

@interface TestBedViewController : UIViewController
@end

@implementation TestBedViewController
{
    MaskedImageView *imageView;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    imageView = [MaskedImageView new];
    PlaceView(self, imageView, @"xx", 0, 0, 1000);
    imageView.image = [UIImage imageNamed:@"image"];
    imageView.maskImage = [UIImage imageNamed:@"gasmask"];
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