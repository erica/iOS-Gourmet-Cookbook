/*
 
 Erica Sadun, http://ericasadun.com
 Gourmet Recipes
 
 */

@import UIKit;
#import "Essentials.h"
#import "CamPack.h"
#import "SpeechHelper.h"

#if TARGET_IPHONE_SIMULATOR
#error This is a device-only project. It will not work on the simulator.
#endif

@interface TestBedViewController : UIViewController <CameraHelperMetadataDelegate>
@end

@implementation TestBedViewController
{
    CameraHelper *helper;
    UIView *previewView;
    UIView *overlay;
    NSDate *timeToDie; // lockout for convenience
    CADisplayLink *overlayChecker;
}

- (void) checkOverlay: (CADisplayLink *) sender
{
    if (CGRectEqualToRect(CGRectZero, overlay.frame)) return;
    if (!timeToDie) return;
    if ([timeToDie timeIntervalSinceDate:[NSDate date]] > 0) return;
    timeToDie = nil;
    overlay.frame = CGRectZero;
}

- (void) processBarcode: (NSString *) barcode withType: (NSString *) codeType withMetadata: (AVMetadataMachineReadableCodeObject *) metadata
{
    NSLog(@"%@ : %@", codeType, barcode);
    if (![self.title isEqualToString:barcode])
    {
        self.title = barcode;
        [SpeechHelper speakString:barcode];
    }
    
    AVCaptureVideoPreviewLayer *layer = [CameraHelper previewInView:previewView];
    AVMetadataMachineReadableCodeObject *codeObject = (AVMetadataMachineReadableCodeObject *)[layer transformedMetadataObjectForMetadataObject:metadata];
    overlay.frame = [self.view convertRect:codeObject.bounds fromView:previewView];
    timeToDie = [NSDate dateWithTimeIntervalSinceNow:2.0f];
}

- (void) processFace:(AVMetadataFaceObject *)metadata
{
    NSLog(@"Face: %@", metadata);
    AVCaptureVideoPreviewLayer *layer = [CameraHelper previewInView:previewView];
    AVMetadataFaceObject *faceObject = (AVMetadataFaceObject *)[layer transformedMetadataObjectForMetadataObject:metadata];
    overlay.frame = [self.view convertRect:faceObject.bounds fromView:previewView];
    timeToDie = [NSDate dateWithTimeIntervalSinceNow:1.0f];
    [SpeechHelper speakString:@"I see a face"];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Start the camera helper session
    helper = [CameraHelper newSession];
    [helper useBackCamera];
    [helper embedPreviewInView:previewView];
    [helper setVideoOutputScale:1.5f];
    [helper startSession];
    
    // Establish the metadata delegate for recognition hits
    helper.metadataDelegate = self;
    [helper addMetaDataOutput];
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    // Camera preview
    previewView = [[UIView alloc] init];
    PlaceView(self, previewView, @"xx", 0, 0, 1000);
    
    // Detection feedback overlay
    overlay = [[UIView alloc] init];
    [self.view addSubview:overlay];
    overlay.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:0.3f];
    overlayChecker = [CADisplayLink displayLinkWithTarget:self selector:@selector(checkOverlay:)];
    [overlayChecker addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
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