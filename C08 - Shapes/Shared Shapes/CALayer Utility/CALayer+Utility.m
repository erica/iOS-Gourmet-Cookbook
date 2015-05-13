/*
 
 Erica Sadun, http://ericasadun.com
 
 */

#import "CALayer+Utility.h"

@implementation CALayer (LayerOrdering)
- (void)bringSublayerToFront:(CALayer *)layer
{
    [layer removeFromSuperlayer];
    [self insertSublayer:layer atIndex:(unsigned int)[self.sublayers count]-1];
}

- (void)sendSublayerToBack:(CALayer *)layer
{
    [layer removeFromSuperlayer];
    [self insertSublayer:layer atIndex:0];
}
@end

