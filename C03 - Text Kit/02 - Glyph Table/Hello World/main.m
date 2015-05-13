/*
 
 Erica Sadun, http://ericasadun.com
 Gourmet Recipes
 
 */

@import UIKit;
@import CoreText;
#import "Essentials.h"

@interface TestBedViewController : UIViewController
{
    UITextView *textView;
}
@end

@implementation TestBedViewController
- (NSData *) pdfData
{
    // Standard US letter, one-inch margins
    CGSize pageSize = CGSizeMake(612, 792);
    CGRect drawingRect =
    CGRectInset((CGRect){.size = pageSize}, 72, 72);
    
    // Establish Text Kit representation
    NSTextStorage *storage = [[NSTextStorage alloc] initWithAttributedString:textView.textStorage];
    NSLayoutManager *manager = [NSLayoutManager new];
    [storage addLayoutManager:manager];
    NSTextContainer *container = [[NSTextContainer alloc] initWithSize:drawingRect.size];
    [manager addTextContainer:container];
    
    // Build PDF data
    NSMutableData *outputData = [NSMutableData data];
    UIGraphicsBeginPDFContextToData(outputData, (CGRect){.size = pageSize}, nil);
    while (storage.length > 0)
    {
        NSRange range;
        UIGraphicsBeginPDFPage();
        
        // Count the glyphs that fit into the container
        [manager textContainerForGlyphAtIndex:0
                               effectiveRange:&range];
        
        // Draw those glyphs
        [manager drawGlyphsForGlyphRange:range
                                 atPoint:drawingRect.origin];
        
        // Remove already-drawn glyphs
        NSInteger endIndex =
        [manager characterIndexForGlyphAtIndex:range.length];
        NSRange clearRange = NSMakeRange(0, endIndex);
        [storage deleteCharactersInRange:clearRange]; 
    }
    UIGraphicsEndPDFContext();
    
    return outputData;
}

- (void) saveFile
{
    NSData *data = [self pdfData];
#warning Change the following path to use your own Desktop location
    [data writeToFile:@"/Users/ericasadun/Desktop/font.pdf" atomically:YES];
}

- (NSAttributedString *) generateFontInformation
{
    NSMutableAttributedString *string = [NSMutableAttributedString new];
    
    NSString *fontName = @"HoeflerText-Regular";
    CGFontRef fontRef = CGFontCreateWithFontName((__bridge CFStringRef) fontName);
    size_t count = CGFontGetNumberOfGlyphs(fontRef);
    
    NSString *title = [NSString stringWithFormat:@"%@\n",  fontName];
    NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Courier" size:32]}];
    [string appendAttributedString:attributedTitle];
    
    CGFloat side = 30;
    CGRect rect = CGRectMake(0, 0, side, side);
    CGPoint drawingPoint = CGPointMake(12, 12);
    CGFloat fontSize = 12;
    
    for (CGGlyph i = 0; i < count; i++ )
    {
        NSString *name  = (__bridge_transfer NSString *)CGFontCopyGlyphNameForGlyph(fontRef, i);
        NSString *identity = [NSString stringWithFormat:@" %3d: %@\n", i, name];
        
        UIGraphicsBeginImageContextWithOptions(rect.size, YES, 0);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFont(context, fontRef);
        CGContextSetFontSize(context, fontSize);
        CGContextSetTextMatrix(context, CGAffineTransformIdentity);
        CGContextTranslateCTM(context, 0, side);
        CGContextScaleCTM(context, 1.0, -1.0); // flip the context
        
        // Fill and frame
        [[UIColor whiteColor] set];
        UIRectFill(rect);
        [[UIColor blackColor] set];
        UIRectFrame(rect);
        
        // Draw glyph
        CGGlyph glyph = CGFontGetGlyphWithGlyphName(fontRef, (__bridge CFStringRef) name);
        CGContextShowGlyphsAtPositions(context, &glyph, &drawingPoint, 1);
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
        attachment.image = image;
        attachment.bounds = (CGRect){.size = image.size};
        
        NSAttributedString *s1 = [NSAttributedString attributedStringWithAttachment:attachment];
        NSAttributedString *s2 = [[NSAttributedString alloc] initWithString:identity attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Courier" size:12], NSLigatureAttributeName:@(YES)}];
        [string appendAttributedString:s1];
        [string appendAttributedString:s2];
    }
    CFRelease(fontRef);
    
    return string;
}


- (void) viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = BARBUTTON(@"Save", @selector(saveFile));
    
    textView = [UITextView new];
    textView.editable = NO;
    PlaceView(self, textView, @"xx", 0, 0, 1000);
    self.extendLayoutUnderBars = NO;
    [textView.textStorage appendAttributedString:[self generateFontInformation]];
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