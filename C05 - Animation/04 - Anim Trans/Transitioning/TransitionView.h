/*
 
 Erica Sadun, http://ericasadun.com
 
 */

@import UIKit;

typedef enum
{
    kCICustomTransitionCopyMachine,
    kCICustomTransitionSwipeBars,
    kCICustomTransitionFlash,
    kCICustomTransitionMod,
} CustomCITransitionType;

typedef void(^TransitionCompletionBlock)();

@interface TransitionView : UIView
@property (nonatomic, strong) UIImage *image1;
@property (nonatomic, strong) UIImage *image2;
@property (nonatomic) CGFloat duration;
@property (nonatomic) BOOL reversed;
- (void) transition: (CustomCITransitionType) theType completion:(TransitionCompletionBlock)completion;
@end