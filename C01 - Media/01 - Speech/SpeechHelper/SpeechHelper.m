/*
 
 Erica Sadun, http://ericasadun.com
 
 */

#import "SpeechHelper.h"

@import AVFoundation;

@interface SpeechHelper () <AVSpeechSynthesizerDelegate>
@property (nonatomic, strong) SpeechCompletionBlock completion;
@property (nonatomic, assign) BOOL runModal;
@end

@implementation SpeechHelper
- (instancetype) init
{
    if (!(self = [super init])) return self;
    _rate = 0.2f;
    _runModal = NO;
    _completion = nil;
    return self;
}

- (void) setRate:(CGFloat)rate
{
    // Clamp between 0 and 1
    CGFloat r = fminf(fmaxf(rate, 0.0f), 1.0f);
    _rate = r;
}

- (void) speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance *)utterance
{
    if (_completion)
    {
        _completion();
        _completion = nil;
        return;
    }
    
    if (_runModal)
    {
        CFRunLoopStop(CFRunLoopGetCurrent());
        return;
    }
}

- (void) performSpeech: (NSString *) string
{
    // Establish a new utterance
    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:string];
    
    // Slow down the rate
    CGFloat rateRange = AVSpeechUtteranceMaximumSpeechRate - AVSpeechUtteranceMinimumSpeechRate;
    utterance.rate = AVSpeechUtteranceMinimumSpeechRate + rateRange * _rate;
    
    // Set the language
    NSString *languageCode = [[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode] ? : @"en-us";
    utterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:languageCode];
    
    // Speak
    AVSpeechSynthesizer *synthesizer = [[AVSpeechSynthesizer alloc] init];
    synthesizer.delegate = self;
    [synthesizer speakUtterance:utterance];
}

- (void) speakModalString: (NSString *) string
{
    _runModal = YES;
    [self performSpeech:string];
    CFRunLoopRun();
}

- (void) speakString:(NSString *) string
{
    [self performSpeech:string];
}

- (void) speakString: (NSString *) string withCompletion: (SpeechCompletionBlock) completion
{
    _completion = completion;
    [self performSpeech:string];
}

+ (void) speakModalString:(NSString *)string
{
    [[self new] speakModalString:string];
}

+ (void) speakString:(NSString *)string
{
    [[self new] speakString:string];
}

+ (void) speakString: (NSString *) string withCompletion: (SpeechCompletionBlock) completion
{
    [[self new] speakString:string withCompletion:completion];
}

+ (NSArray *) voices
{
    return [AVSpeechSynthesisVoice speechVoices];
}
@end
