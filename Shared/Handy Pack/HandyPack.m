/*
 
 Erica Sadun, http://ericasadun.com
 HANDY PACK
 
 Useful items for testing and development

 */

#import "Essentials.h"
#import "HandyPack.h"
@import ObjectiveC;

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

#pragma mark - Debug Output

// Thanks Landon F.
void Log(NSString *formatString,...)
{
    va_list arglist;
    if (formatString)
    {
        va_start(arglist, formatString);
        NSString *outstring = [[NSString alloc] initWithFormat:formatString arguments:arglist];
        fprintf(stderr, "%s\n", [outstring UTF8String]);
        va_end(arglist);
    }
}

NSString *String(NSString *formatString, ...)
{
    NSString *outstring = nil;
    va_list arglist;
    if (formatString)
    {
        va_start(arglist, formatString);
        outstring = [[NSString alloc] initWithFormat:formatString arguments:arglist];
        va_end(arglist);
    }
    return outstring;
}

#pragma mark - Paths

NSString *LibPath(NSString *fileName)
{
    NSString *basePath = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).firstObject;
    if (!fileName) return basePath;
    return [basePath stringByAppendingPathComponent:fileName];
}

NSString *DocsPath(NSString *fileName)
{
    NSString *basePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    if (!fileName) return basePath;
    return [basePath stringByAppendingPathComponent:fileName];
}

NSString *TmpPath(NSString *fileName)
{
    NSString *basePath = NSTemporaryDirectory();
    if (!fileName) return basePath;
    return [basePath stringByAppendingPathComponent:fileName];
}

NSString *BundlePath(NSString *filename)
{
    if (!filename)
        return [[NSBundle mainBundle] bundlePath];
    
    NSString *resource = [filename stringByDeletingPathExtension];
    NSString *ext = filename.pathExtension;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:resource ofType:ext];
    if (!path)
    {
        NSLog(@"Error retrieving %@ path from bundle", filename);
        return nil;
    }
    return path;
}

#pragma mark - Defaults

// Defaults
NSObject *GetDefault(NSString *key)
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

