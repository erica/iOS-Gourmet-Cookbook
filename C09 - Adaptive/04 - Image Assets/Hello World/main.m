/*
 
 Erica Sadun, http://ericasadun.com
 Gourmet Recipes
 
 */

@import UIKit;
#import "Essentials.h"
@interface TestBedViewController : UIViewController
@end

@implementation TestBedViewController
{
    UIImageView *imageView;
    UIImageAsset *imageAsset;
}
- (void) traitCollectionDidChange:(UITraitCollection *)previousTraitCollection
{
    NSLog(@"Trait collection did change");
    imageView.image = [imageAsset imageWithTraitCollection:self.traitCollection];
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    imageView = [UIImageView new];
    imageView.contentMode = UIViewContentModeCenter;
    PlaceView(self, imageView, @"xx", 0, 0, 1000);
    
    UITraitCollection *compactHeight = [UITraitCollection traitCollectionWithVerticalSizeClass:UIUserInterfaceSizeClassCompact];
    UITraitCollection *regularHeight = [UITraitCollection traitCollectionWithVerticalSizeClass:UIUserInterfaceSizeClassRegular];
    
    imageAsset = [UIImageAsset new];
    [imageAsset registerImage:[UIImage imageNamed:@"SmallDog"] withTraitCollection:compactHeight];
    [imageAsset registerImage:[UIImage imageNamed:@"LargeDog"] withTraitCollection:regularHeight];
    
    imageView.image = [imageAsset imageWithTraitCollection:self.traitCollection];
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