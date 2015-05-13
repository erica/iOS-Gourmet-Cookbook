/*
 
 Erica Sadun, http://ericasadun.com
 Gourmet Recipes
 
 */

@import UIKit;
#import "Essentials.h"
#import "AnimatorReadyViewController.h"
#import "MotionManager.h"

#if TARGET_IPHONE_SIMULATOR
#warning This project is intended for use on the device. It will run on the Simulator but all the blocks will simply fall to the bottom and the fun is over. Use a device with an accelerometer built-in to see the actual project intent.
#endif

@interface TestBedViewController : AnimatorReadyViewController
@end

@implementation TestBedViewController
{
    NSMutableArray *testViews;
    UIDynamicItemBehavior *dynamicItem;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    for (UIView *view in testViews)
    {
        RemoveConstraints(view.externalConstraintReferences);
        RemoveConstraints(view.internalConstraintReferences);
        view.autoLayoutEnabled = NO;
        [self.deviceGravityBehavior addItem:view];
    }
    
    dynamicItem = [[UIDynamicItemBehavior alloc] initWithItems:testViews];
    [self.animator addBehavior:dynamicItem];
    
    [self setBoundariesForViews:testViews];
    [self enableGravity:YES];
}

- (void) updateSlider: (UISlider *) slider
{
    // elas, fric, resis
    if (slider.tag == 0)
        dynamicItem.elasticity = slider.value;
    else if (slider.tag == 1)
        dynamicItem.friction = slider.value;
    else if (slider.tag == 2)
        dynamicItem.resistance = slider.value;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.extendLayoutUnderBars = NO;
    
    testViews = @[].mutableCopy;
    
    for (int i = 0; i < 4; i++)
    {
        UIView *view = BuildView(self, 50, 50, nil, 0.3f, YES);
        view.userInteractionEnabled = NO;
        [self.view addSubview:view];
        StretchViewToTopLayoutGuide(self, view, 4, 100);
        [testViews addObject:view];
    }
    
    ConstrainViewArray(100, @"H:|-[view1][view2][view3][view4]", self.view.realSubviews);
    
    NSArray *labelNames = @[@"Elasticity", @"Friction", @"Resistance"];
    NSMutableArray *labels = [NSMutableArray array];
    NSMutableArray *sliders = [NSMutableArray array];
    for (int i = 0; i < labelNames.count; i++)
    {
        UILabel *label = [[UILabel alloc] init];
        label.autoLayoutEnabled = YES;
        label.text = labelNames[i];
        [self.view addSubview:label];
        [labels addObject:label];
        
        UISlider *slider = [[UISlider alloc] init];
        slider.autoLayoutEnabled = YES;
        slider.minimumValue = 0;
        slider.maximumValue = 1;
        slider.value = 0.5f;
        slider.tag = i;
        [self.view addSubview:slider];
        [sliders addObject:slider];
        [slider addTarget:self action:@selector(updateSlider:) forControlEvents:UIControlEventValueChanged];
        
        AlignViews(500, label, slider, NSLayoutAttributeCenterY);
        ConstrainViews(500, @"H:|-[label]-[slider]-|", label, slider);
    }
    
    NSArray *tmp = [@[self.topLayoutGuide] arrayByAddingObjectsFromArray:sliders];
    ConstrainViewArray(100, @"V:[view1]-20-[view2]-[view3]-[view4]", tmp);
    
    [self.view layoutIfNeeded];
}
@end

#pragma mark - Application Setup -

@interface TestBedAppDelegate : NSObject <UIApplicationDelegate, UINavigationControllerDelegate>
@property (nonatomic, strong) UIWindow *window;
@end

@implementation TestBedAppDelegate
- (NSUInteger)navigationControllerSupportedInterfaceOrientations:(UINavigationController *)navigationController
{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    TestBedViewController *vc = [[TestBedViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    nav.delegate = self;
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