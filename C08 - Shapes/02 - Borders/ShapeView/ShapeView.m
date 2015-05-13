/*
 
 Erica Sadun, http://ericasadun.com
 
 */

#import "ShapeView.h"
#import "BezierMiniPack.h"

NSString *BorderLayerKey = @"BorderLayerKey";

@implementation ShapeImageView

#pragma mark - Shapes

- (CAShapeLayer *) shapeLayer
{
    CAShapeLayer *shapeLayer = (CAShapeLayer *) self.layer.mask;
    return shapeLayer;
}

- (void) removeBorderLayer
{
    CAShapeLayer *borderLayer = [self.layer valueForKey:BorderLayerKey];
    if (borderLayer)
    {
        [borderLayer removeFromSuperlayer];
        [self.layer setValue:nil forKey:BorderLayerKey];
    }
}

- (void) updateLayer
{
    if (CGSizeEqualToSize(self.bounds.size, CGSizeZero))
    {
        self.layer.mask = nil;
        return;
    }
    
    if (!_shape)
    {
        _shape = [UIBezierPath bezierPathWithRect:self.bounds];
    }
    
    // Always use a copy to minimize math errors to the original shape
    UIBezierPath *path = [_shape copy];
    FitPathToRect(path, self.bounds);
    
    // Create a mask
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = path.CGPath;
    self.layer.mask = maskLayer;
    
    // Create / Update border layer
    [self removeBorderLayer];
    CAShapeLayer *borderLayer = [CAShapeLayer new];
    borderLayer.frame = self.bounds;
    borderLayer.path = self.shapeLayer.path;
    borderLayer.anchorPoint = CGPointMake(0.5, 0.5);
    borderLayer.lineWidth = _borderWidth * 2.0;
    borderLayer.strokeColor = _borderColor.CGColor;
    borderLayer.fillColor = [UIColor clearColor].CGColor;
    [self.layer addSublayer:borderLayer];
    [self.layer setValue:borderLayer forKey:BorderLayerKey];
}

- (void) setShape:(UIBezierPath *)shape
{
    if (_shape != shape)
    {
        _shape = shape;
        [self updateLayer];
    }
}

- (void) setBorderColor: (UIColor *)borderColor
{
    if (![borderColor isEqual:_borderColor])
    {
        _borderColor = borderColor;
        [self updateLayer];
    }
}

- (void) setBorderWidth:(CGFloat)borderWidth
{
    if (borderWidth != _borderWidth)
    {
        _borderWidth = borderWidth;
        [self updateLayer];
    }
}

#pragma mark - Setup

- (void) observeValueForKeyPath:(NSString *)keyPath
                       ofObject:(id)object
                         change:(NSDictionary *)change
                        context:(void *)context
{
    if ([keyPath isEqualToString:@"bounds"])
        [self updateLayer];
}

- (void) setup
{
    // Participate in Auto Layout
    self.translatesAutoresizingMaskIntoConstraints = NO;

    // Initialize Border
    _borderColor = [UIColor blackColor];
    _borderWidth = 0.0;
    
    // Listen for bounds changes
    [self addObserver:self forKeyPath:@"bounds" options:NSKeyValueObservingOptionNew context:NULL];
}

- (instancetype) initWithFrame:(CGRect)frame
{
    if (!(self = [super initWithFrame:frame])) return self;
    [self setup];
    return self;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
    if (!(self = [super initWithCoder:aDecoder])) return self;
    [self setup];
    return self;
}

- (instancetype) initWithImage:(UIImage *)image
{
    if (!(self = [super initWithImage:image])) return self;
    [self setup];
    return self;
}

- (instancetype) initWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage
{
    if (!(self = [super initWithImage:image highlightedImage:highlightedImage])) return self;
    [self setup];
    return self;
}

#pragma mark - Cleanup

- (void) cleanup
{
    [self removeBorderLayer];
    [self removeObserver:self forKeyPath:@"bounds"];
}

- (void) removeFromSuperview
{
    // Dealloc isn't always called in time
    [self cleanup];
    [super removeFromSuperview];
}

- (void) dealloc
{
    [self cleanup];
}
@end
