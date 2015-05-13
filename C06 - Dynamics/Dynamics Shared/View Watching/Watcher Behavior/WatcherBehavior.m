/*
 
 Erica Sadun, http://ericasadun.com
 
 */

#import "WatcherBehavior.h"

#define VALUE(struct) ({ __typeof__(struct) __struct = struct; [NSValue valueWithBytes:&__struct objCType:@encode(__typeof__(__struct))]; })

// Uncomment to log the velocities
// #define SHOW_LOGS

// You can easily substitute other tests than comparing frames, but this
// is a pretty good test for many UIView animations that don't involve rotation
static BOOL CompareFrames(CGRect frame1, CGRect frame2, CGFloat laxity)
{
    if (CGRectEqualToRect(frame1, frame2)) return YES;
    CGRect intersection = CGRectIntersection(frame1, frame2);
    CGFloat testArea = intersection.size.width * intersection.size.height;
    CGFloat area1 = frame1.size.width * frame1.size.height;
    CGFloat area2 = frame2.size.width * frame2.size.height;
    return ((fabs(testArea - area1) < laxity) && (fabs(testArea - area2) < laxity));
}

@interface WatcherBehavior ()
@property (nonatomic) UIView *view;
@property (nonatomic) CGRect mostRecentFrame;
@property (nonatomic) NSInteger count;
@property (nonatomic) UIDynamicBehavior *customBehavior;
#ifdef SHOW_LOGS
@property (nonatomic) UIDynamicItemBehavior *dynamicItemBehavior;
#endif
@end

@implementation WatcherBehavior
- (instancetype) initWithView: (UIView *) view behavior:(UIDynamicBehavior *)behavior
{
    if (!(self = [super init])) return self;

    _view = view;
    _mostRecentFrame = _view.frame;
    _count = 0;
    _customBehavior = behavior;
    _pointLaxity = 10;
    
#ifdef SHOW_LOGS
    _dynamicItemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[view]];
    [self addChildBehavior:_dynamicItemBehavior];
#endif
    
    __weak typeof(self) weakSelf = self;
    self.action = ^{
        __strong typeof(self) strongSelf = weakSelf;
        UIView *view = strongSelf.view;
        
        CGRect currentFrame = view.frame;
        CGRect recentFrame = strongSelf.mostRecentFrame;
        BOOL steadyFrame = CompareFrames(currentFrame, recentFrame, strongSelf.pointLaxity);
        if (steadyFrame) strongSelf.count++;

        NSInteger kThreshold = 5;
        if (steadyFrame && (strongSelf.count > kThreshold))
        {
            [strongSelf.dynamicAnimator removeBehavior:strongSelf.customBehavior];
            [strongSelf.dynamicAnimator removeBehavior:strongSelf];
            return;
        }
        
        if (!steadyFrame)
        {
            strongSelf.mostRecentFrame = currentFrame;
            strongSelf.count = 0;
        }

#ifdef SHOW_LOGS
        UIDynamicItemBehavior *behavior = strongSelf.dynamicItemBehavior;
        CGFloat angularVelocity = [behavior angularVelocityForItem:view];
        CGPoint linearVelocity = [behavior linearVelocityForItem:view];
        NSLog(@"[%0.2f] %@ Linear Velocity: %@ Angular Velocity: %f", strongSelf.dynamicAnimator.elapsedTime, VALUE(currentFrame), VALUE(linearVelocity), angularVelocity);
#endif
    };

    return self;
}
@end
