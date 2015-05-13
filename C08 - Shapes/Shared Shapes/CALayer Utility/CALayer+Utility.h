/*
 
 Erica Sadun, http://ericasadun.com
 
 */

#import <Foundation/Foundation.h>

@interface CALayer (LayerOrdering)
- (void)bringSublayerToFront:(CALayer *)layer;
- (void)sendSublayerToBack:(CALayer *)layer;
@end

