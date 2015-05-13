/*
 
 Erica Sadun, http://ericasadun.com
 
 */

#import "BoundsDynamicBehavior.h"
#import "Essentials.h"

@interface ResizableDynamicBehavior ()
@property (nonatomic, strong) UIView *view;
@property (nonatomic) NSDate *startingTime;
@property (nonatomic) CGRect frame;
@property (nonatomic) UIGravityBehavior *clockMandate;
@property (nonatomic) UIView *fakeView;
@end

@implementation ResizableDynamicBehavior
- (instancetype) initWithView: (UIView *) view
{
    if (!view) return nil;
    if (!(self = [super init])) return  self;
    _view = view;
    _frame = view.frame;
    
    _fakeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [view addSubview:_fakeView];
    _clockMandate = [[UIGravityBehavior alloc] initWithItems:@[_fakeView]];
    [self addChildBehavior:_clockMandate];

    __weak typeof(self) weakSelf = self;
    self.action = ^{
        __strong typeof(self) strongSelf = weakSelf;
        if (!strongSelf.startingTime) strongSelf.startingTime = [NSDate date];
        CGFloat time = [[NSDate date] timeIntervalSinceDate:strongSelf.startingTime];
        CGFloat scale =  1 + 0.5 * sin(time * M_PI * 2) * exp(-1.0 * time * 2.0f);
        CGAffineTransform transform = CGAffineTransformMakeScale(scale, scale);
        strongSelf.view.bounds = (CGRect){.size = strongSelf.frame.size};
        strongSelf.view.transform = transform;
        [strongSelf.dynamicAnimator updateItemUsingCurrentState:strongSelf.view];
        
        if (time > 1.5)
        {
            [strongSelf removeChildBehavior:strongSelf.clockMandate];
            strongSelf.view.transform = CGAffineTransformIdentity;
            [strongSelf.fakeView removeFromSuperview];
        }
    };
    
    return self;
}
@end