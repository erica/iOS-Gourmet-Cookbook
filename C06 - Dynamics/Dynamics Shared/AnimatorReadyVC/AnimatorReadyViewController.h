/*
 
 Erica Sadun, http://ericasadun.com
 
 */

#import <UIKit/UIKit.h>

@interface AnimatorReadyViewController : UIViewController <UIDynamicAnimatorDelegate>

@property (nonatomic, readonly) NSMutableArray *observers;

@property (nonatomic, readonly) UIDynamicAnimator *animator;
@property (nonatomic, readonly) UICollisionBehavior *boundaryBehavior;
@property (nonatomic, readonly) UIGravityBehavior *deviceGravityBehavior;

// Start device gravity updates
- (void) enableGravity: (BOOL) enable;

// Limit view to vc boundaries
- (void) setBoundariesForViews: (NSArray *) views;

// Stop view in its tracks
- (void) haltViews: (NSArray *) views;
@end

