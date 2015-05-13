/*
 
 Erica Sadun, http://ericasadun.com
 
 */

@import UIKit;

@protocol ViewWatcherDelegate <NSObject>
- (void) viewDidPause: (UIView *) view;
@end

@interface ViewWatcher : NSObject
+ (instancetype) sharedInstance;
@property (nonatomic) CGFloat pointLaxity;
- (void) startWatchingView: (UIView *) view withDelegate: (id <ViewWatcherDelegate>) delegate;
@end
