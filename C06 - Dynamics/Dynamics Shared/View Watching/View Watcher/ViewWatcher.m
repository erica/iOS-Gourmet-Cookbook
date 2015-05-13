/*
 
 Erica Sadun, http://ericasadun.com
 
 */

#import "ViewWatcher.h"

#define VALUE(struct) ({ __typeof__(struct) __struct = struct; [NSValue valueWithBytes:&__struct objCType:@encode(__typeof__(__struct))]; })

// You can easily substitute other tests than comparing frames, but this
// is a pretty good test for many UIView animations that don't involve rotation
static BOOL CompareFrames(CGRect frame1, CGRect frame2, CGFloat laxity)
{
    if (CGRectEqualToRect(frame1, frame2)) return YES;
    CGRect intersection = CGRectIntersection(frame1, frame2);
    CGFloat testArea = intersection.size.width * intersection.size.height;
    CGFloat area1 = frame1.size.width * frame1.size.height;
    CGFloat area2 = frame2.size.width * frame2.size.height;
    return ((fabs(testArea - area1) < laxity) && (fabs(testArea - area2) < laxity));
}

@interface WatchedViewInfo : NSObject
@property (nonatomic) CGRect frame;
@property (nonatomic) NSUInteger count;
@property (nonatomic) id <ViewWatcherDelegate> delegate;
@end

@implementation WatchedViewInfo
@end

static ViewWatcher *sharedInstance = nil;

@implementation ViewWatcher
{
    NSMutableDictionary *dict;
}

+ (instancetype) sharedInstance
{
    if (!sharedInstance)
        sharedInstance = [[self alloc] init];
    
    return sharedInstance;
}

- (instancetype) init
{
    if (!(self = [super init])) return self;
    dict = [NSMutableDictionary dictionary];
    _pointLaxity = 10;
    return self;
}

- (void) checkInOnView: (NSTimer *) timer
{
    int kThreshold = 3; // must remain for 0.3 secs

    UIView *view = (UIView *) timer.userInfo;
    NSNumber *key = @((int)view);
    WatchedViewInfo *watchedViewInfo = dict[key];
    
    // Matching frame
    BOOL steadyFrame = CompareFrames(watchedViewInfo.frame, view.frame, _pointLaxity);
    if (steadyFrame) watchedViewInfo.count++;
    
    // Threshold met
    if (steadyFrame && (watchedViewInfo.count > kThreshold))
    {
        [timer invalidate];
        [dict removeObjectForKey:key];
        [watchedViewInfo.delegate viewDidPause:view];
        return;
    }
    
    if (steadyFrame) return;
    
    // Replace frame
    watchedViewInfo.frame = view.frame;
    watchedViewInfo.count = 0;
}

- (void) startWatchingView: (UIView *) view withDelegate: (id <ViewWatcherDelegate>) delegate
{
    NSNumber *key = @((int)view);
    WatchedViewInfo *watchedViewInfo = [[WatchedViewInfo alloc] init];
    watchedViewInfo.frame = view.frame;
    watchedViewInfo.count = 1;
    watchedViewInfo.delegate = delegate;
    dict[key] = watchedViewInfo;
    
    [NSTimer scheduledTimerWithTimeInterval:0.03f target:self selector:@selector(checkInOnView:) userInfo:view repeats:YES];
}
@end