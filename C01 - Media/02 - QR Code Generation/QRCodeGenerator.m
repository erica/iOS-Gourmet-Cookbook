/*
 
 Erica Sadun, http://ericasadun.com
 
 */

#import "QRCodeGenerator.h"

@implementation QRCodeGenerator

+ (UIImage *) resizeImageWithoutInterpolation:(UIImage *)sourceImage size:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextSetInterpolationQuality(UIGraphicsGetCurrentContext(), kCGInterpolationNone);
    [sourceImage drawInRect:(CGRect){.size = size}];
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}

+ (UIImage *) imageWithCIImage: (CIImage *) aCIImage orientation: (UIImageOrientation) anOrientation
{
    if (!aCIImage) return nil;
    
    CGImageRef imageRef = [[CIContext contextWithOptions:nil] createCGImage:aCIImage fromRect:aCIImage.extent];
    UIImage *image = [UIImage imageWithCGImage:imageRef scale:1.0 orientation:anOrientation];
    CFRelease(imageRef);
    
    return image;
}

+ (UIImage *) qrImageWithString: (NSString *) string size: (CGSize) destSize
{
    // Create filter
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    if (!qrFilter)
    {
        NSLog(@"Error: Could not load filter");
        return nil;
    }

    // "The inputCorrectionLevel parameter controls the amount of additional data encoded in the output image to provide error correction. Higher levels of error correction result in larger output images but allow larger areas of the code to be damaged or obscured without. There are four possible correction modes (with corresponding error resilience levels)"
    // Set correction level
    // L 7% , M 15% , Q 25% , H 30%
    [qrFilter setValue:@"H" forKey:@"inputCorrectionLevel"];
    
    // Set input text
    NSData *stringData = [string dataUsingEncoding:NSUTF8StringEncoding];
    [qrFilter setValue:stringData forKey:@"inputMessage"];

    // Retrieve output image
    CIImage *outputImage = [qrFilter valueForKey:@"outputImage"];
    
    UIImage *smallImage = [self imageWithCIImage:outputImage orientation: UIImageOrientationUp];
    
    return [self resizeImageWithoutInterpolation:smallImage size:destSize];
}
@end
