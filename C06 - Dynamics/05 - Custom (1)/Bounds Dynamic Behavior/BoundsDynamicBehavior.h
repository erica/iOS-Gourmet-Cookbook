/*
 
 Erica Sadun, http://ericasadun.com
 
 Heavily based on Apple's Sample Code
 
 */

#import <Foundation/Foundation.h>

@protocol ResizableDynamicItem <UIDynamicItem>
@property (nonatomic, readwrite) CGRect bounds;
@end

@interface BoundsDynamicItem : NSObject <UIDynamicItem>
- (instancetype)initWithItem:(id<ResizableDynamicItem>)item;
@property (nonatomic, readonly) CGPoint anchorPoint;
@end

@interface ResizableDynamicBehavior : UIDynamicBehavior
- (instancetype) initWithView: (UIView *) view;
@end