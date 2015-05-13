/*
 
 Erica Sadun, http://ericasadun.com
 
 */

#import "UIKeyCommand+Utility.h"


#define CHECK_FLAG(_source_, _flag_) ((_source_ & _flag_) != 0)

NSString *StringFromKeyCommand(UIKeyCommand *command)
{
    NSMutableString *string = [NSMutableString string];
    UIKeyModifierFlags flags = command.modifierFlags;
    
    if (flags == 0) return command.input;
    
    if (CHECK_FLAG(flags, UIKeyModifierCommand))
    {
        [string appendString:@"Cmd"];
    }
    
    if (CHECK_FLAG(flags, UIKeyModifierControl))
    {
        if (string.length > 0) [string appendString:@"+"];
        [string appendString:@"Ctrl"];
    }
    
    if (CHECK_FLAG(flags, UIKeyModifierAlternate))
    {
        if (string.length > 0) [string appendString:@"+"];
        [string appendString:@"Alt"];
    }
    
    if (CHECK_FLAG(flags, UIKeyModifierShift))
    {
        if (string.length > 0) [string appendString:@"+"];
        [string appendString:@"Shift"];
    }
    
    if (CHECK_FLAG(flags, UIKeyModifierNumericPad))
    {
        if (string.length > 0) [string appendString:@" "];
        [string appendString:@"<NumberPad>"];
    }
    
    if (CHECK_FLAG(flags, UIKeyModifierAlphaShift))
    {
        if (string.length > 0) [string appendString:@" "];
        [string appendString:@"<AlphaShift>"];
    }
    
    [string appendFormat:@"+%@", command.input.uppercaseString];
    
    return string;
}

