/*
 
 Erica Sadun, http://ericasadun.com
 
 */

#import "DetailViewController.h"
#import "Essentials.h"

@interface DetailViewController ()

@end

@implementation DetailViewController
- (void) viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    _label = [UILabel new];
    _label.font = [UIFont fontWithName:@"Futura" size:32];
    _label.textAlignment = NSTextAlignmentCenter;
    SizeView(_label, CGSizeMake(200, 200), 1000);
    PlaceView(self, _label, @"cc", 0, 0, 1000);
}
@end
