/*
 
 Erica Sadun, http://ericasadun.com
 STACK BUTTON
 
 */

#import "StackButton.h"

#ifndef APP_TINT_COLOR
#define APP_TINT_COLOR  (^UIColor *(){UIColor *c = [[[[UIApplication sharedApplication] delegate] window] tintColor]; if (c) return c; c = [[UINavigationBar alloc] init].tintColor; if (c) return c; return [UIColor colorWithRed:0.0 green:(122.0 / 255.0) blue:1.0 alpha:1.0];}())
#endif

@implementation StackButton
{
    CAShapeLayer *borderLayer;
}

- (UIBezierPath *) pathInRect: (CGRect) rect role: (NSInteger) role
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGPoint topLeft = CGPointZero;
    CGPoint topRight = CGPointMake(rect.size.width, 0);
    CGPoint bottomLeft = CGPointMake(0, rect.size.height);
    CGPoint bottomRight = CGPointMake(rect.size.width, rect.size.height);
   
    switch (role)
    {
        case 0:
        {
            path = [UIBezierPath bezierPath];
            [path moveToPoint:bottomLeft];
            [path addLineToPoint:CGPointMake(topLeft.x, topLeft.y + _cornerRadius)];
            [path addQuadCurveToPoint:CGPointMake(topLeft.x + _cornerRadius, topLeft.y) controlPoint:topLeft];
            [path addLineToPoint:CGPointMake(topRight.x - _cornerRadius, topRight.y)];
            [path addQuadCurveToPoint:CGPointMake(topRight.x, topRight.y + _cornerRadius) controlPoint:topRight];
            [path addLineToPoint:bottomRight];
            break;
        }

        case 1:
        {
            path = [UIBezierPath bezierPath];
            [path moveToPoint:bottomLeft];
            [path addLineToPoint:topLeft];
            [path addLineToPoint:topRight];
            [path addLineToPoint:bottomRight];
            break;
        }
        case 2:
        {
            path = [UIBezierPath bezierPath];
            [path moveToPoint:topLeft];
            [path addLineToPoint:CGPointMake(bottomLeft.x, bottomLeft.y - _cornerRadius)];
            [path addQuadCurveToPoint:CGPointMake(bottomLeft.x + _cornerRadius, bottomLeft.y) controlPoint:bottomLeft];
            [path addLineToPoint:CGPointMake(bottomRight.x - _cornerRadius, bottomRight.y)];
            [path addQuadCurveToPoint:CGPointMake(bottomRight.x, bottomRight.y - _cornerRadius) controlPoint:bottomRight];
            [path addLineToPoint:topRight];
            [path closePath];
            break;
        }
        default: break;
    }
//    [path closePath]; // to demonstrate doubled lines
    return path;
}

- (void) updateLayer
{
    if (CGSizeEqualToSize(self.bounds.size, CGSizeZero)) return;
    
    UIBezierPath *path = [self pathInRect:self.frame role:_role.integerValue];
    if (_standaloneButton) [path closePath];
    UIBezierPath *closedPath = [path copy];
    [closedPath closePath];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = closedPath.CGPath;
    self.layer.mask = maskLayer;
    
    if (!borderLayer)
    {
        borderLayer = [[CAShapeLayer alloc] init];
        [self.layer addSublayer:borderLayer];
        borderLayer.fillColor = [UIColor clearColor].CGColor;
    }

    borderLayer.strokeColor = _borderColor ? _borderColor.CGColor : APP_TINT_COLOR.CGColor;
    borderLayer.lineWidth = _borderWidth * 2;
    borderLayer.path = path.CGPath;
}

- (void) observeValueForKeyPath:(NSString *)keyPath
                       ofObject:(id)object
                         change:(NSDictionary *)change
                        context:(void *)context
{
    if ([keyPath isEqualToString:@"bounds"])
        [self updateLayer];
}

- (void) setText:(NSString *)text
{
    _text = text;
    [self setTitle:text forState:UIControlStateNormal];
}

- (void) setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    [self setTitleColor:textColor forState:UIControlStateNormal];
    [self setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
}

- (void) setCornerRadius:(CGFloat)cornerRadius
{
    _cornerRadius = cornerRadius;
    [self updateLayer];
}

- (void) dealloc
{
    [self removeObserver:self forKeyPath:@"bounds"];
}

- (instancetype) initWithFrame:(CGRect)frame
{
    if (!(self = [super initWithFrame:frame])) return self;
    _cornerRadius = 16.0;
    _borderWidth = 0.25;
    self.textColor = APP_TINT_COLOR;
    [self addObserver:self forKeyPath:@"bounds" options:NSKeyValueObservingOptionNew context:NULL];
    return self;
}

+ (instancetype) topButton
{
    StackButton *button = [StackButton buttonWithType:UIButtonTypeCustom];
    button.role = @(0);
    return button;
}

+ (instancetype) centerButton
{
    StackButton *button = [StackButton buttonWithType:UIButtonTypeCustom];
    button.role = @(1);
    return button;
}

+ (instancetype) bottomButton
{
    StackButton *button = [StackButton buttonWithType:UIButtonTypeCustom];
    button.role = @(2);
    return button;
}
@end
