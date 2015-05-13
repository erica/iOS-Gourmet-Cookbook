/*
 
 Erica Sadun, http://ericasadun.com
 Gourmet Recipes

 */

@import UIKit;
@import MediaPlayer;

#import "Essentials.h"
#import "MovieMaker.h"

@interface TestBedViewController : UIViewController
@end

@implementation TestBedViewController
{
    MovieMaker *maker;
}

- (void) buildAndShowMovie
{
    self.navigationItem.rightBarButtonItem = nil;
    
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/mymovie.mp4"];
    [MovieMaker preparePath:path];
    
    CGSize frameSize = CGSizeMake(640, 480);
    maker = [MovieMaker createMovieAtPath:path frameSize:frameSize fps:30];
    
    for (int i = 0; i < 100; i++)
    {
        [maker addDrawingToMovie:^(CGContextRef context) {
            // Fill with black
            [[UIColor blackColor] set];
            UIRectFill((CGRect){.size = frameSize});

            // Draw wedge
            UIBezierPath *path = [UIBezierPath  bezierPathWithArcCenter:CGPointMake(frameSize.width / 2.0, frameSize.height / 2.0) radius:200 startAngle:0 endAngle:i * (2 * M_PI / 100) clockwise:YES];
            UIColor *color = [UIColor colorWithHue:(i / 100.0) saturation:1.0 brightness:1.0 alpha:1.0];
            [color set];
            [path fill];
        }];
    }
    
    [maker finalizeMovie];
    
    // play
    MPMoviePlayerViewController *player = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL fileURLWithPath:path]];
    player.moviePlayer.controlStyle = MPMovieControlStyleFullscreen;
    
    [self.navigationController presentMoviePlayerViewControllerAnimated:player];

    __weak typeof(self) weakSelf = self;
    id observer1, observer2;
    observer1 = [[NSNotificationCenter defaultCenter] addObserverForName:MPMoviePlayerPlaybackDidFinishNotification object:player.moviePlayer queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification)
     {
         __strong typeof(self) strongSelf = weakSelf;
         [[NSNotificationCenter defaultCenter] removeObserver:observer1];
         [[NSNotificationCenter defaultCenter] removeObserver:observer2];
         strongSelf.navigationItem.rightBarButtonItem = BARBUTTON(@"Go", @selector(buildAndShowMovie));
     }];
    
    observer2 = [[NSNotificationCenter defaultCenter] addObserverForName:MPMoviePlayerLoadStateDidChangeNotification object:player.moviePlayer queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification)
     {
         if ((player.moviePlayer.loadState & MPMovieLoadStatePlayable) != 0)
             [player.moviePlayer performSelector:@selector(play) withObject:nil afterDelay:0.5];
     }];
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = BARBUTTON(@"Go", @selector(buildAndShowMovie));
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