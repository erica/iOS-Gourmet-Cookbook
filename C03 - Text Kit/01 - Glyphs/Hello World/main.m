/*
 
 Erica Sadun, http://ericasadun.com
 Gourmet Recipes
 
 */

@import UIKit;
@import CoreText;
#import "Essentials.h"

@interface NSLayoutManager (GeneralUtility)
@property (nonatomic, readonly) NSUInteger trueGlyphCount;
@end

@implementation NSLayoutManager (GeneralUtility)
- (NSUInteger) trueGlyphCount
{
    if (self.numberOfGlyphs < 2) return self.numberOfGlyphs;
    
    NSUInteger count = 0;
    for (NSTextContainer *container in self.textContainers)
    {
        NSRange glyphRange = [self glyphRangeForTextContainer:container];
        if (glyphRange.length < 2)
        {
            count += glyphRange.length;
            continue;
        }
        
        // First item
        CGRect bounds = [self boundingRectForGlyphRange:NSMakeRange(glyphRange.location, 1) inTextContainer:container];
        count += 1;
        
        // Remaining items
        for (NSUInteger index = 1; index < glyphRange.length; index++)
        {
            CGRect testBounds = [self boundingRectForGlyphRange:NSMakeRange(glyphRange.location + index, 1) inTextContainer:container];
            if (CGRectEqualToRect(bounds, testBounds)) continue;
            bounds = testBounds;
            count += 1;
        }
    }

    return count;
}
@end

@interface TestBedViewController : UIViewController
@end

@implementation TestBedViewController
{
    UIImageView *imageView;
    UITextView *textView;
}

- (void) prepareContextForCoreText: (CGSize) size
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, size.height);
    CGContextScaleCTM(context, 1.0, -1.0); // flip the context
}

// Test with refine, whiffle, flout, inflate
- (UIImage *) drawGlyphs: (NSString *) initialString
{
    // Establish a font
    UIFont *theFont = [UIFont fontWithName:@"HoeflerText-Regular" size:60];
    
    // Create the attributed string with ligatures enabled
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:initialString attributes:@{NSFontAttributeName:theFont, NSLigatureAttributeName:@(YES)}];
    
    // Establish a drawing space
    CGRect bounds = [string boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    
    // Inflate to allow spacing out
    bounds.size.width *= 3;
    bounds.size.height *= 3;
    
    UIGraphicsBeginImageContextWithOptions(bounds.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // White background
    [[UIColor whiteColor] set];
    CGContextFillRect(context, bounds);
    
    // Flip for Quartz drawing coordinate system
    [self prepareContextForCoreText:bounds.size];
    
    // Point to start drawing
    CGPoint point = CGPointMake(20, CGRectGetMidY(bounds));

    // Draw each Core Text run
    // Note, the line cannot be freed without crashes
    CTLineRef line = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef)string);
    NSArray *runArray = (__bridge_transfer NSArray *) CTLineGetGlyphRuns(line);
    
    for (id eachRun in runArray)
    {
        CTRunRef run = (__bridge CTRunRef)eachRun;
        
        // Set the drawing font
        CFDictionaryRef attributes = CTRunGetAttributes(run);
        CTFontRef runFont = CFDictionaryGetValue(attributes, kCTFontAttributeName);
        CGFontRef cgFont = CTFontCopyGraphicsFont(runFont, NULL);
        CGContextSetFont(context, cgFont);
        CGContextSetFontSize(context, CTFontGetSize(runFont));
        CGFontRelease(cgFont);
        
        // Iterate through each glyph in the run
        for (CFIndex runGlyphIndex = 0; runGlyphIndex < CTRunGetGlyphCount(run); runGlyphIndex++)
        {
            // Fetch the glyph based on its index in the run
            CGGlyph glyph;
            CFRange glyphRange = CFRangeMake(runGlyphIndex, 1);
            CTRunGetGlyphs(run, glyphRange, &glyph);
            
            // Calculate a surrounding rectangle
            CGFloat ascent, descent, leading;
            double glyphWidth = CTRunGetTypographicBounds(run, CFRangeMake(runGlyphIndex, 1), &ascent, &descent, &leading);
            CGRect destRect = CGRectMake(point.x, point.y - (ascent + descent) / 2.0, glyphWidth, ascent + descent);
            
            // Fetch the run attributes for testing fonts, enabling emoji support
            NSDictionary *attributes = (__bridge NSDictionary *)CTRunGetAttributes(run);
            if (attributes[NSFontAttributeName] == theFont)
            {
                // Normal drawing
                [[UIColor blackColor] set];
                CGContextShowGlyphsAtPositions(context, &glyph, &destRect.origin, 1);
            }
            else
            {
                // Emoji
                UIFont *glyphFont = attributes[NSFontAttributeName];
                CTFontRef fontRef = CTFontCreateWithName((CFStringRef)glyphFont.fontName, glyphFont.pointSize, NULL);
                CTFontDrawGlyphs(fontRef, &glyph, &destRect.origin, 1, context);
                CFRelease(fontRef);
            }
            
            // Draw a rectangle in gray
            destRect = CGRectInset(destRect, -8, -8);
            destRect.origin.y -= descent;
            UIBezierPath *path = [UIBezierPath bezierPathWithRect:destRect];
            [[UIColor lightGrayColor] set];
            [path stroke];
            
            // Move to the right
            point.x += glyphWidth + 40;
        }
    }

    // Retrieve the image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

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

