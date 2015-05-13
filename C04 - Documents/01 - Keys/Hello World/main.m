/*
 
 Erica Sadun, http://ericasadun.com
 Gourmet Recipes
 
 */

@import UIKit;
#import "Essentials.h"
#import "KeySupportTextField.h"
#import "UIKeyCommand+Utility.h"

@interface TestBedViewController : UIViewController
@end

@implementation TestBedViewController
{
    KeySupportTextField *textField;
    id observer;
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:observer];
}

- (void) viewDidAppear:(BOOL)animated
{
    [textField becomeFirstResponder];
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.extendLayoutUnderBars = NO;
    //    self.navigationItem.rightBarButtonItem = BARBUTTON(@"Go", @selector(go));
    
    textField = [[KeySupportTextField alloc] init];
    PlaceView(self, textField, @"cc", 0, 0, 1000);
    SizeView(textField, CGSizeMake(200, 40), 1000);
    textField.layer.borderWidth = 2;
    
    [textField listenForKey:@"n" modifiers:UIKeyModifierCommand|UIKeyModifierShift];
    [textField listenForKey:@"t" modifiers:0];
    [textField listenForKey:@"t" modifiers:UIKeyModifierShift];
    [textField listenForKey:@"h" modifiers:UIKeyModifierAlternate];
    
    observer = [[NSNotificationCenter defaultCenter] addObserverForName:KeySupportFieldEvent object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        NSLog(@"%@", StringFromKeyCommand(note.object));
    }];
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