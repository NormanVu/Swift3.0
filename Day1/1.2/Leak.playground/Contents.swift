//: Playground - noun: a place where people can play

import UIKit

//----------------------------------------------------------------------------------------------------
//Task: Let's actually see how the reference flow changes with strong reference and weak reference
//----------------------------------------------------------------------------------------------------

class ParentObject {
    //Default strong reference
    var object: AnyObject?

    deinit {
        print("ParentObject: released")
    }
}

class ChildObject {
    //Weak reference can prevent circular reference
    weak var object: AnyObject?

    deinit {
        print("ChildObject: released")
    }
}


// parentObj possesses a strong reference to an instance of ParentObject
var parentObj : ParentObject?  =  ParentObject()

// childObj possesses a strong reference to an instance of ChildObject
var childObj : ChildObject?  =  ChildObject()

// instance variable of parentObj holds a strong reference to childObj
parentObj?.object  = childObj
// ChildObj instance variable of holding strong references to the parentObj
childObj?.object  = parentObj

// If parentObj.object is a weak reference:
// Substituting nil for parentObj will cause parentObj to dereference (release) an instance of ParentObject
// childObj will be nil so childObj will release an instance of ChildObject
parentObj =  nil

// if parentObj.object is a weak reference:
// Substituting nil for parentObj, childObj.object holds strong reference of instance of ParentObject
parentObj =  nil