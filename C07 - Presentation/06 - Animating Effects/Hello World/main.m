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

- (void) buildBlurView
{
    if (!blurView)
    {
        // Build the blur
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        blurView = [[UIVisualEffectView alloc] initWithEffect:blur];
        PlaceView(self, blurView, @"xx", 40, 120, 1000);
        [self.view layoutIfNeeded];
        SizeView(blurView, blurView.bounds.size, 1000);
        blurView.maskView = [self customMaskView];
        
        // Build the vibrancy
        UIVibrancyEffect *vibrancy = [UIVibrancyEffect effectForBlurEffect:blur];
        vibrancyView = [[UIVisualEffectView alloc] initWithEffect:vibrancy];
        vibrancyView.autoLayoutEnabled = YES;
        [blurView.contentView addSubview:vibrancyView];
        StretchViewToSuperview(vibrancyView, CGSizeZero, 1000);
        
        // Add the label
        UILabel *testLabel = [UILabel new];
        testLabel.text = @"Hello World";
        testLabel.font = [UIFont fontWithName:@"AmericanTypewriter-Bold" size:32];
        [vibrancyView.contentView addSubview:testLabel];
        PlaceViewInSuperview(testLabel, @"cc", 0, 0, 1000);
    }
}

- (void) go: (UIBarButtonItem *) bbi
{
    [self buildBlurView];
    
    NSInteger choice = [self.navigationItem.rightBarButtonItems indexOfObject:bbi];
    switch (choice) {
        case 0:
        {
            // Screenshot main view with the blur view hidden
            blurView.hidden = YES;
            UIView *newView = [self.view snapshotViewAfterScreenUpdates:YES];
            blurView.hidden = NO;
            [self.view addSubview:newView];
            
            [UIView animateWithDuration:1 animations:^{
                newView.alpha = 0.0;
            } completion:^(BOOL finished) {
                [newView removeFromSuperview];
            }];
            break;
        }
        case 1:
        {
            // Scale
            blurView.transform = CGAffineTransformMakeScale(0.001, 0.001);
            [UIView animateWithDuration:1 animations:^{
                blurView.transform = CGAffineTransformIdentity;
            }];
            break;
        }
        case 2:
        {
            // Translate
            [NSLayoutConstraint deactivateConstraints:blurView.externalConstraintReferences];
            PlaceViewInSuperview(blurView, @"tc", 0, -500, 1000);
            [self.view layoutIfNeeded];
            [NSLayoutConstraint deactivateConstraints:blurView.externalConstraintReferences];
            
            [UIView animateWithDuration:1 animations:^{
                PlaceViewInSuperview(blurView, @"cc", 0, 0, 1000);
                [self.view layoutIfNeeded];
            }];
            break;
        }
        case 3:
        {
            // broken
            blurView.alpha = 0.0;
            [UIView animateWithDuration:1.0 animations:^{
                blurView.alpha = 1.0;
            }];
        }
            
        default:
            break;
    }
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItems =
    @[
      BARBUTTON(@"Alpha", @selector(go:)),
      BARBUTTON(@"Scale", @selector(go:)),
      BARBUTTON(@"Translate", @selector(go:)),
      BARBUTTON(@"Broken", @selector(go:)),
      ];
    
    imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"backdrop"]];
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