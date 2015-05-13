/*
 
 Erica Sadun, http://ericasadun.com
 Gourmet Recipes
 
 */

@import UIKit;
#import "Essentials.h"
#import "URLReadyLabel.h"

@interface TestBedViewController : UIViewController <URLResponder>
@end

@implementation TestBedViewController
{
    URLReadyLabel *label;
}

- (BOOL) label:(URLReadyLabel *) label shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange;
{
    return YES;
}


- (void) viewDidAppear:(BOOL)animated
{
    // To preview glyphs
    // [label outlineCharacterGlyphs];
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.extendLayoutUnderBars = YES;
    
    label = [URLReadyLabel new];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.urlDelegate = self;
    
    PlaceView(self, label, @"cc", 0, 0, 1000);
    SizeView(label, CGSizeMake(280, 300), 1000);
    
    NSString *source = @"I like to buy items from the Apple Store and to read things written by Erica Sadun.";
    UIFont *font = [UIFont fontWithName:@"Georgia" size:IS_IPAD ? 36 : 24];
    NSMutableAttributedString *s = [[NSMutableAttributedString alloc] initWithString:source attributes:@{NSFontAttributeName:font}];
    [s addAttribute:NSLinkAttributeName value:[NSURL URLWithString:@"http://ericasadun.com"] range:[source rangeOfString:@"Erica Sadun"]];
    [s addAttribute:NSLinkAttributeName value:[NSURL URLWithString:@"http://store.apple.com"] range:[source rangeOfString:@"the Apple Store"]];
    label.attributedText = s;
    label.userInteractionEnabled = YES;
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