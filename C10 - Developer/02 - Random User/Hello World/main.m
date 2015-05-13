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
    UIImageView *imageView;
    UITextView *textView;
}

#define ComplainAndBail(_complaint_, ...) {NSLog(_complaint_, __VA_ARGS__); return;}

- (NSString *) prettyPrintJSON : (NSString *) jsonString
{
    return nil;
}

- (void) go
{
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://api.randomuser.me"]];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSArray *results = dict[@"results"];
    if (!results) ComplainAndBail(@"Results dictionary not found", nil);
    NSDictionary *firstDict = [results firstObject];
    if (!firstDict) ComplainAndBail(@"Results dictionary not found", nil);
    
    NSString *urlString = firstDict[@"user"][@"picture"][@"medium"];
    if (!urlString) ComplainAndBail(@"No user picture", nil);
    
    NSURL *url = [NSURL URLWithString:urlString];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
    imageView.image = image;
    
    NSDictionary *userDict = firstDict[@"user"];
    NSMutableString *string = [NSMutableString string];
    [string appendFormat:@"%@ %@ %@\n", userDict[@"name"][@"title"], userDict[@"name"][@"first"], userDict[@"name"][@"last"]];
    [string appendFormat:@"%@ %@, %@ %@\n", userDict[@"location"][@"street"], userDict[@"location"][@"city"], userDict[@"location"][@"state"], userDict[@"location"][@"zip"]];
    [string appendFormat:@"%@\n", userDict[@"email"]];
    [string appendFormat:@"%@\n", userDict[@"phone"]];
    [string appendFormat:@"%@\n", userDict[@"username"]];

    textView.text = string.capitalizedString;
   
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.extendLayoutUnderBars = NO;
    self.navigationItem.rightBarButtonItem = BARBUTTON(@"Go", @selector(go));
    imageView = [UIImageView new];
    PlaceView(self, imageView, @"tc", 0, 20, 1000);
    SizeView(imageView, CGSizeMake(100, 100), 1000);
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    textView = [UITextView new];
    textView.editable = NO;
    textView.textAlignment = NSTextAlignmentCenter;
    PlaceView(self, textView, @"bx", 0, 0, 1000);
    ConstrainViews(1000, @"V:[imageView]-[textView]", imageView, textView);
    
    [self go];
    
    NSLog(@"%@", NSHomeDirectory());
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