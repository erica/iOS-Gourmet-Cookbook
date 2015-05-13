/*
 
 Erica Sadun, http://ericasadun.com
 
 */

#import "CustomFlowLayout.h"
#import "Essentials.h"

@compatibility_alias BehaviorClass UIDynamicItemBehavior;

@interface CustomFlowLayout() <UICollectionViewDelegate>
@property (nonatomic) UIDynamicAnimator *animator;
@property (nonatomic) UIDynamicItemBehavior *spinner;
@end


@implementation CustomFlowLayout
{
    CGFloat previousScrollViewXOffset;
    CGFloat scrollSpeed;
    BOOL setupDelegate;
}

- (instancetype) initWithItemSize: (CGSize) size
{
    if (!(self = [super init])) return self;
    _animator = [[UIDynamicAnimator alloc] initWithCollectionViewLayout:self];
    _spinner = [[UIDynamicItemBehavior alloc] init];
    _spinner.allowsRotation = YES;
    [_animator addBehavior:_spinner];
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.itemSize = size;
    return self;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    scrollSpeed = scrollView.contentOffset.x - previousScrollViewXOffset;
    previousScrollViewXOffset = scrollView.contentOffset.x;
}

- (void) prepareLayout
{
    [super prepareLayout];
    
    // The collection view hasn't been etablished in init, so catch it here.
    if (!setupDelegate)
    {
        setupDelegate = YES;
        self.collectionView.delegate = self;
    }
    
    // Retrieve on-screen items
    CGRect currentRect = self.collectionView.bounds;
    currentRect.size = self.collectionView.frame.size;
    NSArray *items = [super layoutAttributesForElementsInRect:currentRect];

    // Clean up any item that's now offscreen
    NSArray *itemPaths = [items valueForKey:@"indexPath"];
    for (UICollectionViewLayoutAttributes *item in _spinner.items)
    {
        if (![itemPaths containsObject:item.indexPath])
            [_spinner removeItem:item];
    }

    // Add all on-screen items
    NSArray *spinnerPaths = [_spinner.items valueForKey:@"indexPath"];
    for (UICollectionViewLayoutAttributes *item in items)
    {
        if (![spinnerPaths containsObject:item.indexPath])
            [_spinner addItem:item];
    }

    // Add impulses
    CGFloat impulse = (scrollSpeed / self.collectionView.frame.size.width) * M_PI_4 / 4;
    for (UICollectionViewLayoutAttributes *item in _spinner.items)
    {
        CGAffineTransform t = item.transform;
        CGFloat rotation = atan2f(t.b, t.a);
        if (fabs(rotation) > M_PI / 32) impulse = - rotation * 0.01;
        [_spinner addAngularVelocity:impulse forItem:item];
    }
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return [_animator itemsInRect:rect];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *dynamicLayoutAttributes = [_animator layoutAttributesForCellAtIndexPath:indexPath];
    return dynamicLayoutAttributes ? [_animator layoutAttributesForCellAtIndexPath:indexPath] : [super layoutAttributesForItemAtIndexPath:indexPath];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}
@end
