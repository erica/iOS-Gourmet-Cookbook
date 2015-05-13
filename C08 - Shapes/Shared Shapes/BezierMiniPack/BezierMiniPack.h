/*
 
 Erica Sadun, http://ericasadun.com
 
 */

#import <UIKit/UIKit.h>

CGPoint RectGetCenter(CGRect rect);
CGRect RectAroundCenter(CGPoint center, CGSize size);
CGRect RectCenteredInRect(CGRect rect, CGRect mainRect);
CGPoint RectGetPointAtPercents(CGRect rect, CGFloat xPercent, CGFloat yPercent);

CGFloat AspectScaleFit(CGSize sourceSize, CGRect destRect);
CGRect RectByFittingRect(CGRect sourceRect, CGRect destinationRect);


@interface UIBezierPath (MiniPack)
- (void) applyCenteredPathTransform:(CGAffineTransform) transform;
- (void) offsetPath: (CGSize) offset;
- (void) zeroPath;
- (void) scalePath:(CGSize) scale;
- (void) movePathCenterToPoint: (CGPoint) destPoint;
- (void) fitPathToRect:(CGRect) destRect;
@end

void ApplyCenteredPathTransform(UIBezierPath *path, CGAffineTransform transform);
void ZeroPath(UIBezierPath *path);
void OffsetPath(UIBezierPath *path, CGSize offset);
void ScalePath(UIBezierPath *path, CGFloat sx, CGFloat sy);
void MovePathCenterToPoint(UIBezierPath *path, CGPoint destPoint);
void FitPathToRect(UIBezierPath *path, CGRect destRect);
