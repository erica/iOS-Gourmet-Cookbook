/*
 
 Erica Sadun, http://ericasadun.com
 Gourmet Recipes
 
 */

@import UIKit;
#import "Essentials.h"
#import "Shapes.h"
#import "ShapeView.h"

@interface TestBedViewController : UIViewController
@end

@implementation TestBedViewController
{
    ShapeImageView *imageView;
}

- (void) pick: (UIBarButtonItem *) bbi
{
    NSInteger which = [self.navigationItem.rightBarButtonItems indexOfObject:bbi];
    switch (which)
    {
        case 1: // circle
            imageView.shape = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 320, 320)];
            break;
        case 2: // duck
            imageView.shape = BezierDuck();
            break;
        default:
        case 0: // square
            imageView.shape = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 320, 320)];
            break;
    }
}

- (void) tweak: (UIBarButtonItem *) bbi
{
    // To demonstrate standard layer border behavior
//    imageView.layer.borderWidth = 8;
//    return;
    
    // To demonstrate desired border behavior
//    imageView.borderWidth = 8;
//    return;

    // Randomize size and color
    NSInteger which = [self.navigationItem.leftBarButtonItems indexOfObject:bbi];
    switch (which)
    {
        case 1: // size
            imageView.borderWidth = (CGFloat)(random() % 4);
            break;
        default:
        case 0: // color
            imageView.borderColor = @[[UIColor clearColor], [UIColor blackColor], [UIColor redColor], [UIColor greenColor]][random() % 4];
            break;
    }
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    imageView = [ShapeImageView new];
    PlaceView(self, imageView, @"cc", 0, 0, 1000);
    SizeView(imageView, CGSizeMake(240, 240), 1000);
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = [UIImage imageNamed:@"bryce"];
    
    self.navigationItem.rightBarButtonItems = @
    [
     BARBUTTON(@"Square", @selector(pick:)),
     BARBUTTON(@"Circle", @selector(pick:)),
     BARBUTTON(@"Duck", @selector(pick:)),
     ];
    
    self.navigationItem.leftBarButtonItems = @
    [
     BARBUTTON(@"Color", @selector(tweak:)),
     BARBUTTON(@"Size", @selector(tweak:)),
    ];
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