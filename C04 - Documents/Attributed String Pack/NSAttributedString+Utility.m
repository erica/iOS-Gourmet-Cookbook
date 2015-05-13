/*
 
 Erica Sadun, http://ericasadun.com
 
 */

#import "NSAttributedString+Utility.h"

/*
 NSFontAttributeName - font
 NSParagraphStyleAttributeName - paragraph style
 
 NSForegroundColorAttributeName - primary color
 NSStrokeColorAttributeName - stroke color
 NSStrokeWidthAttributeName - stroke width
 NSBackgroundColorAttributeName - background color

 NSObliquenessAttributeName - italics
 NSExpansionAttributeName - condensed or expand

 NSStrikethroughStyleAttributeName - strike through
 NSStrikethroughColorAttributeName - strike through color

 NSUnderlineStyleAttributeName - underline
 NSUnderlineColorAttributeName - underline color

 NSLigatureAttributeName - ligatures
 NSKernAttributeName - kerning

 NSShadowAttributeName - shadow
 
 NSBaselineOffsetAttributeName - super, sub
 
 NSLinkAttributeName - URL
 
 NSTextEffectAttributeName
 NSAttachmentAttributeName
 NSWritingDirectionAttributeName
 NSVerticalGlyphFormAttributeName
 */

#pragma mark - NSString constructor
@implementation  NSString (AttributedStringUtility)
- (NSAttributedString *) attributedVersion
{
    return [NSAttributedString stringWithString:self];
}
@end

@implementation NSAttributedString (AttributedStringUtility)

#pragma mark - Constructors

+ (instancetype) string
{
    return [self stringWithString:@""];
}

+ (instancetype) stringWithString: (NSString *) string
{
    return [[self alloc] initWithString:string];
}

+ (instancetype) stringWithString:(NSString *)string attributes: (NSDictionary *) attributes
{
    return [[self alloc] initWithString:string attributes:attributes];
}

+ (instancetype) stringWithAttributedString: (NSAttributedString *) string
{
    return [[self alloc] initWithAttributedString:string];
}

#pragma mark - Adjusters

- (NSAttributedString *) stringByAppendingAttributedString: (NSAttributedString *) string
{
    NSMutableAttributedString *mutable = [self mutableCopy];
    [mutable appendAttributedString:string];
    return mutable.copy;
}

- (NSAttributedString *) stringByAdjustingFontSizeByPercent: (CGFloat) percent
{
    NSMutableAttributedString *mutable = [self mutableCopy];
    UIFont *defaultFont = [UIFont systemFontOfSize:12];
    [self enumerateAttributesInRange:NSMakeRange(0, self.length) options:0 usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop)
     {
         UIFont *oldFont = attrs[NSFontAttributeName] ? : defaultFont;
         UIFont *newFont = [UIFont fontWithName:oldFont.fontName size:fabs(oldFont.pointSize * (1.0f + percent))];
         [mutable addAttribute:NSFontAttributeName value:newFont range:range];
     }];
    return mutable.copy;
}

- (NSAttributedString *) stringByAddingAttribute: (NSString *) attributeName value: (id) value
{
    NSMutableAttributedString *mutable = [self mutableCopy];
    [mutable addAttribute:attributeName value:value range:NSMakeRange(0, self.length)];
    return mutable.copy;
}

- (NSAttributedString *) stringWithFont:(UIFont *)font
{
    return [self stringByAddingAttribute:NSFontAttributeName value:font];
}

- (NSAttributedString *) stringWithColor:(UIColor *) color
{
    return [self stringByAddingAttribute:NSForegroundColorAttributeName value:color];
}

#pragma mark - Utility

- (NSRange) fullRange
{
    return NSMakeRange(0, self.length);
}

// Returns a single char at a time
- (instancetype) objectAtIndexedSubscript: (NSUInteger) anIndex
{
    if (anIndex >= self.length) return nil;
    return [self attributedSubstringFromRange:NSMakeRange(anIndex, 1)];
}

// Size constrained to a given width
- (CGSize) sizeWithWidth: (CGFloat) width
{
    return [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:0 context:nil].size;
}

- (CGFloat) width
{
    return [self sizeWithWidth:CGFLOAT_MAX].width;
}

- (CGFloat) height
{
    return [self sizeWithWidth:CGFLOAT_MAX].height;
}
@end
