/*
 
 Erica Sadun, http://ericasadun.com
 Gourmet Recipes
 
 */

@import UIKit;
#import "Essentials.h"
#import "AnimatingShapeImageView.h"
#import "Shapes.h"

@interface TestBedViewController : UIViewController
@end

@implementation TestBedViewController
{
    AnimatingShapeImageView *imageView;
}

- (void) pick: (UIBarButtonItem *) bbi
{
    NSInteger which = [self.navigationItem.rightBarButtonItems indexOfObject:bbi];
    switch (which)
    {
        case 1: // circle
            imageView.shape = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 320, 320)];
            break;
        case 2: // rounded rect
            imageView.shape = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 320, 320) cornerRadius:32];
            break;
        case 3: // duck
            imageView.shape = BezierDuck();
            break;
        default:
        case 0: // square
            imageView.shape = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 320, 320)];
            break;
    }
}

- (void) go: (UIBarButtonItem *) bbi
{
    NSInteger which = [self.navigationItem.leftBarButtonItems indexOfObject:bbi];
//    imageView.primaryColor = @[[UIColor blackColor], [UIColor greenColor], [UIColor grayColor], [UIColor redColor]][random()  % 4];
    switch (which)
    {
        case 0: // stop
            [imageView setAnimation:nil];
            break;
        case 1: // fade
            [imageView setAnimation:ScaleAndFadeKey];
            break;
        case 2: // ants
            [imageView setAnimation:MarchingAntsKey];
            break;
        default:
            break;
    }
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItems = @
    [
     BARBUTTON(@"Square", @selector(pick:)),
     BARBUTTON(@"Circle", @selector(pick:)),
     BARBUTTON(@"Rounded", @selector(pick:)),
     BARBUTTON(@"Duck", @selector(pick:)),
     ];

    self.navigationItem.leftBarButtonItems = @
    [
     BARBUTTON(@"X", @selector(go:)),
     BARBUTTON(@"Scale", @selector(go:)),
     BARBUTTON(@"Ants", @selector(go:)),
     ];
    
    imageView = [AnimatingShapeImageView new];
    PlaceView(self, imageView, @"cc", 0, 0, 1000);
    SizeView(imageView, CGSizeMake(240, 240), 1000);
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = [UIImage imageNamed:@"bryce"];
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