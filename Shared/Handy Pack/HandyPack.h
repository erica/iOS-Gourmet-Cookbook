/*
 
 Erica Sadun, http://ericasadun.com
 HANDY PACK
 
 Useful items for testing and development
 
 */

@import Foundation;
// #import <TargetConditionals.h>
#if TARGET_OS_IPHONE
@import UIKit;
#endif

#if TARGET_OS_IPHONE
#define View UIView
#define Color UIColor
#define Image UIImage
#define Font UIFont
#elif TARGET_OS_MAC
#define View NSView
#define Color NSColor
#define Image NSImage
#define Font NSFont
#endif


// Log without date
void Log(NSString *formatString,...);
NSString *String(NSString *formatString, ...);

// Paths
NSString *LibPath(NSString *fileName);
NSString *DocsPath(NSString *fileName);
NSString *TmpPath(NSString *fileName);
NSString *BundlePath(NSString *fileName);

// User Defaults
NSObject *GetDefault(NSString *key);
void SetDefault(NSString *key, NSObject *value);

// Random
NSUInteger RandomInteger(NSUInteger max);
CGFloat Random01();
BOOL RandomBool();
CGPoint RandomPointInRect(CGRect rect);
id RandomItemInArray(NSArray *array);
Color *Random_Color();

// Reading
NSString *StringFromPath(NSString *path);
NSData *DataFromPath(NSString *path);

// String
BOOL StringEqual(NSString *s1, NSString *s2);
BOOL HasPrefix(NSString *s1, NSString *prefix);
BOOL HasSuffix(NSString *s1, NSString *suffix);
@interface NSString (GeneralUtility)
@property (nonatomic, readonly) NSData *dataRepresentation;
+ (instancetype) stringWithData: (NSData *) data;
@end

// View
#if TARGET_OS_IPHONE
@interface UIView (GeneralUtility)
@property (nonatomic, readonly) NSArray *realSubviews;
@end
#endif

// Paths
NSString *Desktop();
NSURL    *DesktopURL();

// Data
void SaveDebugData(NSData *data, NSString *name);

// Images -- iOS Only. Mac please use Mac Image Pack
#if TARGET_OS_IPHONE
void SaveDebugImage(UIImage *image, NSString *name);
void WriteImage(UIImage *image, NSString *path);
#endif

// Stylize View
void RoundAndEdgeView(View *view);

// Lorem image
Image *LoremPixel(CGSize size, NSString *category, BOOL gray);
NSArray *LoremPixelCategories();

// Lorem words
NSString *Lorem(NSUInteger numberOfParagraphs);
NSString *Ipsum(NSUInteger numberOfParagraphs);
NSString *AnyIpsum(NSUInteger numberOfParagraphs, NSString *topic);

// Test views
#if TARGET_OS_IPHONE
@interface TestViewMaker : NSObject
- (UIView *) buildViewWithController: (UIViewController *) controller h: (CGFloat) h v : (CGFloat) v colorString : (NSString *) colorString alpha: (CGFloat) alpha stylize: (BOOL) stylize;
@end

UIView *BuildView(UIViewController *controller, CGFloat h, CGFloat v, NSString *colorString, CGFloat alpha, BOOL stylize);
#endif

// Notification Observers
#if TARGET_OS_IPHONE
@interface UIViewController (NotificationObservers)
@property (nonatomic, readonly) NSMutableArray *observers;
- (void) addNotificationObserver: (NSObject *) observer;
- (void) observeNotification: (NSString *) notificationName block:(void (^)(NSNotification *)) block;
- (void) removeAllNotificationObservers;
@end
#endif

// Cleanup
#undef View
#undef Color
#undef Image
#undef Font