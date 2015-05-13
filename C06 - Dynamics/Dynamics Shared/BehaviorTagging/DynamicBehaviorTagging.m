/*
 
 Erica Sadun, http://ericasadun.com
 
 */

#import "DynamicBehaviorTagging.h"

@import ObjectiveC;

#ifndef ASSOC_OBJ_PACK
#define ASSOC_OBJECT_GETTER(_name_) - (id) _name_ {return objc_getAssociatedObject(self, @selector(_name_));}
#define ASSOC_OBJECT_SETTER_(_name_, _setter_, _type_) - (void) _setter_ (_type_) _name_ {objc_setAssociatedObject(self, @selector(_name_), _name_, OBJC_ASSOCIATION_RETAIN_NONATOMIC);}
#define BUILD_ASSOC_OBJ(_name_, _setterName_, _type_) ASSOC_OBJECT_GETTER(_name_); ASSOC_OBJECT_SETTER_(_name_, _setterName_, _type_);
#define ASSOC_OBJ_PACK
#endif


@implementation UIDynamicBehavior (Tagging)
BUILD_ASSOC_OBJ(nametag, setNametag:, NSString *);
@end

@implementation UIDynamicAnimator (Tagging)
- (UIDynamicBehavior *) behaviorNamed:(NSString *)nametag
{
    for (UIDynamicBehavior *behavior in self.behaviors)
    {
        if ([behavior.nametag isEqual:nametag])
            return behavior;
    }
    return nil;
}
@end