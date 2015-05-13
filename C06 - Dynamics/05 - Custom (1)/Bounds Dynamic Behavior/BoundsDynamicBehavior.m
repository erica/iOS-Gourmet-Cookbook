/*
 
 Erica Sadun, http://ericasadun.com
 
 Heavily based on Apple's Sample Code

 */

#import "BoundsDynamicBehavior.h"

@interface BoundsDynamicItem ()
@property (nonatomic) id <ResizableDynamicItem> item;
@end

@implementation BoundsDynamicItem
- (instancetype)initWithItem:(id<ResizableDynamicItem>)item
{
    if (!(self = [super init])) return self;
    _item = item;
    return self;
}

// Map bounds to center
- (CGPoint)center
{
    return CGPointMake(_item.bounds.size.width, _item.bounds.size.height);
}

// Map center to bounds
- (void)setCenter:(CGPoint)center
{
    _item.bounds = CGRectMake(0, 0, center.x, center.y);
}

// For setting up with attachment behavior
- (CGPoint) anchorPoint
{
    return CGPointMake(CGRectGetMidX(_item.bounds), CGRectGetMidY(_item.bounds));
}
 
#pragma mark - Pass through properties
- (CGRect)bounds {return _item.bounds;}
- (CGAffineTransform)transform {return _item.transform;}
- (void)setTransform:(CGAffineTransform)transform {_item.transform = transform;}
@end

@implementation ResizableDynamicBehavior
- (instancetype) initWithView: (UIView *) view
{
    if (!view) return nil;    
    if (!(self = [super init])) return  self;

    // Create bounds mapper
    BoundsDynamicItem *item = [[BoundsDynamicItem alloc] initWithItem:(id <ResizableDynamicItem>)view];
    
    // Build attachment behavior
    UIAttachmentBehavior *attachmentBehavior = [[UIAttachmentBehavior alloc] initWithItem:item attachedToAnchor:item.anchorPoint];
    attachmentBehavior.frequency = 2.0f;
    attachmentBehavior.damping = 0.3f;
    [self addChildBehavior:attachmentBehavior];
    
    // Build push
    UIPushBehavior *pushBehavior = [[UIPushBehavior alloc] initWithItems:@[item] mode:UIPushBehaviorModeInstantaneous];
    pushBehavior.angle = M_PI_4;
    pushBehavior.magnitude = 2.0;
    [self addChildBehavior:pushBehavior];
    [pushBehavior setActive:TRUE];
    
    return self;
}
@end