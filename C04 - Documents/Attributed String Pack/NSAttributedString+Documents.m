/*
 
 Erica Sadun, http://ericasadun.com
 
 */

@import UIKit;
#import "NSAttributedString+Documents.h"

#pragma mark - Load String

NSDictionary *DocumentTypeDictionary(NSString *ext) 
{
    NSDictionary *documentTypeDictionary =
    @{@"rtfd":NSRTFDTextDocumentType,
      @"rtf":NSRTFTextDocumentType,
      @"html":NSHTMLTextDocumentType,
      @"htm":NSHTMLTextDocumentType,
      @"txt":NSPlainTextDocumentType};
    
    NSString *docType = documentTypeDictionary[ext.lowercaseString];
    return @{NSDocumentTypeDocumentAttribute :
                 docType ? : NSPlainTextDocumentType};
}

NSAttributedString *AttributedStringWithPath(NSString *path, NSDictionary **documentDictionary)
{
    if (!path) return nil;
    
    NSString *targetPath = path;
    
    // Look in Bundle
    if (![[NSFileManager defaultManager] fileExistsAtPath:targetPath])
    {
        NSString *resource = [path.lastPathComponent stringByDeletingPathExtension];
        NSString *ext = path.pathExtension;
        
        NSString *testPath = [[NSBundle mainBundle] pathForResource:resource ofType:ext];
        if ([[NSFileManager defaultManager] fileExistsAtPath:testPath])
            targetPath = testPath;
    }
    
    // Look in Documents
    if (![[NSFileManager defaultManager] fileExistsAtPath:targetPath])
    {
        NSString *resource = path.lastPathComponent;
        NSString *testPath = [NSString stringWithFormat:@"%@/Documents/%@", NSHomeDirectory(), resource];
        if ([[NSFileManager defaultManager] fileExistsAtPath:testPath])
            targetPath = testPath;
    }

    // If the target cannot be found, error out
    if (![[NSFileManager defaultManager] fileExistsAtPath:targetPath])
    {
        NSLog(@"Error: Could not locate file at path %@", path);
        return nil;
    }

    // Retrieve document type dictionary
    NSDictionary *typeDictionary = DocumentTypeDictionary(targetPath.pathExtension);
    
    // Load in attributed string from target path
    NSError *error;
    NSDictionary *returnDict;
    NSAttributedString *result = [[NSAttributedString alloc] initWithFileURL:[NSURL fileURLWithPath:targetPath] options:typeDictionary documentAttributes:&returnDict error:&error];
    
    // Check for result
    if (result && documentDictionary) *documentDictionary = returnDict;
    if (!result)
    {
        NSLog(@"Error reading from %@ into attributed string: %@", path.lastPathComponent, error.localizedDescription);
        return nil;
    }
    
    return result;
}

NSAttributedString *AttributedStringWithData(NSData *data, NSString *ext)
{
    if (!data) return nil;
    if (!ext) return nil;
    
    NSDictionary *returnDict;
    NSError *error;
    NSDictionary *typeDictionary = DocumentTypeDictionary(ext);
    NSAttributedString *result = [[NSAttributedString alloc] initWithData: data options:typeDictionary documentAttributes:&returnDict error:&error];
    if (!result)
    {
        NSLog(@"Error initializing attributed string with data (%@): %@", ext, error.localizedDescription);
    }
    
    return result;
}

NSAttributedString *AttributedStringWithString(NSString *sourceString, NSString *ext)
{
    if (!sourceString) return nil;
    if (!ext) return nil;
    
    NSData *data = [sourceString dataUsingEncoding:NSUTF8StringEncoding];
    if (!data) return nil;
    return AttributedStringWithData(data, ext);
}

#pragma mark - Representations

NSData *AttributedStringDataRepresentation(NSAttributedString *string, NSString *ext)
{
    if (!string) return nil;
    if (!ext) return nil;

    NSError *error;
    NSDictionary *typeDictionary = DocumentTypeDictionary(ext);
    NSData *data = [string dataFromRange:NSMakeRange(0, string.length) documentAttributes:typeDictionary error:&error];
    if (!data)
    {
        NSLog(@"Error reading data from attributed string (%@): %@", ext, error.localizedDescription);
        return nil;
    }
    return data;
}

// Passing nil to ext returns plain text
NSString *AttributedStringStringRepresentation(NSAttributedString *string, NSString *ext)
{
    if (!string) return nil;
    
    NSData *data = AttributedStringDataRepresentation(string, ext);
    NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    if (result) return result;
    return string.string;
}

#pragma mark - Debug

void DumpStringAttributes(NSAttributedString *input)
{
    NSMutableString *string = [NSMutableString string];
    
    [string appendString:@"\n Loc Len  Text/Attributes\n"];
    [string appendString:@" --- ---  ---------------\n"];
    
    [input enumerateAttributesInRange:NSMakeRange(0, input.length) options:0 usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
        NSString *substring = [input.string substringWithRange:range];
        
        [string appendFormat:@"%4ld%4ld  \"%@\"\n", (long) range.location, (long) range.length, substring];
        
        int i = 1;
        for (NSString *key in attrs.allKeys)
            [string appendFormat:@"          %2d. %@: %@\n", i++, key, [(NSObject *)attrs[key] description]];
    }];
    
    printf("%s\n",  string.UTF8String);
}

@implementation NSAttributedString (Documents)
- (NSString *) HTMLRepresentation
{
    return AttributedStringStringRepresentation(self, @"html");
}

+ (instancetype) stringWithHTML: (NSString *) htmlString
{
    return AttributedStringWithString(htmlString, @"html");
}

+ (instancetype) stringWithPath: (NSString *) path
{
    return AttributedStringWithPath(path, nil);
}
@end