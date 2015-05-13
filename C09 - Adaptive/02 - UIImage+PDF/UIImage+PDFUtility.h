/*
 
 Erica Sadun, http://ericasadun.com
 Gourmet Recipes

 */

#import <UIKit/UIKit.h>

@interface UIImage_PDFUtility : NSObject
UIImage *ImageFromPDFFile(NSString *pdfPath, CGSize targetSize);
UIImage *ImageFromPDFFileWithWidth(NSString *pdfPath, CGFloat targetWidth);
UIImage *ImageFromPDFFileWithHeight(NSString *pdfPath, CGFloat targetHeight);
@end
