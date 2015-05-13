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
    UITextView *textView;
}

- (void) print
{
    UIPrintInfo *printInfo = [UIPrintInfo printInfo];
    printInfo.outputType = UIPrintInfoOutputGeneral;
    printInfo.jobName = @"My Print Job";
    
   
    UIPrintInteractionController *printController = [UIPrintInteractionController sharedPrintController];
    printController.printInfo = printInfo;
    printController.showsPageRange = YES;
    printController.printFormatter = textView.viewPrintFormatter;
    
    [printController presentAnimated:YES completionHandler:
     ^(UIPrintInteractionController *controller,
       BOOL completed, NSError *error)
     {
         if (!completed)
         {
             NSLog(@"Printing error: %@", error.localizedDescription);
             return;
         }
     }];
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = BARBUTTON(@"Print", @selector(print));
    textView = [UITextView new];
    PlaceView(self, textView, @"xx", 0, 0, 1000);
    NSString *string = @"Why, man, he doth bestride the narrow world Like a Colossus, and we petty men Walk under his huge legs and peep about To find ourselves dishonourable graves. Men at some time are masters of their fates: The fault, dear Brutus, is not in our stars, But in ourselves, that we are underlings. Brutus and Caesar: what should be in that 'Caesar'? Why should that name be sounded more than yours? Write them together, yours is as fair a name;  Sound them, it doth become the mouth as well; Weigh them, it is as heavy; conjure with 'em, Brutus will start a spirit as soon as Caesar. Now, in the names of all the gods at once, Upon what meat doth this our Caesar feed,  That he is grown so great? Age, thou art shamed! Rome, thou hast lost the breed of noble bloods! When went there by an age, since the great flood, But it was famed with more than with one man? When could they say till now, that talk'd of Rome, That her wide walls encompass'd but one man? Now is it Rome indeed and room enough, When there is in it but one only man. O, you and I have heard our fathers say, There was a Brutus once that would have brook'd  The eternal devil to keep his state in Rome As easily as a king.";
    NSMutableAttributedString *s = [[NSMutableAttributedString alloc] initWithString:string attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Georgia" size:28]}];
    NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
    style.lineBreakMode = NSLineBreakByWordWrapping;
    [s addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, s.string.length)];
    [textView.textStorage appendAttributedString:s];
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