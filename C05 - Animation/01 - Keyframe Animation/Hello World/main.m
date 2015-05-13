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
    UIView *testView;
}

CGFloat DampedSinusoid(CGFloat time, CGFloat distance, CGFloat decayAccelerator)
{
    return  1 - cos(distance) * exp(-1.0 * time * decayAccelerator);
}

/*
 UIViewKeyframeAnimationOptionCalculationModePaced is not an optional option here. Without it,
 the animation circles just once. Bizarre.
 */

// Animate the view in a circle
- (void) circle: (UIView *) view
{
    CGFloat numberOfSteps = 60;
    CGFloat stepDuration = 1.0 / numberOfSteps;
    CGFloat numberOfRotations = 6;
    CGFloat radius = 50;
    
    void (^animationBlock)() = ^{
        CGFloat elapsedSteps = 0.0f;
        while (elapsedSteps < numberOfSteps)
        {
            CGFloat percent = elapsedSteps / numberOfSteps;
            CGFloat theta = percent * 2 * M_PI * numberOfRotations;
            [UIView addKeyframeWithRelativeStartTime: percent relativeDuration:stepDuration animations:^{
                CGAffineTransform r = CGAffineTransformMakeRotation(-theta);
                CGAffineTransform t = CGAffineTransformMakeTranslation(radius * sin(theta), radius * cos(theta));
                view.transform = CGAffineTransformConcat(r, t);}];
            elapsedSteps += 1.0;
        }
        [UIView addKeyframeWithRelativeStartTime:(numberOfSteps - 1.0) / numberOfSteps relativeDuration:stepDuration animations:^{
            view.transform = CGAffineTransformIdentity;}];
    };
    
    [UIView animateKeyframesWithDuration:5.0 delay:0 options:UIViewKeyframeAnimationOptionCalculationModePaced animations:animationBlock completion:nil];
}

// Shake the view
- (void) shake: (UIView *) view
{
    NSInteger numberOfShakes = 8;
    
    void (^animationBlock)() = ^{
        CGAffineTransform t1 = CGAffineTransformMakeTranslation(2, -2);
        CGAffineTransform t2 = CGAffineTransformMakeTranslation(-2, 2);
        for (int i = 0; i < numberOfShakes; i++)
        {
            CGFloat progress = (CGFloat) i / (CGFloat) numberOfShakes;
            [UIView addKeyframeWithRelativeStartTime:progress relativeDuration:1.0 / numberOfShakes animations:^{view.transform = (i % 2) ? t1 : t2;}];
        }
        [UIView addKeyframeWithRelativeStartTime:(numberOfShakes - 1.0) / numberOfShakes relativeDuration: 1.0 / numberOfShakes animations:^{view.transform = CGAffineTransformIdentity;}];
    };
    
    [UIView animateKeyframesWithDuration:1.0 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear |
     UIViewAnimationOptionCurveLinear animations:animationBlock completion:nil];
}

// Create a pop effect
- (void) pop: (UIView *) view
{
    void (^animationBlock)() = ^{
        // Animation steps in total
        NSInteger numberOfSteps = 30;
        
        // Amount to oscillate
        CGFloat numberOfOscillations = 2;
        CGFloat oscillationDistance = numberOfOscillations * 2 * M_PI;
        
        // Perform oscillation over n-1 steps
        for (NSInteger step = 1; step < numberOfSteps; step++)
        {
            CGFloat progress = (CGFloat) step / (CGFloat) numberOfSteps;
            CGFloat distance = progress * oscillationDistance;
            CGFloat dampValue = 1 - DampedSinusoid(progress, distance, 2);
            
            [UIView addKeyframeWithRelativeStartTime:progress relativeDuration:1.0 / numberOfSteps animations:^{
                CGFloat degree = 1.0f + dampValue * 0.3f;
                view.transform = CGAffineTransformMakeScale(degree, degree);
            }];
        }
        
        // Return to normal
        [UIView addKeyframeWithRelativeStartTime:(numberOfSteps - 1.0) / numberOfSteps relativeDuration:1.0 / numberOfSteps animations:^{
            view.transform = CGAffineTransformIdentity;
        }];
    };
    
    [UIView animateKeyframesWithDuration:1.5 delay:0 options:0 animations:animationBlock completion:nil];
}

// Wiggle the view
- (void) wiggle: (UIView *) view
{
    void (^animationBlock)() = ^{
        // Animation steps in total
        NSInteger numberOfSteps = 24;
        
        // Amount to oscillate
        CGFloat numberOfOscillations = 4;
        CGFloat oscillationDistance = numberOfOscillations * 2 * M_PI;
        
        // Perform oscillation over n steps
        for (NSInteger step = 1; step < numberOfSteps; step++)
        {
            CGFloat progress = (CGFloat) step / (CGFloat) numberOfSteps; // percentage
            CGFloat distance = progress * oscillationDistance;
            CGFloat dampValue = DampedSinusoid(progress, distance, 1);
            
            [UIView addKeyframeWithRelativeStartTime:progress relativeDuration:1.0 / numberOfSteps animations:^{
                CGFloat degree = dampValue * 10;
                view.transform = CGAffineTransformMakeTranslation(degree, 0);
            }];
        }
    };
    
    [UIView animateKeyframesWithDuration:0.6f delay:0 options:0 animations:animationBlock completion:nil];
}


- (void) pick: (UIBarButtonItem *) item
{
    NSInteger index = [self.navigationItem.rightBarButtonItems indexOfObject:item];
    switch (index)
    {
        case 0:
            [self wiggle:testView];break;
        case 1:
            [self pop:testView];break;
        case 2:
            [self shake:testView]; break;
        case 3:
            [self circle:testView]; break;
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
      BARBUTTON(@"wiggle", @selector(pick:)),
      BARBUTTON(@"pop", @selector(pick:)),
      BARBUTTON(@"shake", @selector(pick:)),
      BARBUTTON(@"circle", @selector(pick:)),
      ];
    
    testView = [[UIView alloc] init];
    [self.view addSubview:testView];
    testView.autoLayoutEnabled = YES;
    SizeView(testView, CGSizeMake(50, 50), 1000);
    CenterViewInSuperview(testView, YES, YES, 1000);
    testView.backgroundColor = [UIColor greenColor];
    testView.layer.borderWidth = 2;
    testView.layer.cornerRadius = 8;
    testView.layer.borderColor = [UIColor clearColor].CGColor;
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