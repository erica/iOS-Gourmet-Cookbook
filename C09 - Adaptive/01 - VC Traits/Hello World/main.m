/*
 
 Erica Sadun, http://ericasadun.com
 Gourmet Recipes
 
 */

@import UIKit;
#import "Essentials.h"
#import "TraitExplorer.h"

@interface TestBedViewController : UIViewController
@end

@implementation TestBedViewController
- (void) traitCollectionDidChange:(UITraitCollection *)previousTraitCollection
{
    NSLog(@"Trait collection did change");
    // Will not be called for iPad re-orientation
    [TraitExplorer explore:self];
    [TraitExplorer showCoordinateSpaces];
}

- (void) go
{
    // Constructors
    UITraitCollection *scale1Collection = [UITraitCollection traitCollectionWithDisplayScale:1.0];
    UITraitCollection *scale2Collection = [UITraitCollection traitCollectionWithDisplayScale:2.0];
    UITraitCollection *scale3Collection = [UITraitCollection traitCollectionWithDisplayScale:3.0];
    UITraitCollection *padCollection = [UITraitCollection traitCollectionWithUserInterfaceIdiom:UIUserInterfaceIdiomPad];
    UITraitCollection *phoneCollection = [UITraitCollection traitCollectionWithUserInterfaceIdiom:UIUserInterfaceIdiomPhone];
    UITraitCollection *hRegSizeCollection = [UITraitCollection traitCollectionWithHorizontalSizeClass:UIUserInterfaceSizeClassRegular];
    UITraitCollection *hCompactSizeCollection = [UITraitCollection traitCollectionWithHorizontalSizeClass:UIUserInterfaceSizeClassCompact];
    UITraitCollection *vRegSizeCollection = [UITraitCollection traitCollectionWithVerticalSizeClass:UIUserInterfaceSizeClassRegular];
    UITraitCollection *vCompactSizeCollection = [UITraitCollection traitCollectionWithVerticalSizeClass:UIUserInterfaceSizeClassCompact];
    
    // Peek
    [TraitExplorer printTraits:scale1Collection];
    [TraitExplorer printTraits:scale2Collection];
    [TraitExplorer printTraits:scale3Collection];
    [TraitExplorer printTraits:padCollection];
    [TraitExplorer printTraits:phoneCollection];
    [TraitExplorer printTraits:hCompactSizeCollection];
    [TraitExplorer printTraits:hRegSizeCollection];
    [TraitExplorer printTraits:vCompactSizeCollection];
    [TraitExplorer printTraits:vRegSizeCollection];
    
    // Collect
    UITraitCollection *coll1 = [UITraitCollection traitCollectionWithTraitsFromCollections:@[padCollection, hCompactSizeCollection, vRegSizeCollection, scale1Collection]];
    [TraitExplorer printTraits:coll1];
    
    UITraitCollection *coll2 = [UITraitCollection traitCollectionWithTraitsFromCollections:@[padCollection, hCompactSizeCollection, vRegSizeCollection, scale1Collection, scale2Collection, phoneCollection]];
    [TraitExplorer printTraits:coll2];
    
    // Override example
    UITraitCollection *override = [UITraitCollection traitCollectionWithTraitsFromCollections:@[self.traitCollection, hRegSizeCollection]];
    [TraitExplorer printTraits:override];
}

- (void) orientationDidChange: (NSNotification *) note
{
    NSLog(@"Orientation did change");
    [TraitExplorer explore:self];
    [TraitExplorer showCoordinateSpaces];
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    TestForIOS8;
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = BARBUTTON(@"Go", @selector(go));
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
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