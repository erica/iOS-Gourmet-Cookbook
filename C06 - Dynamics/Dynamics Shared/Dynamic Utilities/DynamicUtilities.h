/*
 
 Erica Sadun, http://ericasadun.com
 
 */

@import UIKit;
#define kMultiplier 8192

extern NSString *const AnimationsDidPause;
#define kViewShrinkageToApply   0.5

UIView *CommonReferenceView(NSArray *views);
void SnapViewsToPoint(NSArray *views, CGPoint point, BOOL scaleAndRotate);
void SnapViewsToStoredPositions(NSArray *views);
