/*
 
 Erica Sadun, http://ericasadun.com
 
 */

#import "RoundedImageView.h"

@implementation RoundedImageView
+ (BOOL) requiresConstraintBasedLayout
{
    return YES;
}

- (void) updateLayer
{
    if (CGSizeEqualToSize(self.bounds.size, CGSizeZero))
        return;
    CGFloat minimum = fminf(self.bounds.size.width, self.bounds.size.height);
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(CGRectGetMidX(self.bounds) - minimum / 2.0, CGRectGetMidY(self.bounds) - minimum / 2.0, minimum, minimum)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = path.CGPath;
    self.layer.mask = maskLayer;
}

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

- (instancetype) initWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage
{
    if (!(self = [super initWithImage:image highlightedImage:highlightedImage])) return self;
    [self setup];
    return self;
}

- (instancetype) initWithImage:(UIImage *)image
{
    if (!(self = [super initWithImage:image])) return self;
    [self setup];
    return self;
}

- (instancetype) initWithFrame:(CGRect)frame
{
    return [self initWithImage:nil];
}

- (void) dealloc
{
    [self removeObserver:self forKeyPath:@"bounds"];
}
@end
