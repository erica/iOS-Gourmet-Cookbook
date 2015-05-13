/*
 
 Erica Sadun, http://ericasadun.com
 
 */


#import "DragView.h"
#import "DynamicUtilities.h"

@implementation DragView
- (id) initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame])
	{
		self.userInteractionEnabled = YES;
		UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
		self.gestureRecognizers = @[pan];
	}
	return self;
}

// Promote touched view
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self.superview bringSubviewToFront:self];
	previousLocation = self.center;
}

// Move view
- (void) handlePan: (UIPanGestureRecognizer *) uigr
{
	CGPoint translation = [uigr translationInView:self.superview];
	self.center = CGPointMake(previousLocation.x + translation.x, previousLocation.y + translation.y);
    self.tag = self.frame.origin.x * kMultiplier + self.frame.origin.y;
}
@end
