/*
 
 Erica Sadun, http://ericasadun.com
 
 */

#import "MotionEffects.h"

@implementation CenterMotionEffect
+ (instancetype) effectWithMagnitude: (CGFloat) magnitude
{
    UIInterpolatingMotionEffect *hEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    hEffect.minimumRelativeValue = @(-1 * fabs(magnitude));
    hEffect.maximumRelativeValue = @(fabs(magnitude));
    
    UIInterpolatingMotionEffect *vEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    vEffect.minimumRelativeValue = @(-1 * fabs(magnitude));
    vEffect.maximumRelativeValue = @(fabs(magnitude));
    
    CenterMotionEffect *group =  [[self alloc] init];
    group.motionEffects = @[hEffect, vEffect];
    return group;
}
@end

@implementation ShadowMotionEffect
+ (instancetype) effectWithMagnitude: (CGFloat) magnitude
{
    UIInterpolatingMotionEffect *hEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"layer.shadowOffset.width" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    hEffect.minimumRelativeValue = @(-1 * fabs(magnitude));
    hEffect.maximumRelativeValue = @(fabs(magnitude));
    
    UIInterpolatingMotionEffect *vEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"layer.shadowOffset.height" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    vEffect.minimumRelativeValue = @(-1 * fabs(magnitude));
    vEffect.maximumRelativeValue = @(fabs(magnitude));
    
    ShadowMotionEffect *group =  [[self alloc] init];
    group.motionEffects = @[hEffect, vEffect];
    return group;
}
@end



