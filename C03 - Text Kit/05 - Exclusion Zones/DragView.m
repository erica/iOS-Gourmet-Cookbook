/*
 
 Erica Sadun, http://ericasadun.com
 Gourmet Recipes

 */

#import "DragView.h"

UIBezierPath *bunnyPath(CGSize destSize)
{
    UIBezierPath *shapePath = [UIBezierPath bezierPath];
    [shapePath moveToPoint: CGPointMake(392.05, 150.53)];
    [shapePath addCurveToPoint: CGPointMake(343.11, 129.56) controlPoint1: CGPointMake(379.34, 133.37) controlPoint2: CGPointMake(359, 133.37)];
    [shapePath addCurveToPoint: CGPointMake(305.61, 71.72) controlPoint1: CGPointMake(341.2, 119.39) controlPoint2: CGPointMake(316.41, 71.08)];
    [shapePath addCurveToPoint: CGPointMake(304.34, 100.96) controlPoint1: CGPointMake(294.8, 72.35) controlPoint2: CGPointMake(302.43, 79.35)];
    [shapePath addCurveToPoint: CGPointMake(283.36, 84.43) controlPoint1: CGPointMake(299.25, 95.24) controlPoint2: CGPointMake(287.81, 73.63)];
    [shapePath addCurveToPoint: CGPointMake(301.79, 154.99) controlPoint1: CGPointMake(272.42, 111.01) controlPoint2: CGPointMake(302.43, 148.63)];
    [shapePath addCurveToPoint: CGPointMake(287.17, 191.85) controlPoint1: CGPointMake(301.16, 161.34) controlPoint2: CGPointMake(299, 186.78)];
    [shapePath addCurveToPoint: CGPointMake(194.38, 221.09) controlPoint1: CGPointMake(282.72, 193.76) controlPoint2: CGPointMake(240.78, 195.66)];
    [shapePath addCurveToPoint: CGPointMake(128.27, 320.25) controlPoint1: CGPointMake(147.97, 246.51) controlPoint2: CGPointMake(138.44, 282.11)];
    [shapePath addCurveToPoint: CGPointMake(124.75, 348.92) controlPoint1: CGPointMake(125.53, 330.51) controlPoint2: CGPointMake(124.54, 340.12)];
    [shapePath addCurveToPoint: CGPointMake(118.34, 358.13) controlPoint1: CGPointMake(122.92, 350.31) controlPoint2: CGPointMake(120.74, 353.02)];
    [shapePath addCurveToPoint: CGPointMake(136.06, 388.68) controlPoint1: CGPointMake(112.42, 370.73) controlPoint2: CGPointMake(123.06, 383.91)];
    [shapePath addCurveToPoint: CGPointMake(144.8, 399.06) controlPoint1: CGPointMake(138.8, 392.96) controlPoint2: CGPointMake(141.79, 396.49)];
    [shapePath addCurveToPoint: CGPointMake(210.9, 408.6) controlPoint1: CGPointMake(158.14, 410.5) controlPoint2: CGPointMake(205.18, 406.69)];
    [shapePath addCurveToPoint: CGPointMake(240.78, 417.5) controlPoint1: CGPointMake(216.62, 410.5) controlPoint2: CGPointMake(234.41, 417.5)];
    [shapePath addCurveToPoint: CGPointMake(267.47, 411.78) controlPoint1: CGPointMake(247.13, 417.5) controlPoint2: CGPointMake(267.47, 419.4)];
    [shapePath addCurveToPoint: CGPointMake(250.3, 385.71) controlPoint1: CGPointMake(267.47, 394.61) controlPoint2: CGPointMake(250.3, 385.71)];
    [shapePath addCurveToPoint: CGPointMake(274.46, 371.73) controlPoint1: CGPointMake(250.3, 385.71) controlPoint2: CGPointMake(260.48, 379.99)];
    [shapePath addCurveToPoint: CGPointMake(302.43, 350.12) controlPoint1: CGPointMake(288.45, 363.47) controlPoint2: CGPointMake(297.34, 350.76)];
    [shapePath addCurveToPoint: CGPointMake(318.32, 389.53) controlPoint1: CGPointMake(312.22, 348.89) controlPoint2: CGPointMake(311.33, 381.9)];
    [shapePath addCurveToPoint: CGPointMake(341.84, 421.94) controlPoint1: CGPointMake(325.32, 397.15) controlPoint2: CGPointMake(332.15, 418.51)];
    [shapePath addCurveToPoint: CGPointMake(375.53, 413.68) controlPoint1: CGPointMake(349.08, 424.51) controlPoint2: CGPointMake(373.62, 421.31)];
    [shapePath addCurveToPoint: CGPointMake(367.26, 398.43) controlPoint1: CGPointMake(377.43, 406.06) controlPoint2: CGPointMake(372.35, 405.42)];
    [shapePath addCurveToPoint: CGPointMake(361.54, 352.66) controlPoint1: CGPointMake(362.18, 391.43) controlPoint2: CGPointMake(356.46, 363.47)];
    [shapePath addCurveToPoint: CGPointMake(378.07, 277.66) controlPoint1: CGPointMake(366.63, 341.86) controlPoint2: CGPointMake(376.8, 296.73)];
    [shapePath addCurveToPoint: CGPointMake(388.87, 220.45) controlPoint1: CGPointMake(379.34, 258.59) controlPoint2: CGPointMake(378.7, 245.88)];
    [shapePath addCurveToPoint: CGPointMake(411.12, 189.31) controlPoint1: CGPointMake(405.4, 214.1) controlPoint2: CGPointMake(410.48, 197.57)];
    [shapePath addCurveToPoint: CGPointMake(392.05, 150.53) controlPoint1: CGPointMake(411.76, 181.04) controlPoint2: CGPointMake(404.76, 167.7)];
    [shapePath closePath];
    
    CGRect bounds = shapePath.bounds;
    CGFloat scaleW = destSize.width / bounds.size.width;
    CGFloat scaleH = destSize.height / bounds.size.height;
    [shapePath applyTransform:CGAffineTransformMakeTranslation(-bounds.origin.x, -bounds.origin.y)];
    [shapePath applyTransform:CGAffineTransformMakeScale(scaleW, scaleH)];
    
    return shapePath;
}

