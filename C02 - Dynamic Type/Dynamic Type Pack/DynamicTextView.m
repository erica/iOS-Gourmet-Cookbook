/*
 
 Erica Sadun, http://ericasadun.com
 
 */

#import "DynamicTextView.h"

@interface DynamicTextView ()
@property (nonatomic, strong) NSString *textStyle;
@property (nonatomic, strong) NSDictionary *rangeDictionary;
@property (nonatomic, strong) NSMutableArray *observers;
@end

@implementation DynamicTextView
- (void) setAttributedText:(NSAttributedString *)attributedText
{
    _rangeDictionary = TextStyleRangeDictionary(attributedText);
    [super setAttributedText:attributedText];
}

- (void) setText:(NSString *)text
{
    if (!_textStyle)
    {
        [super setText:text];
        return;
    }
    
    UIFont *font = [UIFont preferredFontForTextStyle:self.textStyle];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName:font}];
    [self setAttributedText:attributedString];
}

- (instancetype) initWithTextStyle: (NSString *) textStyle
{
    if (!(self = [super initWithFrame:CGRectZero])) return self;
    
    _textStyle = textStyle;
    
    self.font = [UIFont preferredFontForTextStyle:_textStyle];
    if (!self.font)
    {
        _textStyle = DEFAULT_TEXT_STYLE;
        self.font = [UIFont preferredFontForTextStyle:DEFAULT_TEXT_STYLE];
    }
    
    __weak typeof(self) weakSelf = self;
    _observers = [NSMutableArray array];
    
    // Listen for dynamic text updates
    id observer = [[NSNotificationCenter defaultCenter]
     addObserverForName:UIContentSizeCategoryDidChangeNotification
     object:nil
     queue:[NSOperationQueue mainQueue]
     usingBlock:^(NSNotification *note) {
         __strong typeof(self) strongSelf = weakSelf;
         NSAttributedString *updatedText = ApplyTextStylesToAttributedString(strongSelf.attributedText, strongSelf.rangeDictionary);
         strongSelf.attributedText = updatedText;
     }];
    [_observers addObject:observer];
    
    // Listen for text edits
    observer = [[NSNotificationCenter defaultCenter]
     addObserverForName:UITextViewTextDidChangeNotification
     object:self
     queue:[NSOperationQueue mainQueue]
     usingBlock:^(NSNotification *note) {
         __strong typeof(self) strongSelf = weakSelf;
         strongSelf.rangeDictionary = TextStyleRangeDictionary(strongSelf.attributedText);
     }];
    [_observers addObject:observer];
    
    return self;
}

- (void) dealloc
{
    for (id observer in _observers)
    {
        [[NSNotificationCenter defaultCenter] removeObserver:observer];
    }
}

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithTextStyle:nil];
}

+ (instancetype) viewWithTextStyle: (NSString *) textStyle
{
    DynamicTextView *instance = [[self alloc] initWithTextStyle:textStyle];
    return instance;
}

+ (instancetype) view
{
    DynamicTextView *instance = [[self alloc] initWithTextStyle:UIFontTextStyleBody];
    return instance;
}
@end
