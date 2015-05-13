/*
 
 Erica Sadun, http://ericasadun.com
 
 */

#import "KeySupportTextField.h"

NSString *const KeySupportFieldEvent = @"KeySupportFieldEvent";

@implementation KeySupportTextField
{
    NSMutableSet *keyCommands;
}

- (instancetype) initWithFrame:(CGRect)frame
{
    if (!(self = [super initWithFrame:frame])) return self;
    keyCommands = [NSMutableSet set];
    self.borderStyle = UITextBorderStyleRoundedRect;
    return self;
}

- (NSArray *)keyCommands
{
    return keyCommands.allObjects;
}

- (void) resetKeyCommands
{
    keyCommands = [NSMutableSet set];
}

- (void) handleKeyCommand: (UIKeyCommand *) command
{
    [[NSNotificationCenter defaultCenter] postNotificationName:KeySupportFieldEvent object:command];
}

- (void) listenForKey: (NSString *) key modifiers: (UIKeyModifierFlags) flags
{
    UIKeyCommand *command = [UIKeyCommand keyCommandWithInput:key modifierFlags:flags action:@selector(handleKeyCommand:)];
    [keyCommands addObject:command];
}
@end