@implementation DragView
{
    CGPoint previousLocation;
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.superview bringSubviewToFront:self];
    previousLocation = self.center;
}

- (void) handlePan: (UIPanGestureRecognizer *) recognizer
{
    CGPoint translation = [recognizer translationInView:self.superview];
    CGPoint destination = CGPointMake(previousLocation.x + translation.x, previousLocation.y + translation.y);
    if (CGRectContainsPoint(self.superview.bounds, destination))
        self.center = destination;
    
    if (_container && _shapePath)
    {
        UIBezierPath *p = [UIBezierPath bezierPath];
        [p appendPath:_shapePath];
        [p applyTransform:CGAffineTransformMakeTranslation(destination.x - self.bounds.size.width / 2, destination.y - self.bounds.size.height / 2)];
        _container.exclusionPaths = @[p];
    }
}

- (void) setContainer:(NSTextContainer *)container
{
    _container = container;
    if (_container && _shapePath)
    {
        UIBezierPath *p = [UIBezierPath bezierPath];
        [p appendPath:_shapePath];
        _container.exclusionPaths = @[p];
    }
}

- (instancetype) initWithFrame:(CGRect)frame
{
    if (!(self = [super initWithFrame:frame])) return self;
    
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self addGestureRecognizer:recognizer];
    
    return self;
}

+ (instancetype) instanceWithFrame: (CGRect) frame path: (UIBezierPath *) path
{
    DragView *view = [[self alloc] initWithFrame:frame];
    view.shapePath = path;
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = path.CGPath;
    view.layer.mask = maskLayer;
    return view;
}
@end
