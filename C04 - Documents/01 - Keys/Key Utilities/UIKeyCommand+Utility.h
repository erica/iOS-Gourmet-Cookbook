/*
 
 Erica Sadun, http://ericasadun.com
 
 */

#import <Foundation/Foundation.h>

#define CHECK_FLAG(_source_, _flag_) ((_source_ & _flag_) != 0)

NSString *StringFromKeyCommand(UIKeyCommand *command);
