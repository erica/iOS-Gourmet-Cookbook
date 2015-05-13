/*
 
 Erica Sadun, http://ericasadun.com
 
 */

#import "DynamicUtilities.h"
#import "TransformBehavior.h"

NSString *const AnimationsDidPause = @"AnimationsDidPause";

UIView *_DUNearestCommonViewAncestor(UIView *view1, UIView *view2)
{
    if (!view1 || !view2) return nil;
    
    if ([view1 isEqual:view2]) return view1;
    
    // Collect superviews
    UIView *view;
    NSMutableArray *array1 = [NSMutableArray arrayWithObject:view1];
    view = view1.superview;
    while (view != nil)
    {
        [array1 addObject:view];
        view = view.superview;
    }
    
    NSMutableArray *array2 = [NSMutableArray arrayWithObject:view2];
    view = view2.superview;
    while (view != nil)
    {
        [array2 addObject:view];
        view = view.superview;
    }
    
    // Check for superview relationships
    if ([array1 containsObject:view2]) return view2;
    if ([array2 containsObject:view1]) return view1;
    
    // Check for indirect ancestor
    for (UIView *view in array1)
        if ([array2 containsObject:view]) return view;
    
    return nil;
}

UIView *CommonReferenceView(NSArray *views)
{
    if (!views) return nil;
    
    UIView *referenceView;
    NSInteger n = views.count;
    if (n == 1)
    {
        referenceView = [views[0] superview];
    }
    else
    {
        referenceView = views[0];
        for (UIView *view in views)
            referenceView = _DUNearestCommonViewAncestor(referenceView, view);
    }
    return referenceView;
}

@class  DynamicUtility;
static DynamicUtility *sharedInstance = nil;

@interface DynamicUtility : NSObject <UIDynamicAnimatorDelegate>
@property (nonatomic) UIDynamicAnimator *animator;
@property (nonatomic) BOOL resetOnPause;
@end

@implementation DynamicUtility
+(DynamicUtility *) sharedInstance
{
    if (!sharedInstance)
    {
		sharedInstance = [[super allocWithZone:NULL] init];
    }
    return sharedInstance;
}

- (id) copyWithZone: (NSZone *) zone
{
    return self;
}

+ (id) allocWithZone: (NSZone *) zone
{
    return [self sharedInstance];
}

- (instancetype) init
{
    if (!(self = [super init])) return self;
    _resetOnPause = YES;
    return self;
}

- (void) dynamicAnimatorDidPause:(UIDynamicAnimator *)animator
{
    if (_resetOnPause)
        [animator removeAllBehaviors];
    [[NSNotificationCenter defaultCenter] postNotificationName:AnimationsDidPause object:animator];
}

- (void) dynamicAnimatorWillResume:(UIDynamicAnimator *)animator
{
    
}
@end

void SnapViewsToPoint(NSArray *views, CGPoint point, BOOL scaleAndRotate)
{
    if (!views.count) return;

    // Retrieve reference view
    UIView *referenceView = CommonReferenceView(views);
    if (!referenceView) return;
    
    // Establish new animator
    DynamicUtility *utility = [DynamicUtility sharedInstance];
    utility.animator = [[UIDynamicAnimator alloc] initWithReferenceView:referenceView];
    utility.animator.delegate = utility;
    
    NSInteger h, v;
    NSInteger i = 0;
    NSInteger n = views.count;
    
    // Add the behaviors
    for (UIView *view in views)
    {
        // Store previous location in tag
        h = view.center.x;
        v = view.center.y;
        view.tag = h * kMultiplier + v;
        
        // Calculate target location
        CGFloat theta = M_PI * 2 * (CGFloat) i / (CGFloat) n;
        h = point.x + 10.0f * sin(theta);
        v = point.y + 10.0f * cos(theta);
        
        // Create and install behaviors
        UISnapBehavior *snapBehavior = [[UISnapBehavior alloc] initWithItem:view snapToPoint:CGPointMake(h, v)];
        [utility.animator addBehavior:snapBehavior];
        
        if (scaleAndRotate)
        {
            TransformBehavior *transformBehavior = [[TransformBehavior alloc] initWithItem:view transform:CGAffineTransformRotate(CGAffineTransformMakeScale(kViewShrinkageToApply, kViewShrinkageToApply), theta)];
            [utility.animator addBehavior:transformBehavior];
        }
        
        i++;
    }
}

void SnapViewsToStoredPositions(NSArray *views)
{
    if (!views.count) return;
    
    // Retrieve reference view
    UIView *referenceView = CommonReferenceView(views);
    if (!referenceView) return;
    
    
    DynamicUtility *utility = [DynamicUtility sharedInstance];
    utility.animator = [[UIDynamicAnimator alloc] initWithReferenceView:referenceView];
    utility.animator.delegate = utility;
    
    NSInteger h, v;
    NSInteger i = 0;
    
    // Add the behaviors
    for (UIView *view in views)
    {
        // Restore previous location from tag
        h = view.tag / kMultiplier;
        v = view.tag % kMultiplier;
        
        // Create and install behaviors
        UISnapBehavior *snapBehavior = [[UISnapBehavior alloc] initWithItem:view snapToPoint:CGPointMake(h, v)];
        [utility.animator addBehavior:snapBehavior];
        TransformBehavior *transformBehavior = [[TransformBehavior alloc] initWithItem:view transform:CGAffineTransformIdentity];
        // transformBehavior.acceleration = 0.0005f;
        [utility.animator addBehavior:transformBehavior];

        i++;
    }
}