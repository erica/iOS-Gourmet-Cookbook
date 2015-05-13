/*
 
 Erica Sadun, http://ericasadun.com
 
 */

#import <Foundation/Foundation.h>

UIImage *BlockStringImage(NSString *string, float size);

CGPoint RectGetCenter(CGRect rect);
CGFloat AspectScaleFit(CGSize sourceSize, CGRect destRect);
CGRect RectAroundCenter(CGPoint center, CGSize size);
CGRect RectCenteredInRect(CGRect rect, CGRect mainRect);
CGRect RectByFittingRect(CGRect sourceRect, CGRect destinationRect);
CGPoint RectGetPointAtPercents(CGRect rect, CGFloat xPercent, CGFloat yPercent);

void ApplyCenteredPathTransform(UIBezierPath *path, CGAffineTransform transform);
void OffsetPath(UIBezierPath *path, CGSize offset);
void ScalePath(UIBezierPath *path, CGFloat sx, CGFloat sy);

void MovePathCenterToPoint(UIBezierPath *path, CGPoint destPoint);
void FitPathToRect(UIBezierPath *path, CGRect destRect);
NSString *TransformStringRepresentation(CGAffineTransform t);

CGFloat EaseIn(CGFloat currentTime, int factor);
CGFloat EaseOut(CGFloat currentTime, int factor);
CGFloat Tween(CGFloat v1, CGFloat v2, CGFloat percent);