void SetDefault(NSString *key, NSObject *value)
{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Random

NSUInteger RandomInteger(NSUInteger max)
{
    return arc4random_uniform((unsigned int) max);
}

CGFloat Random01()
{
    return ((CGFloat) arc4random() / (CGFloat) UINT_MAX);
}

BOOL RandomBool()
{
    return (BOOL)arc4random_uniform(2);
}

CGPoint RandomPointInRect(CGRect rect)
{
    CGFloat x = rect.origin.x + Random01() * rect.size.width;
    CGFloat y = rect.origin.y + Random01() * rect.size.height;
    return CGPointMake(x, y);
}

id RandomItemInArray(NSArray *array)
{
    NSUInteger index = RandomInteger(array.count);
    return array[index];
}

#pragma mark - Color

#if TARGET_OS_IPHONE
#define COLOR_PREFIX colorWithRed
#elif TARGET_OS_MAC
#define COLOR_PREFIX colorWithDeviceRed
#endif

// Underscore prevents issues when combined with color pack
Color *Random_Color()
{
    return [Color COLOR_PREFIX:Random01()
                         green:Random01()
                          blue:Random01()
                         alpha:1.0f];
}

#undef COLOR_PREFIX

#pragma mark - Reading

NSString *StringFromPath(NSString *path)
{
    NSError *error;
    NSString *string = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    if (!string)
    {
        NSLog(@"Error reading string from path %@: %@", path.lastPathComponent, error.localizedDescription);
        return nil;
    }
    return string;
}

NSData *DataFromPath(NSString *path)
{
    NSError *error;
    NSData *data = [NSData dataWithContentsOfFile:path options:0 error:&error];
    if (!data)
    {
        NSLog(@"Error reading data from path %@: %@", path.lastPathComponent, error.localizedDescription);
        return nil;
    }
    return data;
}

#pragma mark - String data

@implementation NSString (GeneralUtility)
- (NSData *) dataRepresentation
{
    return [self dataUsingEncoding:NSUTF8StringEncoding];
}

+ (instancetype) stringWithData: (NSData *) data
{
    return [[self alloc] initWithData:data encoding:NSUTF8StringEncoding];
}
@end

#pragma mark - String comparisons

BOOL StringEqual(NSString *s1, NSString *s2)
{
    return [s1 caseInsensitiveCompare:s2] == NSOrderedSame;
}

BOOL HasPrefix(NSString *s1, NSString *prefix)
{
    return [s1.uppercaseString hasPrefix:prefix.uppercaseString];
}

BOOL HasSuffix(NSString *s1, NSString *suffix)
{
    return [s1.uppercaseString hasSuffix:suffix.uppercaseString];
}

#pragma mark - View

#if TARGET_OS_IPHONE
@implementation UIView (ExtendedLayouts)
- (NSArray *) realSubviews
{
    NSMutableArray *results = [NSMutableArray array];
    for (UIView *view in self.subviews)
        if (![view conformsToProtocol:@protocol(UILayoutSupport)])
            [results addObject:view];
    return [results copy];
}
@end
#endif

#pragma mark - Paths

NSString *Desktop()
{
    return @"/Users/ericasadun/Desktop";
}

NSURL *DesktopURL()
{
    return [NSURL fileURLWithPath:Desktop()];
}

#pragma mark - Data

void SaveDebugData(NSData *data, NSString *name)
{
    NSString *desktopPath = @"/Users/ericasadun/Desktop";
    NSString *targetPath = [desktopPath stringByAppendingPathComponent:name];
    [data writeToFile:targetPath atomically:YES];
}
     
#pragma mark - Images

#if TARGET_OS_IPHONE
void SaveDebugImage(UIImage *image, NSString *name)
{
    SaveDebugData(UIImagePNGRepresentation(image), [[name lastPathComponent] stringByAppendingPathExtension:@"png"]);
}

void WriteImage(UIImage *image, NSString *path)
{
    [UIImagePNGRepresentation(image) writeToFile:path atomically:YES];
}
#endif

#pragma mark - Stylizing

void RoundAndEdgeView(View *view)
{
#if TARGET_OS_IPHONE
    UIColor *color = [[[[UIApplication sharedApplication] delegate] window] tintColor];
    if (!color) color = [[UINavigationBar alloc] init].tintColor;
    if (!color) color = [UIColor blackColor];
    view.layer.borderColor = color.CGColor;
#elif TARGET_OS_MAC
    view.wantsLayer = YES;
    view.layer.borderColor = [Color blackColor].CGColor;
#endif
    view.layer.borderWidth = 0.5f;
    view.layer.cornerRadius = 8;
}

#pragma mark - Ipsum

NSArray *LoremPixelCategories()
{
    return [@"abstract animals business cats city food nightlife fashion people nature sports technics transport" componentsSeparatedByString:@" "];
}

Image *LoremPixel(CGSize size, NSString *category, BOOL gray)
{
    /*
     e.g. http://lorempixel.com/400/200/sports/1/Dummy-Text
     abstract animals business cats city food nightlife fashion people nature sports technics transport
     */
    NSMutableString *string = [NSMutableString stringWithFormat:@"http://lorempixel.com%@/%0.0f/%0.0f", gray ? @"/g/" : @"", floorf(size.width), floorf(size.height)];
    if (category)
        [string appendFormat:@"/%@", category];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:string]];
#if TARGET_OS_IPHONE
    return [UIImage imageWithData:data];
#else
    NSImage *image = [[NSImage alloc] initWithData:data];
    return image;
#endif
}

NSString *TrimWords(NSString *string, NSUInteger numberOfWords)
{
    NSArray *array = [string componentsSeparatedByString:@" "];
    NSArray *subArray = [array subarrayWithRange:NSMakeRange(0, MIN(array.count, numberOfWords))];
    return [subArray componentsJoinedByString:@" "];
}

NSString *TrimParas(NSString *string, NSUInteger numberOfWords)
{
    NSMutableArray *trimmed = [NSMutableArray array];
    NSArray *paras = [string componentsSeparatedByString:@"\n\n"];
    for (NSString *p in paras)
        [trimmed addObject:TrimWords(p, numberOfWords)];
    return [trimmed componentsJoinedByString:@"\n\n"];
}

