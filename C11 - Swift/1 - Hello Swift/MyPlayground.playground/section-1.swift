import UIKit

class MyClass {
    func method(parameter1: Int, signature parameter2: Int) {
        println("1: \(parameter1) 2: \(parameter2)")
    }
}

let foo = MyClass()
foo.method(23, signature: 5)


let soundDictionary = ["cow":"moo", "dog":"bark", "pig":"squeal"]
soundDictionary["cow"]
println(soundDictionary["cow"])
println(soundDictionary["fox"])

let optionalResult = soundDictionary["Something"]


if let foxSound = soundDictionary["fox"] {
    println("The fox says \(foxSound)")
} else {
    println("The fox does not say anything")
}


let wrappedSound = soundDictionary["cow"]
let unwrappedSound : String! = soundDictionary["cow"]


wrappedSound
wrappedSound!
unwrappedSound

// Don't unwrap nil
// var nothing : String? = nil
// nothing! // bad bad


// unwrappedSound!!!!!!!!
// error: operand of postfix '!' should have optional type; type is 'String'

var unwrappedSound2 : String! = soundDictionary["dog"]

// This generates an error
// let unwrappedSound2 : String! = soundDictionary["error"]

// And this
// let unwrappedSound3 : String! = nil

// And this (wrong type, and non-optional)
//var mySound : String
//mySound = soundDictionary["error"]!

// And this
//mySound = nil


var nonOptional : String = "Hello" // This works
nonOptional = soundDictionary["cow"]! // moo

if let sound = soundDictionary["cow"] {
    nonOptional = sound
}
nonOptional


//nonOptional = soundDictionary["cow"] // error
// "value of optional type 'String?' not unwrapped; did you mean to use '!' or '?'?"

//nonOptional = soundDictionary["fox"]! // error
// fatal error: unexpectedly found nil while unwrapping an Optional value

var optional : NSString?
optional = "Hello" // works, {Some "Hello"}
//optional = nil // works, nil

println(optional!)

optional = "Hello"
optional! // works, "Hello"

