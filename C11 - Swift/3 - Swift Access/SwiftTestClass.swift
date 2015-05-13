/*

Erica Sadun, http://ericasadun.com

*/

import Foundation

@objc class VisibleToObjectiveC {
    
}

class NotVisibleToObjectiveC {
    
}

@objc class MyCocoaClass : NSObject {
    func test() {
        println("I can call Swift from Objective-C")
    }
}

@objc class MySwiftClass {
    class func `new` () -> MySwiftClass {
        return MySwiftClass()
    }
    
    func test() {
        println("I can call Swift from Objective-C")
    }
}

@objc class MyComplexClass {
    var _string : String?
    var myInt : Int
    
    // Initialize
    init () {
        _string = nil
        myInt = 0
    }
    
    
    // Return newInstance
    class func instance () -> MyComplexClass {
        return MyComplexClass()
    }
    
    // Test method
    func test () {
        println("Test method")
    }
    
    var string : String? {
        get {return _string}
        set {
            // When set, print out the new value
            _string = newValue
            let stringValue = _string ?? "nil"
            println("String is being set to \(stringValue)")
        }
    }
}