/*
 
 Erica Sadun, http://ericasadun.com
 
 */

@import Foundation;

// Doc types: rtfd/rtf/html/htm/txt
NSDictionary *DocumentTypeDictionary(NSString *ext) __attribute__((nonnull));

// Load atrributed string
NSAttributedString *AttributedStringWithPath(NSString *path, NSDictionary **documentDictionary);
NSAttributedString *AttributedStringWithString(NSString *sourceString, NSString *ext);
NSAttributedString *AttributedStringWithData(NSData *data, NSString *ext);

// Attributed string representations
NSData *AttributedStringDataRepresentation(NSAttributedString *string, NSString *ext);
NSString *AttributedStringStringRepresentation(NSAttributedString *string, NSString *ext);

// Debug
void DumpStringAttributes(NSAttributedString *input);

@interface NSAttributedString (Documents)
@property (nonatomic, readonly) NSString *HTMLRepresentation;
+ (instancetype) stringWithHTML: (NSString *) htmlString;
+ (instancetype) stringWithPath: (NSString *) path;
@end