/*
 
 Erica Sadun, http://ericasadun.com
 
 */

#import <UIKit/UIKit.h>

@interface WatcherBehavior : UIDynamicBehavior
- (instancetype) initWithView: (UIView *) view behavior: (UIDynamicBehavior *) behavior;
@property (nonatomic) CGFloat pointLaxity;
@end
