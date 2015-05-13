/*
 
 Erica Sadun, http://ericasadun.com
 
 */

#import <Foundation/Foundation.h>

CGPoint RectGetCenter(CGRect rect);
CGFloat AspectScaleFit(CGSize sourceSize, CGRect destRect);
CGRect RectAroundCenter(CGPoint center, CGSize size);
CGRect RectCenteredInRect(CGRect rect, CGRect mainRect);
CGRect RectByFittingRect(CGRect sourceRect, CGRect destinationRect);

void ApplyCenteredPathTransform(UIBezierPath *path, CGAffineTransform transform);
void OffsetPath(UIBezierPath *path, CGSize offset);
void ScalePath(UIBezierPath *path, CGFloat sx, CGFloat sy);

void MovePathCenterToPoint(UIBezierPath *path, CGPoint destPoint);
void FitPathToRect(UIBezierPath *path, CGRect destRect);
