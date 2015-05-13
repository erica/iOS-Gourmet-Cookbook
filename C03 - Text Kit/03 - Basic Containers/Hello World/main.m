/*
 
 Erica Sadun, http://ericasadun.com
 Gourmet Recipes
 
 */

@import UIKit;
#import "Essentials.h"

@interface TestBedViewController : UIViewController
@end

@implementation TestBedViewController
{
    UITextView *textViewLeft, *textViewRight;
    NSTextStorage *textStorage;
    NSLayoutManager *layoutManager;
}

// Return an inverted path
UIBezierPath *InversePathInRect(UIBezierPath *sourcePath, CGRect rect)
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path appendPath:sourcePath];
    [path appendPath:[UIBezierPath bezierPathWithRect:rect]];
    path.usesEvenOddFillRule = YES;
    return path;
}

// Outline all the characters in the right container
- (void) outlineCharacterGlyphs
{
    UIView *taggedView;
    while ((taggedView = [self.view viewWithTag:999]))
        [taggedView removeFromSuperview];
    
    CGFloat dY = textViewRight.bounds.size.height - textViewRight.textContainer.size.height;
    
    // Outline each glyph
    for (int i = 0; i < layoutManager.numberOfGlyphs; i++)
    {
        CGRect glyphRect = [layoutManager boundingRectForGlyphRange:NSMakeRange(i, 1) inTextContainer:textViewRight.textContainer];
        if (CGRectEqualToRect(glyphRect, CGRectZero)) continue;
        
        UIView *v = [[UIView alloc] initWithFrame:CGRectOffset(glyphRect, 0, dY / 2)];
        v.layer.borderColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f].CGColor;
        v.layer.borderWidth = 0.5;
        v.tag = 999;
        [textViewRight addSubview:v];
    }
}

- (void) doit: (UIBarButtonItem *) bbi
{
    // reset everything
    textViewRight.textContainer.exclusionPaths = @[];
    textViewLeft.textContainer.exclusionPaths = @[];
    textViewRight.textContainerInset = UIEdgeInsetsZero;
    textViewLeft.textContainerInset = UIEdgeInsetsZero;
    UIView *taggedView;
    while ((taggedView = [self.view viewWithTag:999]))
        [taggedView removeFromSuperview];
    
    NSInteger index = [self.navigationItem.rightBarButtonItems indexOfObject:bbi];
    switch (index)
    {
        case 0:
            break;
        case 1:
            textViewLeft.textContainerInset = UIEdgeInsetsMake(50, 20, 50, 20);
            break;
        case 2:
        {
            CGRect destination = CGRectInset(textViewRight.bounds, 20, 20);
            UIBezierPath *exclusion = InversePathInRect([UIBezierPath bezierPathWithOvalInRect:destination], textViewRight.bounds);
            textViewRight.textContainer.exclusionPaths = @[exclusion];
            break;
        }
        case 3:
        {
            CGRect destination = CGRectInset(textViewRight.bounds, 20, 20);
            UIBezierPath *exclusion = [UIBezierPath bezierPathWithOvalInRect:destination];
            textViewRight.textContainer.exclusionPaths = @[exclusion];
            break;
        }
        case 4:
            [self outlineCharacterGlyphs];
        default:
            break;
    }
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.extendLayoutUnderBars = NO;
    
    self.navigationItem.rightBarButtonItems =
    @[
      BARBUTTON(@"Default", @selector(doit:)),
      BARBUTTON(@"Inset", @selector(doit:)),
      BARBUTTON(@"Exclusion", @selector(doit:)),
      BARBUTTON(@"Inverse", @selector(doit:)),
      BARBUTTON(@"Outline", @selector(doit:)),
      ];

    // You need fresh containers for this. If you use the built-in ones that are automatically assigned their own layout manager, things will break.
    textViewLeft = [[UITextView alloc] initWithFrame:CGRectZero textContainer:[NSTextContainer new]];
    textViewRight = [[UITextView alloc] initWithFrame:CGRectZero textContainer:[NSTextContainer new]];
    textViewLeft.editable = NO;
    textViewRight.editable = NO;
    
    // Prevent scrolling to enable proper text continuation
    textViewLeft.scrollEnabled = NO;
    textViewRight.scrollEnabled = NO;

    // Layout two columns
    PlaceView(self, textViewLeft, @"x-", 8, 8, 1000);
    PlaceView(self, textViewRight, @"x-", 8, 8, 1000);
    ConstrainViews(1000, @"H:|-[textViewLeft(==textViewRight)]-40-[textViewRight]-|", textViewLeft, textViewRight);
    
    // Build the text storage
    // 💬 👑 👍!
    NSString *string = @"Why, man, he doth bestride the narrow world Like a Colossus, and we petty men Walk under his huge legs and peep about To find ourselves dishonourable graves. Men at some time are masters of their fates: The fault, dear Brutus, is not in our stars, But in ourselves, that we are underlings. Brutus and Caesar: what should be in that 'Caesar'? Why should that name be sounded more than yours? Write them together, yours is as fair a name;  Sound them, it doth become the mouth as well; Weigh them, it is as heavy; conjure with 'em, Brutus will start a spirit as soon as Caesar. Now, in the names of all the gods at once, Upon what meat doth this our Caesar feed,  That he is grown so great? Age, thou art shamed! Rome, thou hast lost the breed of noble bloods! When went there by an age, since the great flood, But it was famed with more than with one man? When could they say till now, that talk'd of Rome, That her wide walls encompass'd but one man? Now is it Rome indeed and room enough, When there is in it but one only man. O, you and I have heard our fathers say, There was a Brutus once that would have brook'd  The eternal devil to keep his state in Rome As easily as a king.";
    NSMutableAttributedString *s = [[NSMutableAttributedString alloc] initWithString:string attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Georgia" size:IS_IPAD ? 36 : 14]}];
    NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
    style.lineBreakMode = NSLineBreakByCharWrapping;
    [s addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, s.string.length)];
    textStorage = [[NSTextStorage alloc] initWithAttributedString:s];
    
    // Establish the layout manager
    layoutManager = [NSLayoutManager new];
    layoutManager.allowsNonContiguousLayout = YES;
    
    // Add the two custom containers
    [layoutManager addTextContainer:textViewLeft.textContainer];
    [layoutManager addTextContainer:textViewRight.textContainer];
    textViewLeft.textContainerInset = UIEdgeInsetsZero;
    textViewRight.textContainerInset = UIEdgeInsetsZero;
    
    // Add the layout manager to the text storage
    [textStorage addLayoutManager:layoutManager];
}
@end

#pragma mark - Application Setup -

@interface TestBedAppDelegate : NSObject <UIApplicationDelegate>
@property (nonatomic, strong) UIWindow *window;
@end

@implementation TestBedAppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    TestBedViewController *vc = [[TestBedViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    _window.rootViewController = nav;
    [_window makeKeyAndVisible];
    return YES;
}
@end

int main(int argc, char *argv[]) {
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, @"TestBedAppDelegate");
    }
}