/*
 
 Erica Sadun, http://ericasadun.com
 Gourmet Recipes
 
 */

@import UIKit;
#import "Essentials.h"
#import "DragView.h"

@interface TestBedViewController : UIViewController
@end

@implementation TestBedViewController
{
    UITextView *textView;
    NSTextStorage *storage;
    NSTextContainer *container;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.extendLayoutUnderBars = NO;
    NSString *string = @"Why, man, he doth bestride the narrow world Like a Colossus, and we petty men Walk under his huge legs and peep about To find ourselves dishonourable graves. Men at some time are masters of their fates: The fault, dear Brutus, is not in our stars, But in ourselves, that we are underlings. Brutus and Caesar: what should be in that 'Caesar'? Why should that name be sounded more than yours? Write them together, yours is as fair a name;  Sound them, it doth become the mouth as well; Weigh them, it is as heavy; conjure with 'em, Brutus will start a spirit as soon as Caesar. Now, in the names of all the gods at once, Upon what meat doth this our Caesar feed,  That he is grown so great? Age, thou art shamed! Rome, thou hast lost the breed of noble bloods! When went there by an age, since the great flood, But it was famed with more than with one man? When could they say till now, that talk'd of Rome, That her wide walls encompass'd but one man? Now is it Rome indeed and room enough, When there is in it but one only man. O, you and I have heard our fathers say, There was a Brutus once that would have brook'd  The eternal devil to keep his state in Rome As easily as a king.";
    NSAttributedString *s = [[NSAttributedString alloc] initWithString:string attributes:@{NSFontAttributeName : [UIFont fontWithName:@"Georgia" size:18]}];
    
    storage = [[NSTextStorage alloc] initWithAttributedString:s];
    NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
    layoutManager.allowsNonContiguousLayout = YES;
    [storage addLayoutManager:layoutManager];
    
    container = [[NSTextContainer alloc] initWithSize:self.view.bounds.size];
    [layoutManager addTextContainer:container];
    container.lineBreakMode = NSLineBreakByCharWrapping;
    
    textView = [[UITextView alloc] initWithFrame:CGRectZero textContainer:container];
    [self.view addSubview:textView];
    textView.autoLayoutEnabled = YES;
    textView.editable = NO;
    textView.scrollEnabled = NO;
    StretchViewHorizontallyToSuperview(textView, 0, 1000);
    StretchViewToTopLayoutGuide(self, textView, 0, 1000);
    StretchViewToBottomLayoutGuide(self, textView, 0, 1000);
    
    CGRect r = CGRectMake(0, 0, 100, 100);
    UIBezierPath *bunny = bunnyPath(r.size);
    DragView *draggable = [DragView instanceWithFrame:r path:bunny];
    draggable.backgroundColor = [UIColor redColor];
    draggable.container = container;
    [textView addSubview:draggable];
    container.exclusionPaths = @[bunny];
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