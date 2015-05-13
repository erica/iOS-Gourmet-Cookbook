/*
 
 Erica Sadun, http://ericasadun.com
 
 */

#import "BezierMiniPack.h"

// Return a rectangle's center point
CGPoint RectGetCenter(CGRect rect)
{
    return CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
}

// Construct a rectangle around a center point to a given size
CGRect RectAroundCenter(CGPoint center, CGSize size)
{
    CGFloat halfWidth = size.width / 2.0f;
    CGFloat halfHeight = size.height / 2.0f;
    
    return CGRectMake(center.x - halfWidth, center.y - halfHeight, size.width, size.height);
}

// Center one rectangle within another
CGRect RectCenteredInRect(CGRect rect, CGRect mainRect)
{
    CGFloat dx = CGRectGetMidX(mainRect)-CGRectGetMidX(rect);
    CGFloat dy = CGRectGetMidY(mainRect)-CGRectGetMidY(rect);
    return CGRectOffset(rect, dx, dy);
}

// Return a point in a rectangle's coordinate space based on percent travel in X and Y
CGPoint RectGetPointAtPercents(CGRect rect, CGFloat xPercent, CGFloat yPercent)
{
    CGFloat dx = xPercent * rect.size.width;
    CGFloat dy = yPercent * rect.size.height;
    return CGPointMake(rect.origin.x + dx, rect.origin.y + dy);
}

// Determine the scale factor to fit a size within a rectangle
CGFloat AspectScaleFit(CGSize sourceSize, CGRect destRect)
{
    CGSize destSize = destRect.size;
    CGFloat scaleW = destSize.width / sourceSize.width;
    CGFloat scaleH = destSize.height / sourceSize.height;
    return fmin(scaleW, scaleH);
}

// Fit a rect into another rect, centering it in the second rect
// and using the first rectangle's aspect
CGRect RectByFittingRect(CGRect sourceRect, CGRect destinationRect)
{
    CGFloat aspect = AspectScaleFit(sourceRect.size, destinationRect);
    CGSize targetSize = CGSizeMake(sourceRect.size.width * aspect, sourceRect.size.height * aspect);
    return RectAroundCenter(RectGetCenter(destinationRect), targetSize);
}

@implementation UIBezierPath (MiniPack)
// Apply a transform with respect to a path's center point
- (void) applyCenteredPathTransform:(CGAffineTransform) transform
{
    CGPoint center = RectGetCenter(self.bounds);
    CGAffineTransform t = CGAffineTransformIdentity;
    
    // Establish center as origin
    t = CGAffineTransformTranslate(t, center.x, center.y);
    
    // Apply transform
    t = CGAffineTransformConcat(transform, t);
    
    // Restore original origin
    t = CGAffineTransformTranslate(t, -center.x, -center.y);
    
    [self applyTransform:t];
}

// Offset path
- (void) offsetPath: (CGSize) offset
{
    CGAffineTransform t = CGAffineTransformMakeTranslation(offset.width, offset.height);
    [self applyCenteredPathTransform:t];
}

// Align path to zero origin
- (void) zeroPath
{
    CGPoint point = self.bounds.origin;
    [self offsetPath:CGSizeMake(-point.x, -point.y)];
}

// Scale path
- (void) scalePath:(CGSize) scale
{
    CGAffineTransform t = CGAffineTransformMakeScale(scale.width, scale.height);
    [self applyCenteredPathTransform:t];
}

// Recenter path
- (void) movePathCenterToPoint: (CGPoint) destPoint
{
    CGRect bounds = self.bounds;
    CGPoint p1 = bounds.origin;
    CGPoint p2 = destPoint;
    CGSize vector = CGSizeMake(p2.x - p1.x, p2.y - p1.y);
    vector.width -= bounds.size.width / 2.0f;
    vector.height -= bounds.size.height / 2.0f;
    [self offsetPath:vector];
}

// Fit and center a path within a rectangle
- (void) fitPathToRect:(CGRect) destRect
{
    CGRect bounds = self.bounds;
    CGRect fitRect = RectByFittingRect(bounds, destRect);
    CGFloat scale = AspectScaleFit(bounds.size, destRect);
    
    CGPoint newCenter = RectGetCenter(fitRect);
    [self movePathCenterToPoint:newCenter];
    [self scalePath:CGSizeMake(scale, scale)];
}
@end

// Apply a transform with respect to a path's center point
void ApplyCenteredPathTransform(UIBezierPath *path, CGAffineTransform transform)
{
    CGPoint center = RectGetCenter(path.bounds);
    CGAffineTransform t = CGAffineTransformIdentity;
    
    // Establish center as origin
    t = CGAffineTransformTranslate(t, center.x, center.y);
    
    // Apply transform
    t = CGAffineTransformConcat(transform, t);
    
    // Restore original origin
    t = CGAffineTransformTranslate(t, -center.x, -center.y);
    
    [path applyTransform:t];
}

// Offset a path
void OffsetPath(UIBezierPath *path, CGSize offset)
{
    CGAffineTransform t = CGAffineTransformMakeTranslation(offset.width, offset.height);
    ApplyCenteredPathTransform(path, t);
}

void ZeroPath(UIBezierPath *path)
{
    CGPoint point = path.bounds.origin;
    OffsetPath(path, CGSizeMake(-point.x, -point.y));
}

// Scale a path
void ScalePath(UIBezierPath *path, CGFloat sx, CGFloat sy)
{
    CGAffineTransform t = CGAffineTransformMakeScale(sx, sy);
    ApplyCenteredPathTransform(path, t);
}

// Move a path's center to a given point
void MovePathCenterToPoint(UIBezierPath *path, CGPoint destPoint)
{
    CGRect bounds = path.bounds;
    CGPoint p1 = bounds.origin;
    CGPoint p2 = destPoint;
    CGSize vector = CGSizeMake(p2.x - p1.x, p2.y - p1.y);
    vector.width -= bounds.size.width / 2.0f;
    vector.height -= bounds.size.height / 2.0f;
    OffsetPath(path, vector);
}

// Fit and center a path within a rectangle
void FitPathToRect(UIBezierPath *path, CGRect destRect)
{
    CGRect bounds = path.bounds;
    CGRect fitRect = RectByFittingRect(bounds, destRect);
    CGFloat scale = AspectScaleFit(bounds.size, destRect);
    
    CGPoint newCenter = RectGetCenter(fitRect);
    MovePathCenterToPoint(path, newCenter);
    ScalePath(path, scale, scale);
}