/*
 
 Erica Sadun, http://ericasadun.com
 Gourmet Recipes
 
 */

@import UIKit;
#import "Essentials.h"
#import "CustomFlowLayout.h"

@interface InsetCollectionView : UIView <UICollectionViewDataSource>
@property (strong, readonly) UICollectionView *collectionView;
@end

@implementation InsetCollectionView

#pragma mark - Data Source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 500;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)_collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:999];
    if (!imageView)
    {
        imageView = [[UIImageView alloc] init];
        imageView.autoLayoutEnabled = YES;
        [cell.contentView addSubview:imageView];
        StretchViewToSuperview(imageView, CGSizeZero, 1000);
    }
    
    NSString *string = [NSString stringWithFormat:@"S%zd(%zd)", indexPath.section, indexPath.item];
    UIImage *image = BlockStringImage(string, 12.0f);
    imageView.image = image;
    
    return cell;
}

#pragma mark - Setup

- (id) initWithFrame:(CGRect)frame
{
    if (!([super initWithFrame:frame])) return nil;
    
    self.backgroundColor = [UIColor whiteColor];
    
    UICollectionViewFlowLayout *layout = [[CustomFlowLayout alloc] initWithItemSize:CGSizeMake(80, 80)];
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor lightGrayColor];
    _collectionView.allowsMultipleSelection = YES;
    _collectionView.dataSource = self;
    
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self addSubview:_collectionView];
    
    _collectionView.autoLayoutEnabled = YES;
    StretchViewToSuperview(_collectionView, CGSizeZero, 1000);
    
    return self;
}

@end

@interface TestBedViewController : UIViewController
@end

@implementation TestBedViewController
{
    InsetCollectionView *cv;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    cv = [[InsetCollectionView alloc] initWithFrame:CGRectZero];
    cv.backgroundColor = [UIColor blackColor];
    [self.view addSubview:cv];
    
    cv.autoLayoutEnabled = YES;
    StretchViewHorizontallyToSuperview(cv, 0, 1000);
    CenterViewInSuperview(cv, NO, YES, 1000);
    SizeView(cv, CGSizeMake(SkipConstraint, 200), 1000);
}
@end

#pragma mark - Application Setup -

@interface TestBedAppDelegate : NSObject <UIApplicationDelegate, UINavigationControllerDelegate>
@property (nonatomic, strong) UIWindow *window;
@end

@implementation TestBedAppDelegate
- (NSUInteger)navigationControllerSupportedInterfaceOrientations:(UINavigationController *)navigationController
{
    return UIInterfaceOrientationMaskLandscape;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    TestBedViewController *vc = [[TestBedViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    nav.delegate = self;
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