/*
 
 Erica Sadun, http://ericasadun.com
 
 */

#import <UIKit/UIKit.h>

@interface TraitExplorer : NSObject
+ (void) printTraits: (UITraitCollection *) collection;
+ (void) explore: (id <UITraitEnvironment>) object;
+ (void) showCoordinateSpaces;
@end
