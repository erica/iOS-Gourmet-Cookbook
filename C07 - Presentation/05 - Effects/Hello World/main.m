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
    UIVisualEffectView *blurView;
    UIVisualEffectView *vibrancyView;
    UIImageView *imageView;
}

// Build and return a rounded rect mask with an inset edge
- (UIImageView *) customMaskView
{
    // Filled rounded rect
    UIBezierPath *path1 = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(blurView.bounds, 8, 8) cornerRadius:28];
    // Stroked rounded rect
    UIBezierPath *path2 = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(blurView.bounds, 4, 4) cornerRadius:32];
    path2.lineWidth = 2;
    
    // Perform drawing
    UIGraphicsBeginImageContext(blurView.bounds.size);
    [[UIColor blackColor] set];
    [path1 fill];
    [path2 stroke];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Create and return the mask view
    UIImageView *maskView = [[UIImageView alloc] initWithImage:image];
    maskView.frame = blurView.bounds;
    return maskView;
}

- (void) go: (UIBarButtonItem *) bbi
{
    UIBlurEffect *blur;
    static NSInteger imageNumber = 0;
    
    NSInteger index = [self.navigationItem.rightBarButtonItems indexOfObject:bbi];
    switch (index) {
        case 0: {
            blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
            break;
        }
        case 1: {
            blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
            break;
        }
        case 2: {
            blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
            break;
        }
        case 3: {
            [blurView removeFromSuperview];
            return;
        }
        case 4: {
            imageNumber = (imageNumber + 1) % 3;
            NSString *imageName = @[@"agate.jpg", @"bryce.jpg", @"backdrop"][imageNumber];
            imageView.image = [UIImage imageNamed:imageName];
            return;
        }
        default:
            break;
    }
    
    [blurView removeFromSuperview];
    blurView = [[UIVisualEffectView alloc] initWithEffect:blur];
    PlaceView(self, blurView, @"xx", 40, 40, 1000);
    [self.view layoutIfNeeded];
    blurView.maskView = [self customMaskView];
    
    
    UIVibrancyEffect *vibrancy = [UIVibrancyEffect effectForBlurEffect:blur];
    vibrancyView = [[UIVisualEffectView alloc] initWithEffect:vibrancy];
    
    // Add vibrancy view
    vibrancyView.autoLayoutEnabled = YES;
    [blurView.contentView addSubview:vibrancyView];
    StretchViewToSuperview(vibrancyView, CGSizeZero, 1000);
    
    // Build UI Catalog
    UILabel *testLabel = [UILabel new];
    testLabel.text = @"Test Label";
    testLabel.font = [UIFont fontWithName:@"AmericanTypewriter-Bold" size:32];
    UISwitch *theSwitch = [UISwitch new];
    UISlider *slider = [UISlider new];
    SizeView(slider, CGSizeMake(150, SkipConstraint), 1000);
    UIStepper *stepper = [UIStepper new];
    UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:@[@"1", @"2", @"3", @"4"]];
    
    // Place items
    CGFloat offset = 60;
    for (UIView *view in @[testLabel, theSwitch, slider, stepper, segment])
    {
        [vibrancyView.contentView addSubview:view];
        PlaceViewInSuperview(view, @"tc", 0, offset, 1000);
        offset += 60;
    }
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItems =
    @[
      BARBUTTON(@"BlurD", @selector(go:)),
      BARBUTTON(@"BlurL", @selector(go:)),
      BARBUTTON(@"BlurXL", @selector(go:)),
      BARBUTTON(@"Clear", @selector(go:)),
      BARBUTTON(@"Pic", @selector(go:)),
      ];
    
    imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"agate.jpg"]];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    PlaceView(self, imageView, @"xx", 0, 0, 1000);
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