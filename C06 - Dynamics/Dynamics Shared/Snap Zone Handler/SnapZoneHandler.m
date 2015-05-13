/*
 
 Erica Sadun, http://ericasadun.com
 
 */

#import "SnapZoneHandler.h"
#import "Essentials.h"
#import "UIView+Dragging.h"

#define CAPTURED 100

@interface SnapZoneHandler () <UIDynamicAnimatorDelegate>
@property (nonatomic) UIDynamicAnimator *animator;
@end

@implementation SnapZoneHandler
{
    UIGestureRecognizer *suspendedRecognizer;
}


- (void) dynamicAnimatorDidPause:(UIDynamicAnimator *)anAnimator
{
    NSArray *behaviors = _animator.behaviors.copy;
    for (UIDynamicBehavior *behavior in behaviors)
    {
        if ([behavior isKindOfClass:[UISnapBehavior class]])
            [_animator removeBehavior:behavior];
    }
    
    suspendedRecognizer.enabled = YES;
    suspendedRecognizer = nil;
}

- (void) draggableViewDidMove: (NSNotification *) note
{
    // Check for view participation
    UIView *draggedView = note.object;
    UIView *nca = [draggedView nearestCommonAncestorWithView:_animator.referenceView];
    if (!nca) return;
    
    // Retrieve state
    UIGestureRecognizer *recognizer = (UIGestureRecognizer *) draggedView.gestureRecognizers.lastObject;
    UIGestureRecognizerState state = [recognizer state];
    
    // View frame and current attachment
    CGRect draggedFrame = draggedView.frame;
    BOOL free = draggedView.tag == 0;
    
    for (UIView *dropZone in _dropZones)
    {
        // Make sure all drop zones are views
        if (![dropZone isKindOfClass:[UIView class]])
            continue;
        
        // Overlap?
        CGRect dropFrame = dropZone.frame;
        BOOL overlap = CGRectIntersectsRect(draggedFrame, dropFrame);
        
        // Free moving
        if (!overlap && free)
        {
            continue;
        }
        
        // Newly captured
        if (overlap && free)
        {
            if (suspendedRecognizer)
            {
                NSLog(@"Error: attempting to suspend second recognizer");
                break;
            }
            
            // New parent
            suspendedRecognizer = recognizer;
            suspendedRecognizer.enabled = NO; // stop!
            draggedView.tag = CAPTURED + dropZone.tag;
            UISnapBehavior *behavior = [[UISnapBehavior alloc] initWithItem:draggedView snapToPoint:RectGetCenter(dropFrame)];
            [_animator addBehavior:behavior];
            break;
        }
        
        // Is this the current parent drop zone?
        BOOL isParent = (dropZone.tag + CAPTURED == draggedView.tag);
        
        // Current parent
        if (overlap && isParent)
        {
            switch (state)
            {
                case UIGestureRecognizerStateEnded:
                {
                    // Recapture
                    UISnapBehavior *behavior = [[UISnapBehavior alloc] initWithItem:draggedView snapToPoint:RectGetCenter(dropFrame)];
                    [_animator addBehavior:behavior];
                    break;
                }
                default:
                {
                    // Still captured but no op
                    break;
                }
            }
            break;
        }
        
        // New parent
        if (overlap)
        {
            suspendedRecognizer = recognizer;
            suspendedRecognizer.enabled = NO; // stop!
            draggedView.tag = CAPTURED + dropZone.tag;
            UISnapBehavior *behavior = [[UISnapBehavior alloc] initWithItem:draggedView snapToPoint:RectGetCenter(dropFrame)];
            [_animator addBehavior:behavior];
            break;
        }
    }
}

- (instancetype) init
{
    if (!(self = [super init])) return self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(draggableViewDidMove:) name:DraggableViewDidMove object:nil];
    
    return self;
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_animator removeAllBehaviors];
    _animator.delegate = nil;
}

+ (instancetype) handlerWithReferenceView: (UIView *) referenceView
{
    UIDynamicAnimator *animator = [[UIDynamicAnimator alloc] initWithReferenceView:referenceView];
    SnapZoneHandler *handler = [[self alloc] init];
    handler.animator = animator;
    animator.delegate = handler;
    return handler;
}
@end