- (void) go
{
    NSArray *testStrings = @[@"adjusting", @"refine", @"whiffle", @"flout", @"inflate", @"offal", @"hoofbeat", @"calfhood", @"fjarding", @"wolfkin", @"offbeat", @"offhand", @"tscheffkinite", @"fiflffffifflfbfhfjfkffbffhffk", @"dog🐶cow🐄s"];
    static int i = 0;
    imageView.image = [self drawGlyphs:testStrings[i]];
    
    // The glyph count in Text Kit will not necessarily match the glyph count for Core Text layout even though the ligatures will properly show up in the rendered label
    
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:testStrings[i] attributes:@{NSFontAttributeName:[UIFont fontWithName:@"HoeflerText-Regular" size:60],NSLigatureAttributeName:@(YES)}];
    
    // Access in text view manager
    [textView.textStorage setAttributedString:attributedString];
    if (textView.layoutManager.numberOfGlyphs != textView.textStorage.string.length) return;
    Log(@"Number of glyphs in %@: %zd", attributedString.string, textView.layoutManager.numberOfGlyphs);
    Log(@"True number of glyphs: %zd", textView.layoutManager.trueGlyphCount);
    for (int index = 0; index < attributedString.string.length; index++)
    {
        Log(@"Index: %zd glyph index for character: %zd", index, [textView.layoutManager glyphIndexForCharacterAtIndex:index]);
        Log(@"Index: %zd character index for glyph: %zd", index, [textView.layoutManager characterIndexForGlyphAtIndex:index]);
        Log(@"Index: %zd bounds: %@", index, NSStringFromCGRect([textView.layoutManager boundingRectForGlyphRange:NSMakeRange(index, 1) inTextContainer:textView.layoutManager.textContainers.firstObject]));
    }

    
    // Advance the word count
    i = (i + 1) % testStrings.count;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    imageView = [UIImageView new];
    PlaceView(self, imageView, @"xx", 0, 0, 1000);
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    textView = [UITextView new];
    textView.editable = YES;
    PlaceView(self, textView, @"-x", 8, 8, 1000);
    StretchViewToTopLayoutGuide(self, textView, 0, 1000);
    SizeView(textView, CGSizeMake(SkipConstraint, 80), 1000);
    
    self.navigationItem.rightBarButtonItem = BARBUTTON(@"Go", @selector(go));
    [self go];
}
@end

#pragma mark - Application Setup -

@interface TestBedAppDelegate : NSObject <UIApplicationDelegate>
@property (nonatomic, strong) UIWindow *window;
@end

@implementation TestBedAppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    TestBedViewController *vc = [[TestBedViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    _window.rootViewController = nav;
    [_window makeKeyAndVisible];
    return YES;
}
@end

int main(int argc, char *argv[]) {
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, @"TestBedAppDelegate");
    }
}