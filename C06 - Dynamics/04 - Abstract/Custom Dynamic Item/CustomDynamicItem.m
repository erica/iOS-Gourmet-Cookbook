/*
 
 Erica Sadun, http://ericasadun.com
 
 */

#import "CustomDynamicItem.h"
#import "Utility.h"

@implementation CustomDynamicItem
- (NSString *) description
{
    NSString *boundsString = [NSString stringWithFormat:@"[%0.0f, %0.0f, %0.0f, %0.0f]", _bounds.origin.x, _bounds.origin.y, _bounds.size.width, _bounds.size.height];
    NSString *centerString = [NSString stringWithFormat:@"(%0.0f %0.0f)", _center.x, _center.y];
    NSString *transformString = TransformStringRepresentation(_transform);
    return [NSString stringWithFormat:@"Bounds: %@, Center: %@, Transform: %@", boundsString, centerString, transformString];
}

- (void) setCenter:(CGPoint)center
{
    _center = center;
    _bounds = RectAroundCenter(_center, _bounds.size);
}

- (void) setBounds:(CGRect)bounds
{
    _bounds = bounds;
    _center = RectGetCenter(bounds);
}
@end
