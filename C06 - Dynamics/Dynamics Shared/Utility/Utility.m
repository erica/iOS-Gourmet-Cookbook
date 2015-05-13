/*
 
 Erica Sadun, http://ericasadun.com
 
 */

#import "Utility.h"

UIImage *BlockStringImage(NSString *string, float size)
{
    NSAttributedString *s = [[NSAttributedString alloc] initWithString:string attributes:@{NSFontAttributeName : [UIFont fontWithName:@"Georgia" size:size]}];
    CGSize stringSize = s.size;
    stringSize.width += 28;
    stringSize.height += 28;
    CGRect borderRect = (CGRect){.size = stringSize};
    CGRect outerRect = CGRectInset(borderRect, 4, 4);
    CGRect baseRect = CGRectInset(outerRect, 10, 10);
    
    // Start drawing
    UIGraphicsBeginImageContextWithOptions(borderRect.size, NO, 0);
    
    // Draw backdrop
    [[UIColor blackColor] set];
    UIRectFill(borderRect);
    [[UIColor whiteColor] set];
    UIRectFill(outerRect);
    
    // Draw the string in black
    [s drawInRect:baseRect];
    
    // Return new image
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
    
}

CGPoint RectGetCenter(CGRect rect)
{
    return CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
}

CGFloat AspectScaleFit(CGSize sourceSize, CGRect destRect)
{
    CGSize destSize = destRect.size;
    CGFloat scaleW = destSize.width / sourceSize.width;
    CGFloat scaleH = destSize.height / sourceSize.height;
    return fmin(scaleW, scaleH);
}

CGRect RectAroundCenter(CGPoint center, CGSize size)
{
    CGFloat halfWidth = size.width / 2.0f;
    CGFloat halfHeight = size.height / 2.0f;
    
    return CGRectMake(center.x - halfWidth, center.y - halfHeight, size.width, size.height);
}

CGRect RectCenteredInRect(CGRect rect, CGRect mainRect)
{
    CGFloat dx = CGRectGetMidX(mainRect)-CGRectGetMidX(rect);
    CGFloat dy = CGRectGetMidY(mainRect)-CGRectGetMidY(rect);
    return CGRectOffset(rect, dx, dy);
}

CGRect RectByFittingRect(CGRect sourceRect, CGRect destinationRect)
{
    CGFloat aspect = AspectScaleFit(sourceRect.size, destinationRect);
    CGSize targetSize = CGSizeMake(sourceRect.size.width * aspect, sourceRect.size.height * aspect);
    return RectAroundCenter(RectGetCenter(destinationRect), targetSize);
}

CGPoint RectGetPointAtPercents(CGRect rect, CGFloat xPercent, CGFloat yPercent)
{
    CGFloat dx = xPercent * rect.size.width;
    CGFloat dy = yPercent * rect.size.height;
    return CGPointMake(rect.origin.x + dx, rect.origin.y + dy);
}

void ApplyCenteredPathTransform(UIBezierPath *path, CGAffineTransform transform)
{
    CGPoint center = RectGetCenter(path.bounds);
    CGAffineTransform t = CGAffineTransformIdentity;
    t = CGAffineTransformTranslate(t, center.x, center.y);
    t = CGAffineTransformConcat(transform, t);
    t = CGAffineTransformTranslate(t, -center.x, -center.y);
    [path applyTransform:t];
}

void OffsetPath(UIBezierPath *path, CGSize offset)
{
    CGAffineTransform t = CGAffineTransformMakeTranslation(offset.width, offset.height);
    ApplyCenteredPathTransform(path, t);
}

void ScalePath(UIBezierPath *path, CGFloat sx, CGFloat sy)
{
    CGAffineTransform t = CGAffineTransformMakeScale(sx, sy);
    ApplyCenteredPathTransform(path, t);
}

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

void FitPathToRect(UIBezierPath *path, CGRect destRect)
{
    CGRect bounds = path.bounds;
    CGRect fitRect = RectByFittingRect(bounds, destRect);
    CGFloat scale = AspectScaleFit(bounds.size, destRect);
    
    CGPoint newCenter = RectGetCenter(fitRect);
    MovePathCenterToPoint(path, newCenter);
    ScalePath(path, scale, scale);
}

/*
 
 ⎾            ⏋
 ⎹  a   b   0 ⎹
 ⎹  c   d   0 ⎹
 ⎹  tx  ty  1 ⎹
 ⎿            ⏌
 
 */

// Degrees from radians
CGFloat DegreesFromRadians(CGFloat radians)
{
    return radians * 180.0f / M_PI;
}

// Radians from degrees
CGFloat RadiansFromDegrees(CGFloat degrees)
{
    return degrees * M_PI / 180.0f;
}

// Extract the x scale from transform
CGFloat TransformGetXScale(CGAffineTransform t)
{
    return sqrt(t.a * t.a + t.c * t.c);
}

// Extract the y scale from transform
CGFloat TransformGetYScale(CGAffineTransform t)
{
    return sqrt(t.b * t.b + t.d * t.d);
}

CGSize TransformGetScale(CGAffineTransform t)
{
    CGFloat x = TransformGetXScale(t);
    CGFloat y = TransformGetYScale(t);
    return CGSizeMake(x, y);
}

CGFloat TransformGetRotation(CGAffineTransform t)
{
    return atan2f(t.b, t.a);
}


CGAffineTransform TransformMake(CGFloat xScale, CGFloat yScale, CGFloat theta, CGFloat tx, CGFloat ty)
{
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    transform.a = xScale * cos(theta);
    transform.b = yScale * sin(theta);
    transform.c = xScale * -sin(theta);
    transform.d = yScale * cos(theta);
    transform.tx = tx;
    transform.ty = ty;
    
    return transform;
}

void TransformGetProperties(CGAffineTransform t, CGFloat *xScale, CGFloat *yScale, CGFloat *theta, CGFloat *tx, CGFloat *ty)
{
    if (tx)       *tx = t.tx;
    if (ty)       *ty = t.ty;
    if (xScale)   *xScale = TransformGetXScale(t);
    if (yScale)   *yScale = TransformGetYScale(t);
    if (theta)    *theta = TransformGetRotation(t);
}

CGAffineTransform TransformSetScale(CGAffineTransform t, CGSize scale)
{
    CGFloat r = TransformGetRotation(t);
    return TransformMake(scale.width, scale.height, r, t.tx, t.ty);
}

CGAffineTransform TransformSetRotation(CGAffineTransform t, CGFloat theta)
{
    CGFloat sx = TransformGetXScale(t);
    CGFloat sy = TransformGetYScale(t);
    return TransformMake(sx, sy, theta, t.tx, t.ty);
}

NSString *TransformStringRepresentation(CGAffineTransform t)
{
    CGFloat r = TransformGetRotation(t);
    CGFloat d = DegreesFromRadians(r);
    CGFloat sx = TransformGetXScale(t);
    CGFloat sy = TransformGetYScale(t);
    
    return [NSString stringWithFormat:
            @"Theta: {%f radians, %f°} Scale: {%f, %f} Translation: {%f, %f}",
            r, d, sx, sy, t.tx, t.ty];
}

CGFloat Tween(CGFloat v1, CGFloat v2, CGFloat percent)
{
    return v1 * (1.0 - percent) + v2 * percent;
}

CGFloat EaseIn(CGFloat currentTime, int factor)
{
    return powf(currentTime, factor);
}

CGFloat EaseOut(CGFloat currentTime, int factor)
{
    return 1 - powf((1 - currentTime), factor);
}
