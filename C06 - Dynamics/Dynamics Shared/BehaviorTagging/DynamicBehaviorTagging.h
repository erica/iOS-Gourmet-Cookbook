/*
 
 Erica Sadun, http://ericasadun.com
 
 */

#import <Foundation/Foundation.h>

@interface UIDynamicAnimator (Tagging)
- (UIDynamicBehavior *) behaviorNamed: (NSString *) nametag;
@end

@interface UIDynamicBehavior (Tagging)
@property (nonatomic) NSString *nametag;
@end

