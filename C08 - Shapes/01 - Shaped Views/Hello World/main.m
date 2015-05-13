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
        case 2: // rounded rect
            imageView.shape = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 320, 320) cornerRadius:32];
            break;
        case 3: // carrot
            imageView.shape = BezierCarrot();
            break;
        case 4: // duck
            imageView.shape = BezierDuck();
            break;
        case 5: // unclosed
        {
            UIBezierPath *path = [UIBezierPath bezierPath];
            [path moveToPoint:CGPointZero];
            [path addLineToPoint:CGPointMake(0, 1)];
            [path addLineToPoint:CGPointMake(1, 1)];
            
//            [path moveToPoint:CGPointMake(1, 1)];
//            [path addLineToPoint:CGPointMake(0, 1)];
            
            imageView.shape = path;
            break;
        }
        default:
        case 0: // square
            imageView.shape = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 320, 320)];
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
     BARBUTTON(@"Rounded", @selector(pick:)),
     BARBUTTON(@"Carrot", @selector(pick:)),
     BARBUTTON(@"Duck", @selector(pick:)),
     BARBUTTON(@"Unclosed", @selector(pick:)),
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