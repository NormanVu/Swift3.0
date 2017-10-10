//: Playground - noun: a place where people can play

import UIKit

let h: String? = "H"
let ell = "ell"
let o: String? = "o"
var world: String! = nil
world = " world!"
var helloWorld: String


//Combination two strings by plus when print
print ( " Hello "  +  " World! " )

//Combination strings
if let h2 = h, let o2 = o, let world2 = world {
    helloWorld = h2 + ell + o2 + world2
} else {
    helloWorld = ""
}
print(helloWorld)

//Combination string and characters
let a: String = " World! Police number: "
var b: Int = 911
print (" Hello " + String(a) + String(b));



//-------------------------------------------------------
//Task: Display "Hello World!" without using force unwrap
//-------------------------------------------------------

//------------------
//Using force unwrap: However, if you use force unwrap, if the variable is nil, it will be a run-time error when print value, so do not to try to use it much
var forceUnwrap : String? = nil
forceUnwrap = "Hello World!"
print(forceUnwrap!)

//--------------------------
//Without using force unwrap
//Solution 1:
var withoutForceUnwrap : String! = nil
withoutForceUnwrap = "Hello World!"
print(withoutForceUnwrap)
//Solution 2:
//var forceUnwrap : String? = nil
let newWithoutForceUnwrap = forceUnwrap ?? ""
print(newWithoutForceUnwrap)