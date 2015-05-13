/*
 
 Erica Sadun, http://ericasadun.com
 
 */

#import "DynamicUtility.h"

@implementation UIFont (BuiltInStyles)
+ (UIFont *) headlineFont
{
    return [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
}

+ (UIFont *) subheadlineFont
{
    return [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
}

+ (UIFont *) bodyFont
{
    return [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
}

+ (UIFont *) footnoteFont
{
    return [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
}

+ (UIFont *) caption1Font
{
    return [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
}

+ (UIFont *) caption2Font
{
    return [UIFont preferredFontForTextStyle:UIFontTextStyleCaption2];
}

+ (NSString *) styleForFont: (UIFont *) font
{
    NSInteger index = [SYSTEM_SUPPLIED_FONTS indexOfObject:font];
    if (index == NSNotFound) return nil;
    return SYSTEM_TEXT_STYLES[index];
}
@end

NSString *ClosestSystemStyle(UIFont *font)
{
    CGFloat minimumDistance = MAXFLOAT;
    NSInteger selectedIndex = -1;
    NSInteger index = 0;
    
    for (UIFont *candidate in SYSTEM_SUPPLIED_FONTS)
    {
        CGFloat distance = fabsf(font.pointSize - candidate.pointSize);
        if (distance < minimumDistance)
        {
            selectedIndex = index;
            minimumDistance = distance;
        }
        index++;
    }
    
    return SYSTEM_TEXT_STYLES[selectedIndex];
}


NSDictionary *TextStyleRangeDictionary(NSAttributedString *attributedString)
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [attributedString enumerateAttributesInRange:NSMakeRange(0, attributedString.length) options:0 usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
        UIFont *font = attrs[NSFontAttributeName];
        if (font)
        {
            NSInteger index = [SYSTEM_SUPPLIED_FONTS indexOfObject:font];
            if (index != NSNotFound)
            {
                NSString *textStyle = SYSTEM_TEXT_STYLES[index];
                dict[[NSValue valueWithRange:range]] = @[textStyle];
            }
            else
            {
                // did not find a matching system font, so store face and style
                NSString *closestMatch = ClosestSystemStyle(font);
                UIFont *closestSystemFont = [UIFont preferredFontForTextStyle:closestMatch];
                if (closestSystemFont)
                {
                    CGFloat multiplier = font.pointSize / closestSystemFont.pointSize;
                    dict[[NSValue valueWithRange:range]] = @[closestMatch, font.fontName, @(multiplier)];
                }
            }
        }
    }];
    
    return dict;
}

// Fetch a style range dictionary for system-supplied fonts
NSAttributedString *ApplyTextStylesToAttributedString(NSAttributedString *sourceString, NSDictionary *styleDictionary)
{
    if (!sourceString) return nil;
    if (!styleDictionary) return sourceString;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:sourceString];
    
    for (NSValue *value in styleDictionary.allKeys)
    {
        NSRange range = value.rangeValue;
        NSArray *array = styleDictionary[value];
        if (array.count == 0) continue;
        UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        
        NSString *textStyle = array[0];
        if (array.count == 1) // system-supplied
        {
            font = [UIFont preferredFontForTextStyle:textStyle];
        }
        else if (array.count == 3) // custom font
        {
            NSString *face = array[1];
            UIFont *sysFont = [UIFont preferredFontForTextStyle:textStyle];
            NSNumber *multiplier = array[2];
            font = [UIFont fontWithName:face size:sysFont.pointSize * multiplier.floatValue];
        }
        [attributedString addAttributes:@{NSFontAttributeName:font} range:range];
    }
    
    return attributedString;
}

@implementation NSAttributedString (DynamicUtility)
- (NSDictionary *) textStyleRangeDictionary
{
    return TextStyleRangeDictionary(self);
}

- (instancetype) attributedStringByApplyingTextStyleRangeDictionary: (NSDictionary *) dictionary
{
    return ApplyTextStylesToAttributedString(self, dictionary);
}
@end

// Return a font based on the system size
UIFont *SystemSizeBasedFont(NSString *fontName, NSString *textStyle)
{
    if (!fontName || !textStyle) return nil;
    
    UIFont *font = [UIFont preferredFontForTextStyle:textStyle];
    return [UIFont fontWithName:fontName size:font.pointSize];
}

UIFont *StylizedFont(NSString *fontName, CGFloat minimumFontSize, CGFloat maximumFontSize)
{
    NSInteger categoryCount = STANDARD_SIZE_CATEGORIES.allKeys.count;
    NSString *preferedSize = [[UIApplication sharedApplication] preferredContentSizeCategory];
    NSInteger sizeIndex = [STANDARD_SIZE_CATEGORIES[preferedSize] integerValue];
    CGFloat percent = (CGFloat) sizeIndex / (CGFloat) (categoryCount - 1);
    CGFloat targetFontSize = round(minimumFontSize + (maximumFontSize - minimumFontSize) * powf(percent, 3));
    
    return [UIFont fontWithName:fontName size:targetFontSize];
}

UIFont *StylizedSystemFont(CGFloat minimumFontSize, CGFloat maximumFontSize)
{
    NSInteger categoryCount = STANDARD_SIZE_CATEGORIES.allKeys.count;
    NSString *preferedSize = [[UIApplication sharedApplication] preferredContentSizeCategory];
    NSInteger sizeIndex = [STANDARD_SIZE_CATEGORIES[preferedSize] integerValue];
    CGFloat percent = (CGFloat) sizeIndex / (CGFloat) (categoryCount - 1);
    CGFloat targetFontSize = round(minimumFontSize + (maximumFontSize - minimumFontSize) * powf(percent, 3));

    return [UIFont systemFontOfSize:targetFontSize];
}

UIFont *StylizedBoldSystemFont(CGFloat minimumFontSize, CGFloat maximumFontSize)
{
    NSInteger categoryCount = STANDARD_SIZE_CATEGORIES.allKeys.count;
    NSString *preferedSize = [[UIApplication sharedApplication] preferredContentSizeCategory];
    NSInteger sizeIndex = [STANDARD_SIZE_CATEGORIES[preferedSize] integerValue];
    CGFloat percent = (CGFloat) sizeIndex / (CGFloat) (categoryCount - 1);
    CGFloat targetFontSize = round(minimumFontSize + (maximumFontSize - minimumFontSize) * powf(percent, 3));
    
    return [UIFont boldSystemFontOfSize:targetFontSize];
}





