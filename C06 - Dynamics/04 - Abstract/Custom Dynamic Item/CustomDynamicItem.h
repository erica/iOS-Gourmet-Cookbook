/*
 
 Erica Sadun, http://ericasadun.com
 
 */

#import <Foundation/Foundation.h>

@interface CustomDynamicItem : NSObject <UIDynamicItem>
@property (nonatomic) CGRect bounds;
@property (nonatomic) CGPoint center;
@property (nonatomic) CGAffineTransform transform;
@end
