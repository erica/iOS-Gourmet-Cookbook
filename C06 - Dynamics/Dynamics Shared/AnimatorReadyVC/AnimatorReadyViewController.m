/*
 
 Erica Sadun, http://ericasadun.com
 
 */

#import "AnimatorReadyViewController.h"
#import "DynamicBehaviorTagging.h"
#import "MotionManager.h"

NSString *const HaltNametag = @"HaltNametag";


@implementation AnimatorReadyViewController

- (void) dynamicAnimatorDidPause:(UIDynamicAnimator *)animator
{
    UIDynamicBehavior *behavior = [self.animator behaviorNamed:HaltNametag];
    while (behavior)
    {
        [self.animator removeBehavior:behavior];
        behavior = [self.animator behaviorNamed:HaltNametag];
    }
}

- (void) dynamicAnimatorWillResume:(UIDynamicAnimator *)animator
{
}

// If you set this property to 1.0, a dynamic item’s motion stops as soon as there is no force applied to it.
- (void) haltViews: (NSArray *) views
{
    UIDynamicItemBehavior *behavior = [[UIDynamicItemBehavior alloc] initWithItems: views];
    behavior.nametag = HaltNametag;
    behavior.resistance = 1.0f;
    [self.animator addBehavior:behavior];
}

- (void) addSubviewsToItemBehavior: (UIDynamicItemBehavior *) behavior
{
    for (id <UIDynamicItem> item in behavior.items.copy)
        [_deviceGravityBehavior removeItem:item];
    for (id <UIDynamicItem> item in self.view.subviews)
    {
        if ([item conformsToProtocol:@protocol(UILayoutSupport)]) continue;
        [_deviceGravityBehavior addItem:item];
    }
}

- (void) enableGravity: (BOOL) enable
{
    if (enable)
    {
        [_animator addBehavior:_deviceGravityBehavior];
        [[MotionManager sharedInstance] startMotionUpdates];
    }
    else
    {
        [_animator removeBehavior:_deviceGravityBehavior];
        [[MotionManager sharedInstance] shutDownMotionManager];
        [self haltViews:_deviceGravityBehavior.items.copy];
    }
}

- (void) setBoundariesForViews: (NSArray *) views
{
    for (UIView *view in views)
        [self.boundaryBehavior addItem:view];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_animator removeAllBehaviors];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_animator addBehavior:_boundaryBehavior];
    [self.view layoutIfNeeded];
}

- (void) loadView
{
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _observers = [NSMutableArray array];
    
    _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    _animator.delegate = self;
    
    _boundaryBehavior = [[UICollisionBehavior alloc] initWithItems:@[]];
    _boundaryBehavior.translatesReferenceBoundsIntoBoundary = YES;
        
    _deviceGravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[]];
    __weak typeof(self) weakSelf = self;
    id observer = [[NSNotificationCenter defaultCenter] addObserverForName:MotionManagerUpdate object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        __strong typeof(self) strongSelf = weakSelf;
        NSDictionary *dict = note.userInfo;
        NSValue *value = dict[MotionVectorKey];
        CGVector vector;
        [value getValue:&vector];
        strongSelf.deviceGravityBehavior.gravityDirection = vector;
    }];
    [_observers addObject:observer];
}

- (void) dealloc
{
    for (id observer in _observers)
        [[NSNotificationCenter defaultCenter] removeObserver:observer];
}
@end

