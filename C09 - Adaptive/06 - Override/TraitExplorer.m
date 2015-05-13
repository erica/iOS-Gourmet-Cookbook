/*
 
 Erica Sadun, http://ericasadun.com
 
 */

#import "TraitExplorer.h"

@implementation TraitExplorer
+ (NSString *) stringForSizeClass: (UIUserInterfaceSizeClass) sizeClass
{
    switch (sizeClass) {
        case UIUserInterfaceSizeClassCompact:
            return @"Compact";
        case UIUserInterfaceSizeClassRegular:
            return @"Regular";
        case UIUserInterfaceSizeClassUnspecified:
            return @"Unspecified";
    }
}

+ (NSString *) stringForDisplayScale :(CGFloat) displayScale
{
    if (displayScale == 1.0) return @"1x";
    if (displayScale == 2.0) return @"2x";
    if (displayScale == 0.0) return @"Unspecified";
    return @"Unknown";
}

+ (NSString *) stringForIdiom : (UIUserInterfaceIdiom) idiom
{
    switch (idiom) {
        case UIUserInterfaceIdiomPad:
            return @"Tablet";
        case UIUserInterfaceIdiomPhone:
            return @"Phone";
        case UIUserInterfaceIdiomUnspecified:
            return @"Unspecified";
    }
}

+ (void) printTraits:(UITraitCollection *)collection
{
    printf("Trait collection:\n");
    printf("  User Interface Idiom: %s\n", [self stringForIdiom:collection.userInterfaceIdiom].UTF8String);
    printf("  Display Scale: %s\n", [self stringForDisplayScale:collection.displayScale].UTF8String);
    printf("  Size class: [H:%s, V:%s]\n", [self stringForSizeClass:collection.horizontalSizeClass].UTF8String, [self stringForSizeClass:collection.verticalSizeClass].UTF8String);
    printf("\n");
}

+ (void) explore: (id <UITraitEnvironment>) object
{
    [self printTraits:object.traitCollection];
}

+ (void) showCoordinateSpaces
{
    printf("Fixed coordinate space bounds: %s\n", NSStringFromCGRect([UIScreen mainScreen].fixedCoordinateSpace.bounds).UTF8String);
    printf("Coordinate space bounds: %s\n", NSStringFromCGRect([UIScreen mainScreen].coordinateSpace.bounds).UTF8String);
    printf("\n");
    printf("Application frame: %s\n", NSStringFromCGRect([UIScreen mainScreen].applicationFrame).UTF8String);
    printf("Screen bounds: %s\n", NSStringFromCGRect([UIScreen mainScreen].bounds).UTF8String);
    printf("Native bounds: %s\n", NSStringFromCGRect([UIScreen mainScreen].nativeBounds).UTF8String);
    printf("\n");
    printf("Scale: %0.1f\n", [UIScreen mainScreen].scale);
    printf("Native scale: %0.1f\n", [UIScreen mainScreen].nativeScale);
    printf("\n");
}
@end
