/*
 
 Erica Sadun, http://ericasadun.com
 Gourmet Recipes

 */

#import "URLReadyLabel.h"

@implementation URLReadyLabel
{
    NSTextStorage *textStorage;
    NSLayoutManager *layoutManager;
    NSTextContainer *container;
    NSURL *currentURL;
}

#pragma mark - Text Kit coordination

- (void) establishTextKitElements
{
    // Text storage and Layout Manager
    textStorage = [[NSTextStorage alloc] initWithAttributedString:self.attributedText];
    layoutManager = [NSLayoutManager new];
    [textStorage addLayoutManager:layoutManager];
    
    // Container
    container = [[NSTextContainer alloc] initWithSize:self.bounds.size];
    container.maximumNumberOfLines = self.numberOfLines;
    container.lineBreakMode = self.lineBreakMode;
    [layoutManager addTextContainer:container];
}

- (void) setText:(NSString *)text
{
    if (!textStorage) [self establishTextKitElements];
    [super setText:text];
    [textStorage setAttributedString:self.attributedText];
}

- (void) setAttributedText:(NSAttributedString *)attributedText
{
    if (!textStorage) [self establishTextKitElements];
    [super setAttributedText:attributedText];
    [textStorage setAttributedString:self.attributedText];
}


- (void) setNumberOfLines:(NSInteger)numberOfLines
{
    if (!textStorage) [self establishTextKitElements];
    [super setNumberOfLines:numberOfLines];
    container.maximumNumberOfLines = numberOfLines;
}

- (void) setLineBreakMode:(NSLineBreakMode)lineBreakMode
{
    if (!textStorage) [self establishTextKitElements];
    [super setLineBreakMode:lineBreakMode];
    container.lineBreakMode = lineBreakMode;
}

#pragma mark - Geometry

// Return unified bounds of all glyphs
- (CGRect) glyphBounds
{
    container.size = self.bounds.size;
    return [layoutManager boundingRectForGlyphRange:NSMakeRange(0, layoutManager.numberOfGlyphs) inTextContainer:container];
}

// Find half difference between view bounds and glyph bounds
// This assumes label vertical centering

- (CGFloat) verticalLayoutOffset
{
    CGRect glyphBounds = [self glyphBounds];
    return (self.bounds.size.height - glyphBounds.size.height) / 2;
}

- (CGFloat) horizontalLayoutOffset
{
    CGRect glyphBounds = [self glyphBounds];
    return -glyphBounds.origin.x;
}

// Adjust touch points to container
- (CGPoint) viewPointInLayoutCoordinates: (CGPoint) point
{
    CGRect glyphBounds = [self glyphBounds];
    CGFloat layoutOffset = [self verticalLayoutOffset];
    
    CGPoint adjustedPoint = CGPointMake(point.x + glyphBounds.origin.x, point.y - layoutOffset);
    return adjustedPoint;
}

#pragma mark - Visualization
- (void) outlineCharacterGlyphs
{
    if (!layoutManager) [self establishTextKitElements];
    for (UIView *view in self.subviews)
    {
        if (view.tag == 999)
            [view removeFromSuperview];
    }
    
    CGFloat dx = [self horizontalLayoutOffset];
    CGFloat dy = [self verticalLayoutOffset];
    for (int i = 0; i < layoutManager.numberOfGlyphs; i++)
    {
        CGRect rect = [layoutManager boundingRectForGlyphRange:NSMakeRange(i, 1) inTextContainer:container];
        rect = CGRectOffset(rect, dx, dy);
        UIView *view = [[UIView alloc] initWithFrame:rect];
        view.tag = 999;
        view.layer.borderColor = [UIColor blackColor].CGColor;
        view.layer.borderWidth = 0.5;
        [self addSubview:view];
    }
}

#pragma mark - Glyph and Character lookup

// Find glyph match
- (NSUInteger) glyphIndexAtPoint: (CGPoint) point
{
    CGPoint adjustedPoint = [self viewPointInLayoutCoordinates:point];
    return [layoutManager glyphIndexForPoint:adjustedPoint inTextContainer:container];
}

// Find glyph and convert to character
- (NSUInteger) characterIndexAtPoint: (CGPoint) point
{
    NSUInteger glyphIndex = [self glyphIndexAtPoint:point];
    if (glyphIndex == NSNotFound)
        return NSNotFound;
    return [layoutManager characterIndexForGlyphAtIndex:glyphIndex];
}

// Find URL at point
- (NSURL *) urlForPoint: (CGPoint) testPoint index: (NSUInteger *) index range: (NSRange *) range
{
    if (!textStorage) [self establishTextKitElements];
    
    NSUInteger characterIndex = [self characterIndexAtPoint:testPoint];
    if (index) *index = characterIndex;
    
    if (characterIndex == NSNotFound) return nil;
    
    NSRange r;
    NSDictionary *attributeDictionary = [self.attributedText attributesAtIndex:characterIndex effectiveRange:&r];
    if (range) *range = r;
    
    return attributeDictionary[NSLinkAttributeName];
}

#pragma mark - Stylizing

// Highlight matching URLs
- (void) highlight: (BOOL) shouldHighlight forURL: (NSURL *) comparisonURL atIndex: (NSUInteger) index
{
    NSMutableAttributedString *string = [self.attributedText mutableCopy];
    [string addAttribute:NSBackgroundColorAttributeName value:[UIColor clearColor] range:NSMakeRange(0, string.length)];
    
    if (shouldHighlight)
    {
        NSRange range;
        NSURL *url = [self.attributedText attribute:NSLinkAttributeName atIndex:index effectiveRange:&range];
        if ([url isEqual:comparisonURL])
            [string addAttribute:NSBackgroundColorAttributeName value:[[UIColor grayColor] colorWithAlphaComponent:0.3f] range:range];
    }
    
    self.attributedText = string;
}

#pragma mark - Touch Tracking

// Only start highlighting if touch is on URL
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!layoutManager) [self establishTextKitElements];
    
    NSUInteger index;
    NSRange range;
    
    // Find URL at point
    CGPoint point = [touches.anyObject locationInView:self];
    NSURL *url = [self urlForPoint:point index:&index range:&range];
    
    // Respond to this URL? If so, highlight
    if ((url && _urlDelegate && [_urlDelegate label:self shouldInteractWithURL:url inRange:range]) ||
        (url && !_urlDelegate))
    {
        currentURL = url;
        [self highlight:YES forURL:url atIndex:index];
    }
}

// Continue isTracking by highlighting only when over URL
- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!currentURL)
        return;
    
    NSUInteger index;
    NSRange range;
    
    // Find URL at point
    CGPoint point = [touches.anyObject locationInView:self];
    NSURL *url = [self urlForPoint:point index:&index range:&range];
    
    // Check whether to remove the highlight
    BOOL highlight = YES;
    if (!url) highlight = NO;
    if (![url isEqual:currentURL]) highlight = NO;
   
    // Update highlight
    [self highlight:highlight forURL:url atIndex:index];
}

// Must end over the URL to link
- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!currentURL) return;

    NSUInteger index;
    NSRange range;
    
    // Fetch URL at point
    CGPoint point = [touches.anyObject locationInView:self];
    NSURL *url = [self urlForPoint:point index:&index range:&range];

    // Remove highlight as touch is done
    [self highlight:NO forURL:nil atIndex:index];
    
    // Check for URL match
    if (!url || ![url isEqual:currentURL])
    {
        currentURL = nil;
        return;
    }
    
    // Open the URL
    currentURL = nil;
    [[UIApplication sharedApplication] openURL:url];
}
@end

