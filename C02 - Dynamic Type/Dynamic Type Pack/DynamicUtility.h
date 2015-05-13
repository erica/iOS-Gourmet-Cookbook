/*
 
 Erica Sadun, http://ericasadun.com
 
 */

#import <Foundation/Foundation.h>

// System Styles
#ifndef SYSTEM_TEXT_STYLES
#define SYSTEM_TEXT_STYLES @[UIFontTextStyleHeadline, UIFontTextStyleSubheadline, UIFontTextStyleBody, UIFontTextStyleFootnote, UIFontTextStyleCaption1, UIFontTextStyleCaption2]
#endif

// System Fonts
#ifndef SYSTEM_SUPPLIED_FONTS
#define SYSTEM_SUPPLIED_FONTS @[[UIFont headlineFont], [UIFont subheadlineFont], [UIFont bodyFont], [UIFont footnoteFont], [UIFont caption1Font], [UIFont caption2Font]]
#endif

// Default Font
#ifndef DEFAULT_TEXT_STYLE
#define DEFAULT_TEXT_STYLE  UIFontTextStyleBody
#endif

// Standard Size Categories
#ifndef STANDARD_SIZE_CATEGORIES
#define STANDARD_SIZE_CATEGORIES @{UIContentSizeCategoryExtraSmall:@0, UIContentSizeCategorySmall:@1, UIContentSizeCategoryMedium:@2, UIContentSizeCategoryLarge:@3, UIContentSizeCategoryExtraLarge:@4, UIContentSizeCategoryExtraExtraLarge:@5, UIContentSizeCategoryExtraExtraExtraLarge:@6}
#endif

// All Size Categories
#ifndef ALL_SIZE_CATEGORIES
#define ALL_SIZE_CATEGORIES @{UIContentSizeCategoryExtraSmall:@0, UIContentSizeCategorySmall:@1, UIContentSizeCategoryMedium:@2, UIContentSizeCategoryLarge:@3, UIContentSizeCategoryExtraLarge:@4, UIContentSizeCategoryExtraExtraLarge:@5, UIContentSizeCategoryExtraExtraExtraLarge:@6, UIContentSizeCategoryAccessibilityMedium:@7, UIContentSizeCategoryAccessibilityLarge:@8, UIContentSizeCategoryAccessibilityExtraLarge:@9, UIContentSizeCategoryAccessibilityExtraExtraLarge:@10, UIContentSizeCategoryAccessibilityExtraExtraExtraLarge:@11}
#endif

@interface UIFont (BuiltInStyles)
+ (UIFont *) headlineFont;
+ (UIFont *) subheadlineFont;
+ (UIFont *) bodyFont;
+ (UIFont *) footnoteFont;
+ (UIFont *) caption1Font;
+ (UIFont *) caption2Font;
+ (NSString *) styleForFont: (UIFont *) font;
@end

@interface NSAttributedString (DynamicUtility)
@property (nonatomic, readonly) NSDictionary *textStyleRangeDictionary;
- (instancetype) attributedStringByApplyingTextStyleRangeDictionary: (NSDictionary *) dictionary;
@end

// Match font size to a style
NSString *ClosestSystemStyle(UIFont *font);

// Create font based on system style
UIFont *SystemSizeBasedFont(NSString *fontName, NSString *textStyle);

// Scan attributed string for style ranges
NSDictionary *TextStyleRangeDictionary(NSAttributedString *attributedString);

// Apply style range dictionary to attributed string
NSAttributedString *ApplyTextStylesToAttributedString(NSAttributedString *attributedString, NSDictionary *textStyleRangeDictionary);

// Stylize font based on current preferred content size, min and max range
UIFont *StylizedFont(NSString *fontName, CGFloat minimumFontSize, CGFloat maximumFontSize);
UIFont *StylizedSystemFont(CGFloat minimumFontSize, CGFloat maximumFontSize);
UIFont *StylizedBoldSystemFont(CGFloat minimumFontSize, CGFloat maximumFontSize);