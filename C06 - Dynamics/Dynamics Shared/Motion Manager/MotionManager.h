/*
 
 Erica Sadun, http://ericasadun.com
 
 */

@import CoreMotion;
@import Foundation;

extern NSString *const MotionManagerUpdate;
extern NSString *const MotionVectorKey;

@interface MotionManager : NSObject
+ (instancetype) sharedInstance;
- (void) establishMotionManager;
- (void) shutDownMotionManager;
- (void) startMotionUpdates;
@end
