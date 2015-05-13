/*
 
 Erica Sadun, http://ericasadun.com
 Gourmet Recipes
 
 */

@import UIKit;
#import "Essentials.h"

@interface TestBedViewController : UIViewController
@end

@implementation TestBedViewController
- (void) viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.extendLayoutUnderBars = NO;
    
    for (int i = 0; i < 4; i++)
    {
        UIImageView *imageView = [UIImageView new];
        imageView.tag = i + 1;
        PlaceView(self, imageView, @[@"tl",@"tr",@"bl", @"br"][i], 0, 0, 1000);
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = LoremPixel(CGSizeMake(300, 300), nil, NO);
    }
    
    for (int i = 0; i < 4; i++)
    {
        UIImageView *imageView1 = (UIImageView *)[self.view viewWithTag:[@[@1, @3, @1, @2][i] integerValue]];
        UIImageView *imageView2 = (UIImageView *)[self.view viewWithTag:[@[@2, @4, @3, @4][i] integerValue]];
        NSString *format = [NSString stringWithFormat:@"%@:|[imageView1(==imageView2)][imageView2]|",  @[@"H", @"H", @"V", @"V"][i]];
        NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:nil views:NSDictionaryOfVariableBindings(imageView1, imageView2)];
        InstallConstraints(constraints, 1000);
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