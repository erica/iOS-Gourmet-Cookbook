/*
 
 Erica Sadun, http://ericasadun.com
 
 */

#import <Foundation/Foundation.h>

typedef enum
{
    kCustomFadeTransition,
    kCustomCubeForwardTransition,
    kCustomCubeBackTransition,
    kCustomCopyMachineForwardTransition,
    kCustomCopyMachineBackTransition,
    kCustomBounceInTransition,
    kCustomBounceOutTransition,
    kCustomFlipInTransition,
    kCustomFlipOutTransition,
} CustomTransitionType;

@interface CustomTransitioning : NSObject <UIViewControllerAnimatedTransitioning>
@property (nonatomic) NSTimeInterval duration;
@property (nonatomic) CustomTransitionType transitionType;
@end
