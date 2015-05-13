/*
 
 Erica Sadun, http://ericasadun.com
 Gourmet Recipes

 */

#import <UIKit/UIKit.h>

@class URLReadyLabel;

@protocol URLResponder <NSObject>
- (BOOL) label:(URLReadyLabel *) label shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange;
@end

@interface URLReadyLabel : UILabel
@property (nonatomic, weak) id <URLResponder> urlDelegate;
- (void) outlineCharacterGlyphs;
@end
