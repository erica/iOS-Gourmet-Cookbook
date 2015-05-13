/*
 
 Erica Sadun, http://ericasadun.com
 
 SHARED UTILITY
 
 */

#if __has_include("ConstraintPack.h")
#import "ConstraintPack.h"
#endif

#if __has_include("HandyPack.h")
#import "HandyPack.h"
#endif

#if __has_include("Utility.h")
#import "Utility.h"
#endif


/*
 
 BLOCKS
 
 */

#define ESTABLISH_WEAK_SELF __weak typeof(self) weakSelf = self
#define ESTABLISH_STRONG_SELF __strong typeof(self) strongSelf = weakSelf

/*
 
 ASSOCIATIONS
 
 */

#ifndef AssociatedObjectPack
#define SynthesizeGetter(_name_) - (id) _name_ {return objc_getAssociatedObject(self, @selector(_name_));}
#define SynthesizeSetter(_name_, _setter_, _type_) - (void) _setter_ (_type_) _name_ {objc_setAssociatedObject(self, @selector(_name_), _name_, OBJC_ASSOCIATION_RETAIN_NONATOMIC);}
#define SynthesizeAssociatedObject(_name_, _setterName_, _type_) SynthesizeGetter(_name_); SynthesizeSetter(_name_, _setterName_, _type_);
#define AssociatedObjectPack
#endif

/*
 
 VALUE
 
 */

#define VALUE(struct) ({ __typeof__(struct) __struct = struct; [NSValue valueWithBytes:&__struct objCType:@encode(__typeof__(__struct))]; })


// Checks
#define CHECK_FLAG(_source_, _flag_) ((_source_ & _flag_) != 0)
#define BOOL_CHECK(TITLE, CHECK_ITEM) printf("%s: %s\n", TITLE, (CHECK_ITEM) ? "Yes" : "No")


/*
 
 BAR BUTTONS
 
 */

#define BARBUTTON(TITLE, SELECTOR) [[UIBarButtonItem alloc] initWithTitle:TITLE style:UIBarButtonItemStylePlain target:self action:SELECTOR]
#define SYSBARBUTTON(ITEM, SELECTOR) [[UIBarButtonItem alloc] initWithBarButtonSystemItem:ITEM target:self action:SELECTOR]
#define IMGBARBUTTON(IMAGE, SELECTOR) [[UIBarButtonItem alloc] initWithImage:IMAGE style:UIBarButtonItemStylePlain target:self action:SELECTOR]
#define CUSTOMBARBUTTON(VIEW) [[UIBarButtonItem alloc] initWithCustomView:VIEW]

#define SYSBARBUTTON_TARGET(ITEM, TARGET, SELECTOR) [[UIBarButtonItem alloc] initWithBarButtonSystemItem:ITEM target:TARGET action:SELECTOR]
#define BARBUTTON_TARGET(TITLE, TARGET, SELECTOR) [[UIBarButtonItem alloc] initWithTitle:TITLE style:UIBarButtonItemStylePlain target:TARGET action:SELECTOR]

/*
 
 TINT COLOR
 
 */

#ifndef APP_TINT_COLOR
#define APP_TINT_COLOR  (^UIColor *(){UIColor *c = [[[[UIApplication sharedApplication] delegate] window] tintColor]; if (c) return c; c = [[UINavigationBar alloc] init].tintColor; if (c) return c; return [UIColor colorWithRed:0.0 green:(122.0 / 255.0) blue:1.0 alpha:1.0];}())
#endif

/*
 
 PLATFORM CHECK
 
 */

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

/*
 
 ORIENTATION
 
 */

#define IS_PORTRAIT UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation) || UIDeviceOrientationIsPortrait(self.interfaceOrientation)

/*
 
 VERSION
 
 */

#define TestForIOS8 if (NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_7_1) NSLog(@"This sample is meant for iOS 8 or later");

