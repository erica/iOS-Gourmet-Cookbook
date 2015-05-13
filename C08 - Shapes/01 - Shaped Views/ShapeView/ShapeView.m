/*
 
 Erica Sadun, http://ericasadun.com
 
 */

#import "ShapeView.h"
#import "BezierMiniPack.h"

@implementation ShapeImageView

#pragma mark - Shapes

- (void) updateLayer
{
    if ((CGSizeEqualToSize(self.bounds.size, CGSizeZero)) || !self.shape)
    {
        self.layer.mask = nil;
        return;
    }
    
    // Always use a copy to minimize math errors to the original shape
    UIBezierPath *path = [_shape copy];
    FitPathToRect(path, self.bounds);
    
    // Create a mask
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = path.CGPath;
    self.layer.mask = maskLayer;
}

- (void) setShape:(UIBezierPath *)shape
{
    if (_shape != shape)
    {
        _shape = shape;
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
