/*
 
 Erica Sadun, http://ericasadun.com
 Adaptive Apps
 
 */

@import UIKit;
#import "Essentials.h"
#import "DynamicType.h"

@interface TestBedViewController : UIViewController
@end

@implementation TestBedViewController
- (void) viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    DynamicTextView *textView = [DynamicTextView new];
    PlaceView(self, textView, @"xx", 0, 0, 1000);
//    textView.editable = NO;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"Hello World\n" attributes:@{NSFontAttributeName:[UIFont headlineFont], NSForegroundColorAttributeName : [UIColor redColor]}];
    NSAttributedString *bodyString = [[NSAttributedString alloc] initWithString:@"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque quis magna non lectus molestie placerat at et sapien. Pellentesque ut accumsan lectus." attributes:@{NSFontAttributeName:[UIFont bodyFont]}];
    [attributedString appendAttributedString:bodyString];
    textView.attributedText = attributedString;
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