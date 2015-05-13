/*
 
 Erica Sadun, http://ericasadun.com
 
 */


#import "AttributedStringPack.h"

@implementation NSMutableAttributedString (AttributedStringUtility)

#pragma mark - Utility

- (void) performRepair
{
    [self fixAttributesInRange:self.fullRange];
}

- (void) appendString:(NSString *)string
{
    [self appendAttributedString:[NSAttributedString stringWithString:string]];
}

- (void) appendString: (NSString *)string withAttributes: (NSDictionary *) attributeDictionary
{
    NSAttributedString *s = [[NSAttributedString alloc] initWithString:string attributes:attributeDictionary];
    [self appendAttributedString:s];
}


#pragma mark - Color

- (void) setColor:(UIColor *) color range: (NSRange) range;
{
    UIColor *destColor = color ? color : [UIColor blackColor];
    [self addAttributes:@{NSForegroundColorAttributeName : destColor} range:range];
}

- (void) setColor:(UIColor *) color
{
    [self setColor:color range:NSMakeRange(0, self.length)];
}

#pragma mark - Font Size and Face

- (void) setFontSize: (CGFloat) fontSize range:(NSRange) requestedRange
{
    UIFont *defaultFont = [UIFont systemFontOfSize:12];
    [self enumerateAttributesInRange:requestedRange options:0 usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop)
     {
         UIFont *oldFont = attrs[NSFontAttributeName] ? : defaultFont;
         UIFont *newFont = [UIFont fontWithName:oldFont.fontName size:fontSize];
         [self addAttribute:NSFontAttributeName value:newFont range:range];
     }];
}

- (void) adjustFontSizesByPercent: (CGFloat) percent range:(NSRange) requestedRange
{
    UIFont *defaultFont = [UIFont systemFontOfSize:12];
    [self enumerateAttributesInRange:requestedRange options:0 usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop)
     {
         UIFont *oldFont = attrs[NSFontAttributeName] ? : defaultFont;
         UIFont *newFont = [UIFont fontWithName:oldFont.fontName size:fabsf((1.0f + percent) * oldFont.pointSize)];
         [self addAttribute:NSFontAttributeName value:newFont range:range];
     }];
}

- (void) setFontFace: (NSString *) face range: (NSRange) requestedRange
{
    if (!face) return;

    UIFont *defaultFont = [UIFont systemFontOfSize:12];
    [self enumerateAttributesInRange:requestedRange options:0 usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop)
     {
         UIFont *oldFont = attrs[NSFontAttributeName] ? : defaultFont;
         UIFont *newFont = [UIFont fontWithName:face size:oldFont.pointSize];
         [self addAttribute:NSFontAttributeName value:newFont range:range];
     }];
}

- (void) setFont:(UIFont *) font range:(NSRange) requestedRange
{
    if (!font) return;
    [self addAttributes:@{NSFontAttributeName : font} range:requestedRange];
}

- (void) setFont:(UIFont *)font
{
    [self setFont:font range:NSMakeRange(0, self.length)];
}

#pragma mark - Weight and Slant

- (void) setBold:(BOOL) yorn range:(NSRange) requestedRange
{
    CGFloat degree = yorn ? 2.5f : 0.0f;
    [self addAttribute:NSStrokeWidthAttributeName value:@(-degree) range:requestedRange];
    [self addAttribute:NSBaselineOffsetAttributeName value:@(-degree / 12.0f) range:requestedRange];
}

- (void) setItalic:(BOOL) yorn range:(NSRange) requestedRange
{
    [self addAttribute:NSObliquenessAttributeName value:@(yorn ? 0.2f : 0.0f) range:requestedRange];
}

#pragma mark - Paragraph Styles

- (void) setAlignment: (NSTextAlignment) alignment range: (NSRange) requestedRange
{
    [self enumerateAttributesInRange:requestedRange options:0 usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop)
     {
         NSMutableParagraphStyle *style;
         if (attrs[NSParagraphStyleAttributeName])
             style = [attrs[NSParagraphStyleAttributeName] mutableCopy];
         else
             style = [[NSMutableParagraphStyle alloc] init];
         style.alignment = alignment;
         [self addAttribute:NSParagraphStyleAttributeName value:style range:range];
     }];
}

- (void) setLineBreakMode: (NSLineBreakMode) lineBreakMode range: (NSRange) requestedRange
{
    [self enumerateAttributesInRange:requestedRange options:0 usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop)
     {
         NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
         if (attrs[NSParagraphStyleAttributeName])
             style = [attrs[NSParagraphStyleAttributeName] mutableCopy];
         style.lineBreakMode = lineBreakMode;
         [self addAttribute:NSParagraphStyleAttributeName value:style range:range];
     }];
}

#pragma mark - Other
- (void) enableLigatures: (BOOL) yorn
{
    [self addAttribute:NSLigatureAttributeName value:@(yorn) range:NSMakeRange(0, self.length)];
}

- (void) enableKerning: (BOOL) yorn
{
    [self addAttribute:NSKernAttributeName value:@(yorn) range:NSMakeRange(0, self.length)];
}
@end
