/*
 
 Erica Sadun, http://ericasadun.com
 
 */


#import <Foundation/Foundation.h>

#define DEFAULT_BOLDNESS    3.0f

@interface NSMutableAttributedString (AttributedStringUtility)
// Repair
- (void) performRepair;

// How is this not already in there?
- (void) appendString: (NSString *) string;
- (void) appendString: (NSString *)string withAttributes: (NSDictionary *) attributeDictionary;

// Adjust color
- (void) setColor:(UIColor *) color;
- (void) setColor:(UIColor *) color range: (NSRange) range;

// Adjust fonts
- (void) setFont:(UIFont *) font;
- (void) setFont:(UIFont *) font range:(NSRange) requestedRange;
- (void) setFontSize:(CGFloat)fontSize range: (NSRange) requestedRange;
- (void) setFontFace: (NSString *) face range: (NSRange) requestedRange;
- (void) adjustFontSizesByPercent: (CGFloat) percent range:(NSRange) requestedRange;

// Weight and slant
- (void) setBold:(BOOL) yorn range:(NSRange) requestedRange;
- (void) setItalic: (BOOL) yorn range:(NSRange) requestedRange;

// Adjust paragraph style
- (void) setAlignment: (NSTextAlignment) alignment range: (NSRange) requestedRange;
- (void) setLineBreakMode: (NSLineBreakMode) lineBreakMode range: (NSRange) requestedRange;

// Other
- (void) enableLigatures: (BOOL) yorn;
- (void) enableKerning: (BOOL) yorn;
@end

