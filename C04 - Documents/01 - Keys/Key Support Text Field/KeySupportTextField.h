/*
 
 Erica Sadun, http://ericasadun.com
 
 */

#import <Foundation/Foundation.h>

extern NSString *const KeySupportFieldEvent;

@interface KeySupportTextField : UITextField
- (void) resetKeyCommands;
- (void) listenForKey: (NSString *) key modifiers: (UIKeyModifierFlags) flags;
@end
