/*
 
 Erica Sadun, http://ericasadun.com
 
 */

#import <Foundation/Foundation.h>

@import UIKit;
@import CoreText;

// A few convenient extensions for my own use
// This is a terrific example of methods that should be namespaced in non-book situations

@interface NSString (AttributedStringUtility)
@property (nonatomic, readonly) NSAttributedString *attributedVersion;
@end

@interface NSAttributedString (AttributedStringUtility)
// Constructors
+ (instancetype) string;
+ (instancetype) stringWithString: (NSString *) string;
+ (instancetype) stringWithString:(NSString *)string attributes: (NSDictionary *) attributes;
+ (instancetype) stringWithAttributedString: (NSAttributedString *) string;

// Adjusters
- (NSAttributedString *) stringByAppendingAttributedString: (NSAttributedString *) string;
- (NSAttributedString *) stringByAdjustingFontSizeByPercent: (CGFloat) percent;
- (NSAttributedString *) stringByAddingAttribute: (NSString *) attributeName value: (id) value;
- (NSAttributedString *) stringWithFont: (UIFont *) font;
- (NSAttributedString *) stringWithColor:(UIColor *) color;

// Range of the entire string
@property (nonatomic, readonly) NSRange fullRange;

// Character access
- (instancetype) objectAtIndexedSubscript: (NSUInteger) anIndex;

// Size check
@property (nonatomic, readonly) CGFloat width;
@property (nonatomic, readonly) CGFloat height;
- (CGSize) sizeWithWidth: (CGFloat) width;
@end
