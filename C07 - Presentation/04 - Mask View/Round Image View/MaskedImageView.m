/*
 
 Erica Sadun, http://ericasadun.com
 
 */

#import "MaskedImageView.h"

@interface MaskedImageView ()
@property (nonatomic, readonly) UIImageView *internalMaskView;
@end

@implementation MaskedImageView

#pragma mark - Bounds observing

- (void) updateMask
{
    self.internalMaskView.frame = self.bounds;
}

- (void) observeValueForKeyPath:(NSString *)keyPath
                       ofObject:(id)object
                         change:(NSDictionary *)change
                        context:(void *)context
{
    if ([keyPath isEqualToString:@"bounds"])
        [self updateMask];
}


- (void) dealloc
{
    [self removeObserver:self forKeyPath:@"bounds"];
}

#pragma mark - Hide mask view from external consumption

- (void) setMaskView:(UIView *)maskView
{
    // no op.
    NSLog(@"Mask view is not externally settable");
}

- (UIView *) maskView
{
    // no op.
    NSLog(@"Mask view is not externally settable");
    return nil;
}

// Provide internal access only
- (UIImageView *) internalMaskView
{
    return (UIImageView *) super.maskView;
}

- (void) setMaskImage:(UIImage *)maskImage
{
    if (!maskImage)
    {
        super.maskView = nil;
        return;
    }
    
    if (!self.internalMaskView)
    {
        UIImageView *imageView = [UIImageView new];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        super.maskView = imageView;
    }
    self.internalMaskView.image = maskImage;
    [self updateMask];
}

- (UIImage *) maskImage
{
    return self.internalMaskView.image;
}

#pragma mark - Initializers

- (void) setup
{
    // Default content mode is aspect fit
    self.contentMode = UIViewContentModeScaleAspectFit;
    
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
@end
