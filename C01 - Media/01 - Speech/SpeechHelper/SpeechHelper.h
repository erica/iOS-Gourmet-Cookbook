/*
 
 Erica Sadun, http://ericasadun.com
 
 */

@import Foundation;
@import QuartzCore;

typedef void (^SpeechCompletionBlock)();

@interface SpeechHelper : NSObject
@property (nonatomic) CGFloat rate;
- (void) speakString: (NSString *) string;
- (void) speakModalString: (NSString *) string;
- (void) speakString: (NSString *) string withCompletion: (SpeechCompletionBlock) completion;

+ (void) speakString: (NSString *) string;
+ (void) speakModalString: (NSString *) string;
+ (void) speakString: (NSString *) string withCompletion: (SpeechCompletionBlock) completion;

+ (NSArray *) voices;
@end

/*
 self.navigationItem.rightBarButtonItem.enabled = NO;
 ESTABLISH_WEAK_SELF;
 [SpeechHelper speakString:@"Hello There World, how nice it is to see you" withCompletion:^{
 ESTABLISH_STRONG_SELF;
 strongSelf.navigationItem.rightBarButtonItem.enabled = YES;
 NSLog(@"Done");
 }];
*/
