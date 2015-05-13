/*
 
 Erica Sadun, http://ericasadun.com
 Gourmet Recipes
 
 */

@import UIKit;
#import "Essentials.h"

@protocol EnableableItem
- (void) setEnabled: (BOOL) yorn;
@end

@interface TestBedViewController : UIViewController
@end

@implementation TestBedViewController
{
    UISlider *durationSlider;
    UISlider *dampingSlider;
    UISlider *velocitySlider;
    
    UILabel *l1;
    UILabel *l2;
    UILabel *l3;
    
    UIView *testView;
    
    NSLayoutConstraint *constraint;
}

- (void) positionViewOffscreen
{
    constraint.constant = - self.view.bounds.size.height * .6;
    [self.view layoutIfNeeded];
    
    for (id <EnableableItem> item in @[self.navigationItem.rightBarButtonItem, durationSlider, dampingSlider, velocitySlider])
    {
        [item setEnabled:YES];
    }
}

- (void) updateLabels
{
    l1.text = [NSString stringWithFormat:@"Duration: %0.2f", durationSlider.value];
    l2.text = [NSString stringWithFormat:@"Damping: %0.2f", dampingSlider.value];
    l3.text = [NSString stringWithFormat:@"Velocity: %0.2f", velocitySlider.value];
}

- (void) go
{
    for (id <EnableableItem> item in @[self.navigationItem.rightBarButtonItem, durationSlider, dampingSlider, velocitySlider])
    {
        [item setEnabled:NO];
    }
    
    CGFloat duration = durationSlider.value;
    CGFloat damping = dampingSlider.value;
    CGFloat velocity = velocitySlider.value;
    
    ESTABLISH_WEAK_SELF;
    [UIView animateWithDuration:duration
                          delay:0
         usingSpringWithDamping:damping
          initialSpringVelocity:velocity
                        options:0
                     animations:^{
                         ESTABLISH_STRONG_SELF;
                         constraint.constant = 0;
                         [strongSelf.view layoutIfNeeded];
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.6f animations:^{
                             ESTABLISH_STRONG_SELF;
                             [strongSelf positionViewOffscreen];
                         }];
                     }];
}

- (void) viewDidAppear:(BOOL)animated
{
    [self positionViewOffscreen];
    
    durationSlider.value = 1.0f;
    dampingSlider.value = 0.5f;
    velocitySlider.value = 0.5f;
    [self updateLabels];
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.extendLayoutUnderBars = YES;
    self.navigationItem.rightBarButtonItem = BARBUTTON(@"Go", @selector(go));
    
    durationSlider = [[UISlider alloc] init];
    durationSlider.minimumValue = 0.3f;
    durationSlider.maximumValue = 3.0f;
    
    dampingSlider = [[UISlider alloc] init];
    dampingSlider.minimumValue = 0.1f;
    dampingSlider.maximumValue = 1.0f;
    
    velocitySlider = [[UISlider alloc] init];
    velocitySlider.minimumValue = 0.0f;
    velocitySlider.maximumValue = 1.0f;
    
    for (UISlider *slider in @[durationSlider, dampingSlider, velocitySlider])
    {
        [slider addTarget:self action:@selector(updateLabels) forControlEvents:UIControlEventValueChanged];
    }
    
    l1 = [[UILabel alloc] init];
    l2 = [[UILabel alloc] init];
    l3 = [[UILabel alloc] init];
    
    for (UIView *view in @[durationSlider, dampingSlider, velocitySlider, l1, l2, l3])
    {
        [self.view addSubview:view];
        view.autoLayoutEnabled = YES;
        CenterViewInSuperview(view, YES, NO, 500);
        SizeView(view, CGSizeMake(200, SkipConstraint), 500);
    }
    
    id topLayoutGuide = self.topLayoutGuide;
    ConstrainViews(500, @"V:[topLayoutGuide]-[l1][durationSlider]-[l2][dampingSlider]-[l3][velocitySlider]", topLayoutGuide, l1, l2, l3, durationSlider, dampingSlider, velocitySlider);
    
    testView = [UIView new];
    PlaceView(self, testView, @"cc", 0, 0, 1000);
    SizeView(testView, CGSizeMake(100, 100), 1000);
    testView.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.3f];
    testView.layer.cornerRadius = 8;
    testView.userInteractionEnabled = NO;
    CenterViewInSuperview(testView, YES, NO, 1000);
    
    // Animatable constraint
    constraint = [NSLayoutConstraint constraintWithItem:testView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    [constraint setActive:YES];
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