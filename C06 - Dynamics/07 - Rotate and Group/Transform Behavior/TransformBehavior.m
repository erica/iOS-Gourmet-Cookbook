/*
 
 Erica Sadun, http://ericasadun.com
 
 */

#import "TransformBehavior.h"
#import "Essentials.h"

// typedef void(^ActionBlock)(void);

@interface TransformBehavior ()
@property (nonatomic) id <UIDynamicItem> item;
@property (nonatomic) CGAffineTransform originalTransform;
@property (nonatomic) CGAffineTransform targetTransform;
@property (nonatomic) BOOL inverted;
@property (nonatomic) CGFloat velocity;
@property (nonatomic) CGFloat percent;
@property (nonatomic, readwrite) BOOL stopped;
@end

@implementation TransformBehavior

- (instancetype) initWithItem: (id <UIDynamicItem>) item transform: (CGAffineTransform) transform;
{
    if (!(self = [super init])) return self;
    
    _item = item;
    _originalTransform = item.transform;
    _targetTransform = transform;
    _velocity = 0;
    _acceleration = 0.0025;
    _stopped = NO;
    
    ESTABLISH_WEAK_SELF;
    self.action = ^(){
        ESTABLISH_STRONG_SELF;
        
        CGAffineTransform t1 = strongSelf.originalTransform;
        CGAffineTransform t2 = strongSelf.targetTransform;
        
        // Original
        CGFloat xScale1 = sqrt(t1.a * t1.a + t1.c * t1.c);
        CGFloat yScale1 = sqrt(t1.b * t1.b + t1.d * t1.d);
        CGFloat rotation1 = atan2f(t1.b, t1.a);

        // Target
        CGFloat xScale2 = sqrt(t2.a * t2.a + t2.c * t2.c);
        CGFloat yScale2 = sqrt(t2.b * t2.b + t2.d * t2.d);
        CGFloat rotation2 = atan2f(t2.b, t2.a);
        
        // Progress
        strongSelf.velocity = strongSelf.velocity + strongSelf.acceleration;
        strongSelf.percent = strongSelf.percent + strongSelf.velocity;
        CGFloat percent = MIN(1.0, MAX(strongSelf.percent, 0.0));
        if (percent == 1.0f) strongSelf.stopped = YES;
        percent = EaseOut(percent, 3);

        // Calculated items
        CGFloat targetTx = Tween(t1.tx, t2.tx, percent);
        CGFloat targetTy = Tween(t1.ty, t2.ty, percent);
        CGFloat targetXScale = Tween(xScale1, xScale2, percent);
        CGFloat targetYScale = Tween(yScale1, yScale2, percent);
        CGFloat targetRotation = Tween(rotation1, rotation2, percent);
        
        // Create transforms
        CGAffineTransform scaleTransform = CGAffineTransformMakeScale(targetXScale, targetYScale);
        CGAffineTransform rotateTransform = CGAffineTransformMakeRotation(targetRotation);
        CGAffineTransform translateTransform = CGAffineTransformMakeTranslation(targetTx, targetTy);
        
        // Combine and apply transforms
        CGAffineTransform t = CGAffineTransformIdentity;
        t = CGAffineTransformConcat(t, rotateTransform);
        t = CGAffineTransformConcat(t, scaleTransform);
        t = CGAffineTransformConcat(t, translateTransform);
        strongSelf.item.transform = t;
    };
    
    return self;
}
@end