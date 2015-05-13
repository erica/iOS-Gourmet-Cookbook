import Foundation

// Return an NSError instance
func BuildError(code : Int, reason : String) -> NSError {
    let errorDomain = "com.sadun.examples"
    let error = NSError(domain: errorDomain, code: code,
        userInfo: [
            NSLocalizedDescriptionKey:reason,
            NSLocalizedFailureReasonErrorKey:reason])
    return error
}

// inout parameters are mutable

// Fetch string using standard Swift if-let
func StringFromURL(url : NSURL, inout error : NSError?) -> (NSString?) {
    if let data = NSData(contentsOfURL:url, options: NSDataReadingOptions(rawValue:0), error: &error) {
        if let string = NSString(data: data, encoding: NSUTF8StringEncoding) {
            return string
        }
        error = BuildError(1, "Unable to build string from data")
        return nil
    }
    return nil
}

// Linear
//func StringFromURL(url : NSURL, inout error : NSError?) -> (NSString?) {
//    let data_ = NSData(contentsOfURL:url, options: NSDataReadingOptions(rawValue:0), error: &error)
//    if (data_ == nil) {
//        return nil
//    }
//    let data = data_!
//    
//    let string_ = NSString(data: data, encoding: NSUTF8StringEncoding)
//    if (string_ == nil) {
//        error = BuildError(1, "Unable to build string from data")
//        return nil
//    }
//    let string = string_!
//    
//    return string
//}



var error : NSError?
let url = NSURL(string: "duck://ericasadun.com")! // bad url
// let url = NSURL(string: "http://ericasadun.com")! // good url

if let string = StringFromURL(url, &error) {
    println(string)
} else {
    if let error = error {
        println(error.localizedDescription)
    }
}
