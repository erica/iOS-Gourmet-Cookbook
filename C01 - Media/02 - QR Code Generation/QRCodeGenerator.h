/*
 
 Erica Sadun, http://ericasadun.com
 
 */

#import <Foundation/Foundation.h>

@interface QRCodeGenerator : NSObject
+ (UIImage *) qrImageWithString: (NSString *) string size: (CGSize) destSize;
@end
