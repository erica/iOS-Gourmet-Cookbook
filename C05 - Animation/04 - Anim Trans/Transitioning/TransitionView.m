/*
 
 Erica Sadun, http://ericasadun.com
 
 */

#import "TransitionView.h"

static CIImage *GetCIImage(UIImage *image){return image.CIImage ? : [CIImage imageWithCGImage:image.CGImage];}

@implementation TransitionView
{
    CADisplayLink *link;
    CIFilter *transition;
    int transitionType;

    TransitionCompletionBlock completion;
    
    NSDate *date;
    CGFloat progress;
}

- (instancetype) initWithFrame: (CGRect) frame
{
    if (!(self = [super initWithFrame:frame])) return self;
    self.contentMode = UIViewContentModeScaleAspectFit;
    _duration = 1.0f;
    return self;
}

// CICopyMachineTransition
- (CIImage *)imageForTransitionCopyMachine: (float)t
{
    if (!transition)
    {
        transition = [CIFilter filterWithName:@"CICopyMachineTransition"];
        [transition setDefaults];
        [transition setValue: GetCIImage(_image1) forKey: @"inputImage"];
        [transition setValue: GetCIImage(_image2) forKey: @"inputTargetImage"];
        [transition setValue:@(_image1.size.width) forKey:@"inputWidth"];
    }

    CGFloat percent = _reversed ? (1.0 - t) : t;
    [transition setValue: @(percent) forKey: @"inputTime"];
    return [transition valueForKey:@"outputImage"];
}


// CIBarsSwipeTransition
- (CIImage *)imageForTransitionSwipeBars: (float) t
{
    if (!transition)
    {
        transition = [CIFilter filterWithName:@"CIBarsSwipeTransition"];
        [transition setDefaults];
        [transition setValue:GetCIImage(_image1)  forKey: @"inputImage"];
        [transition setValue: GetCIImage(_image2)  forKey: @"inputTargetImage"];
        [transition setValue:@(M_PI_4) forKey:@"inputAngle"]; // Pull down and right
    }

    CGFloat percent = _reversed ? (1.0 - t) : t;
    [transition setValue: @(percent) forKey: @"inputTime"];
    return [transition valueForKey:@"outputImage"];
}

// CIFlashTransition
- (CIImage *)imageForTransitionFlash: (float)t
{
    if (!transition)
    {
        transition = [CIFilter filterWithName:@"CIFlashTransition"];
        [transition setDefaults];
        [transition setValue: GetCIImage(_image1)  forKey: @"inputImage"];
        [transition setValue: GetCIImage(_image2)  forKey: @"inputTargetImage"];
        [transition setValue:[CIColor colorWithRed:0 green:1 blue:0] forKey:@"inputColor"];
        [transition setValue:[CIVector vectorWithX:_image1.size.width / 2 Y:_image1.size.height / 2] forKey:@"inputCenter"];
    }
    
    CGFloat percent = _reversed ? (1.0 - t) : t;
    [transition setValue: @(percent) forKey: @"inputTime"];
    return [transition valueForKey:@"outputImage"];
}

// CIModTransition
- (CIImage *)imageForTransitionMod: (float)t
{
    if (!transition)
    {
        transition = [CIFilter filterWithName:@"CIModTransition"];
        [transition setDefaults];
        [transition setValue: GetCIImage(_image1)  forKey: @"inputImage"];
        [transition setValue: GetCIImage(_image2)  forKey: @"inputTargetImage"];
        [transition setValue:[CIVector vectorWithX:_image1.size.width / 2 Y:_image1.size.height / 2] forKey:@"inputCenter"];
        [transition setValue:@(M_PI_4) forKey:@"inputAngle"];
    }
    
    CGFloat percent = _reversed ? (1.0 - t) : t;
    [transition setValue: @(percent) forKey: @"inputTime"];
    return [transition valueForKey:@"outputImage"];
}

- (CIImage *)imageForTransition: (float) t
{
    switch (transitionType)
    {
        case kCICustomTransitionCopyMachine:
            return [self imageForTransitionCopyMachine:t];
        case kCICustomTransitionSwipeBars:
            return [self imageForTransitionSwipeBars:t];
        case kCICustomTransitionFlash:
            return [self imageForTransitionFlash:t];
        case kCICustomTransitionMod:
            return [self imageForTransitionMod:t];
        default:
            return [self imageForTransitionCopyMachine:t];
            
    }
}

- (void) drawRect: (CGRect) rect
{
    CIImage *image = [self imageForTransition:progress];
    static CIContext *ciContext = nil;
    if (!ciContext) ciContext = [CIContext contextWithOptions:nil];
    CGImageRef imageRef = [ciContext createCGImage:image fromRect:image.extent];
    
    [[UIImage imageWithCGImage:imageRef] drawInRect:rect];
    CGImageRelease(imageRef);
}

// Progress through the transition
- (void) transition
{
    NSTimeInterval timePassed = [[NSDate date] timeIntervalSinceDate:date];
    progress = fminf(1.0f, timePassed / _duration);
    [self setNeedsDisplay];
    
    if (progress >= 1.0f)
    {
        // Done
        [link invalidate];
        if (completion) completion();
    }
}

- (void) transition: (CustomCITransitionType) theType completion:(TransitionCompletionBlock) theCompletion;
{
    if (!CGSizeEqualToSize(_image1.size, _image2.size))
    {
        NSLog(@"Error: Image sizes must be identical");
        return;
    }
    
    completion = theCompletion;
    transitionType = theType;
    transition = nil;
    
    date = [NSDate date];
    progress = 0.0;
    link = [CADisplayLink displayLinkWithTarget:self selector:@selector(transition)];
    [link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}
@end
