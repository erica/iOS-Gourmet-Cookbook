/*
 
 Erica Sadun, http://ericasadun.com
 Gourmet Recipes

 */

#import "DynamicLabel.h"

@interface DynamicLabel ()
@property (nonatomic, strong) NSString *textStyle;
@property (nonatomic, strong) NSDictionary *rangeDictionary;
@property (nonatomic, strong) NSMutableArray *observers;
@end

@implementation DynamicLabel
- (void) setAttributedText:(NSAttributedString *)attributedText
{
    [super setAttributedText:attributedText];
    _rangeDictionary =  TextStyleRangeDictionary(attributedText);
}

- (void) setText:(NSString *)text
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName:self.font}];
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
    
    _observers = [NSMutableArray array];
    __weak typeof(self) weakSelf = self;
    id observer = [[NSNotificationCenter defaultCenter]
     addObserverForName:UIContentSizeCategoryDidChangeNotification
     object:nil
     queue:[NSOperationQueue mainQueue]
     usingBlock:^(NSNotification *note) {
         __strong typeof(self) strongSelf = weakSelf;
         NSAttributedString *updatedText = ApplyTextStylesToAttributedString(strongSelf.attributedText, strongSelf.rangeDictionary);
         strongSelf.attributedText = updatedText;
         [strongSelf setNeedsDisplay];
     }];
    [_observers addObject: observer];
    
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

+ (instancetype) labelWithTextStyle: (NSString *) textStyle
{
    DynamicLabel *instance = [[self alloc] initWithTextStyle:textStyle];
    return instance;
}

+ (instancetype) label
{
    DynamicLabel *instance = [[self alloc] initWithTextStyle:UIFontTextStyleBody];
    return instance;
}
@end
