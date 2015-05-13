/*
 
 Erica Sadun, http://ericasadun.com
 
 */

@import UIKit;

@interface SnapZoneHandler : NSObject
@property (nonatomic) NSArray *dropZones;
+ (instancetype) handlerWithReferenceView: (UIView *) referenceView;
@end