NSString *Lorem(NSUInteger numberOfParagraphs)
{
    NSString *urlString = [NSString stringWithFormat:@"http://loripsum.net/api/%0ld/short/prude/plaintext", (long) numberOfParagraphs];
    
    NSError *error;
    NSString *string = [NSString stringWithContentsOfURL:[NSURL URLWithString:urlString] encoding:NSUTF8StringEncoding error:&error];
    if (!string)
    {
        NSLog(@"Error: %@", error.localizedDescription);
        return nil;
    }
    return TrimParas(string, 20);
}

NSString *Ipsum(NSUInteger numberOfParagraphs)
{
    return Lorem(numberOfParagraphs);
}

NSString *AnyIpsum(NSUInteger numberOfParagraphs, NSString *topic)
{
    NSString *urlString = [NSString stringWithFormat:@"http://www.anyipsum.com/api/term/%@/paragraphs/%d", [topic stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], (int) numberOfParagraphs];
    
    NSError *error;
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
    if (!data)
    {
        NSLog(@"Error: %@", error.localizedDescription);
        return nil;
    }

    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (!dict)
    {
        NSLog(@"Error creating JSON dictionary: %@", error);
        return nil;
    }
    
    NSString *string = dict[@"anyIpsum"];
    return TrimParas(string, 15);
}

#pragma mark - Test Views
#if TARGET_OS_IPHONE

@implementation TestViewMaker
- (UIView *) buildViewWithController: (UIViewController *) controller h: (CGFloat) h v : (CGFloat) v colorString : (NSString *) colorString alpha: (CGFloat) alpha stylize: (BOOL) stylize
{
    return BuildView(controller, h, v, colorString, alpha, stylize);
}
@end

UIView *BuildView(UIViewController *controller, CGFloat h, CGFloat v, NSString *colorString, CGFloat alpha, BOOL stylize)
{
    UIView *view = [[UIView alloc] init];
    [controller.view addSubview:view];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    
    // Sizing
    NSDictionary *metrics = @{@"width":@(h), @"height":@(v)};
    NSDictionary *bindings = NSDictionaryOfVariableBindings(view);
    for (NSString *string in @[@"H:[view(width)]", @"V:[view(height)]"])
    {
        NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:string options:0 metrics:metrics views:bindings];
        [view addConstraints:constraints];
    }
    [view layoutIfNeeded]; // pre-pump
    
    // Color -- pass x/skip/etc to skip
    if (!colorString || (colorString && [colorString.lowercaseString hasPrefix:@"random"]))
    {
        view.backgroundColor = Random_Color();
    }
    else if (colorString)
    {
        NSString *colorRequest = [colorString stringByAppendingString:@"Color"];
        SEL sel = NSSelectorFromString(colorRequest);
        if ([[UIColor class] respondsToSelector:sel])
        {
            UIColor *c = [[UIColor performSelector:sel] colorWithAlphaComponent:alpha];
            view.backgroundColor = c;
        }
    }
    
    // Stylize
    if (stylize)
    {
        view.layer.borderWidth = 1;
        view.layer.borderColor = [UIColor blackColor].CGColor;
        view.layer.cornerRadius = 12;
    }

    return view;
}
#endif

#if TARGET_OS_IPHONE
@implementation UIViewController (NotificationObservers)
SynthesizeSetter(observers, setObservers:, NSMutableArray *);
- (NSMutableArray *) observers
{
    NSMutableArray *array = objc_getAssociatedObject(self, @selector(observers));
    if (!array) self.observers = [NSMutableArray array];
    return objc_getAssociatedObject(self, @selector(observers));
}

- (void) addNotificationObserver: (NSObject *) observer
{
    if (!observer) return;
    [self.observers addObject:observer];
}

- (void) observeNotification: (NSString *) notificationName block:(void (^)(NSNotification *)) block
{
    id observer = [[NSNotificationCenter defaultCenter] addObserverForName:notificationName object:nil queue:[NSOperationQueue mainQueue] usingBlock:block];
    [self addNotificationObserver:observer];
}

// call from dealloc typically
- (void) removeAllNotificationObservers
{
    for (NSObject *observer in self.observers)
        [[NSNotificationCenter defaultCenter] removeObserver:observer];
    [self.observers removeAllObjects];
}
@end
#endif

// Cleanup
#undef View
#undef Color
#undef Image
#undef Font