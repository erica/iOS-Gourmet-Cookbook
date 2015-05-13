/*
 
 Erica Sadun, http://ericasadun.com
 Inspired by http://victorbaro.com/2014/07/vbfjellyview-tutorial/

 */

#import "JellyView.h"
#import "ConstraintPack.h"

@interface JellyView()
@property (nonatomic) UIDynamicAnimator *animator;
@end

@implementation JellyView

+ (instancetype) view : (CGSize) size
{
    JellyView *view = [[self alloc] initWithFrame:(CGRect){.size = size}];
    return view;
}

#pragma mark - Instance

- (void) setup
{
    // Set up the subviews
    for (int i = 0; i < 9; i++)
    {
        NSString *hposition = @[@"l", @"c", @"r", @"l", @"c", @"r", @"l", @"c", @"r"][i];
        NSString *vposition = @[@"t", @"t", @"t", @"c", @"c", @"c", @"b", @"b", @"b"][i];
        NSDictionary *v = @{@"t":@(0),
                            @"c":@((self.bounds.size.height / 2.0) - 2.5),
                            @"b":@(self.bounds.size.height - 5.0)};
        NSDictionary *h = @{@"l":@(0),
                            @"c":@((self.bounds.size.width / 2.0) - 2.5),
                            @"r":@(self.bounds.size.width - 5.0)};
        CGRect frame = CGRectMake([h[hposition] floatValue], [v[vposition] floatValue], 5, 5);

        UIView *view = [[UIView alloc] initWithFrame:frame];
        view.backgroundColor = [UIColor clearColor];
//        view.backgroundColor = [UIColor blackColor];
        view.tag = i + 1; // tags go 1..9
        [self addSubview:view];
    }
    
    // Observe top-left corner view
    UIView *v0 = [self viewWithTag:1];
    [v0 addObserver:self forKeyPath:@"center" options:NSKeyValueObservingOptionNew context:NULL];
}

- (instancetype) initWithFrame:(CGRect)frame
{
    if (!(self = [super initWithFrame:frame])) return self;
    [self setup];
    self.clipsToBounds = NO;
    self.backgroundColor = [UIColor clearColor];
    _damping = 0.4;
    _frequency = 15;
    _elasticity = 1.5;
    _density = 2;
    return self;
}

- (void) dealloc
{
    // Clean up observer
    UIView *v0 = [self viewWithTag:1];
    [v0 removeObserver:self forKeyPath:@"center"];
}

#pragma mark - Dynamics

- (void) establishDynamics : (UIDynamicAnimator *) animator
{
    if (!animator && !_animator)
    {
        NSLog(@"Error: Unable to establish dynamics. No animator");
        return;
    }
    if (animator) _animator = animator;
    
    // Create baseline dynamics for view
    UIDynamicItemBehavior *dynamic = [[UIDynamicItemBehavior alloc] initWithItems:@[self]];
    dynamic.allowsRotation = NO;
    dynamic.elasticity = _elasticity / 2;
    dynamic.density = _density;
    dynamic.resistance = 0.9;
    [_animator addBehavior:dynamic];
    
    // Establish jelly grid
    for (int i = 0; i < 9; i++)
    {
        // Add dynamics
        UIView *view = [self viewWithTag:(i + 1)];
        UIDynamicItemBehavior *behavior = [[UIDynamicItemBehavior alloc] initWithItems:@[view]];
        behavior.elasticity = _elasticity * 2;
        behavior.density = _density;
        behavior.resistance = 0.2;
        [_animator addBehavior:behavior];
        
        // Attach view to center
        UIAttachmentBehavior *attachment = [[UIAttachmentBehavior alloc] initWithItem:view attachedToItem:self];
        attachment.damping = _damping;
        attachment.frequency = _frequency;
        [_animator addBehavior:attachment];
        
        // Attach views to each other
        if ((i + 1) != 5) // skip center
        {
            NSInteger xTag = [@[@(1), @(2), @(5), @(0), @(4), @(8), @(3), @(6), @(7)][i] integerValue] + 1;
            UIView *nextView = [self viewWithTag:xTag];
            attachment = [[UIAttachmentBehavior alloc] initWithItem:view attachedToItem:nextView];
            attachment.damping = _damping;
            attachment.frequency = _frequency;
            [_animator addBehavior:attachment];
        }
    }
}

#pragma mark - Drawing

- (void) observeValueForKeyPath:(NSString *)keyPath
                       ofObject:(id)object
                         change:(NSDictionary *)change
                        context:(void *)context
{
    [self setNeedsDisplay];
}

- (UIBezierPath *) cornerCurve
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    UIView *v0 = [self viewWithTag:1];
    [path moveToPoint:v0.center];
    
    NSArray *destinations = @[@(2), @(8), @(6), @(0)];
    NSArray *controlPoints = @[@(1), @(5), @(7), @(3)];
    
    for (int i = 0; i < 4; i++)
    {
        NSInteger dTag = [destinations[i] integerValue] + 1;
        NSInteger cTag = [controlPoints[i] integerValue] + 1;
        UIView *vd = [self viewWithTag:dTag];
        UIView *vc = [self viewWithTag:cTag];
        [path addQuadCurveToPoint:vd.center controlPoint:vc.center];
    }
    return path;
}


- (void) drawRect:(CGRect)rect
{
    [_color set];
    [[self cornerCurve] fill];
}
@end

