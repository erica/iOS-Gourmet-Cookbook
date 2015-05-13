/*
 
 Erica Sadun, http://ericasadun.com
 
 */

#import "MotionManager.h"

#ifndef VALUE
#define VALUE(struct) ({ __typeof__(struct) __struct = struct; [NSValue valueWithBytes:&__struct objCType:@encode(__typeof__(__struct))]; })
#endif

NSString *const MotionManagerUpdate = @"MotionManagerUpdate";
NSString *const MotionVectorKey = @"MotionVectorKey";

static MotionManager *sharedInstance = nil;

@interface MotionManager ()
@property (nonatomic, strong) CMMotionManager *motionManager;
@end

@implementation MotionManager
+ (instancetype) sharedInstance
{
    if (!sharedInstance)
        sharedInstance = [[self alloc] init];
    
    return sharedInstance;
}

- (void) shutDownMotionManager
{
    NSLog(@"Shutting down motion manager");
    [_motionManager stopAccelerometerUpdates];
    _motionManager = nil;
}

- (void) establishMotionManager
{
    if (_motionManager)
        [self shutDownMotionManager];
    
    // Establish the motion manager
    NSLog(@"Establishing motion manager");
    _motionManager = [[CMMotionManager alloc] init];
}

- (void) startMotionUpdates
{
    if (!_motionManager)
        [self establishMotionManager];
    
    if (_motionManager.accelerometerAvailable)
        [_motionManager
         startAccelerometerUpdatesToQueue:[[NSOperationQueue alloc] init]
         withHandler:^(CMAccelerometerData *data, NSError *error)
         {
             CGVector vector = CGVectorMake(data.acceleration.x, -(data.acceleration.y + 0.5));
             NSDictionary *dict = @{MotionVectorKey:VALUE(vector)};
             [[NSNotificationCenter defaultCenter] postNotificationName:MotionManagerUpdate object:self userInfo:dict];
         }];
    
}
@end
