//: Playground - noun: a place where people can play

//For verification,
//1. Parallel queue and serial queue
//2. DispatchQueue async and DispatchQueue sync

import UIKit

//--------------------------------------
//Dispatch Queue async in parallel queue
//--------------------------------------
print("Dispatch Queue async in parallel queue")
for i in 0 ..< 100 {
    DispatchQueue.global().async {
        print(i)
    }
}
print("number here!!")//This process to print text "number here!!" can be printed before ending statement for above due to dispatch queue is processed async


//-------------------------------------
//Dispatch Queue sync in parallel queue
//-------------------------------------
print("Dispatch Queue sync in parallel queue")
for j in 0 ..< 100 {
    DispatchQueue.global().sync {
        print(j)
    }
}
print("number here!!")//This process to print text "number here!!" will be printed after ending statement for above due to dispatch queue is processed sync


//------------------------------------
//Dispatch Queue async in serial queue
//------------------------------------
print("Dispatch Queue async in serial queue")
let queueAsync =  DispatchQueue(label : "async in serial queue")
for ii in 0 ..< 100 {
    queueAsync.async {
        print(ii)
    }
}
print("number here!!")//This process to print text "number here!!" will be printed before ending statement for above due to dispatch queue is processed asyn in serial


//------------------------------------
//Dispatch Queue sync in serial queue
//------------------------------------
print("Dispatch Queue sync in serial queue")
let queueSync =  DispatchQueue(label : "sync in serial queue")
for jj in 0 ..< 100 {
    queueSync.sync {
        print(jj)
    }
}
print("number here!!")//This process to print text "number here!!" will be printed after ending statement for above due to dispatch queue is processed sync in serial

//-----------------------------------
//Dispatch Group
//-----------------------------------
let group = DispatchGroup() // 1. Generate a dispatch group
for g in 0 ..< 100 {
    // 2. Add task to dispatch queue
    DispatchQueue.global().async (group : group) {
        print(g)
    }
}
// 3. Wait until task is finished
_ = group.wait(timeout : .distantFuture )

print("waiting here! ")


//--------------------------------------------------------------------------------------------
//DispatchWorkItemFlags.barrier or serial queue
//to prevent conflict data to make sure consistency of the data
//--------------------------------------------------------------------------------------------
//Step 1:
var string = " "
for index in  0 ..< 100  {
    guard index % 10 == 0 else {
        print("\( index ) : string = "  + string)
        continue
    }
    let range = string.startIndex ..< string.index(string.startIndex, offsetBy: string.characters.count)
    string.removeSubrange(range)
    string += "\( index )"
}

//Step 2: Process parallel without .barrier
let queue = DispatchQueue(label: "Parallel without .barrier", attributes: .concurrent)
var string2 = " "
for index2 in 0 ..< 100 {
    guard index2 % 10 == 0 else {
        queue.async { // loading process
            print("\( index2 ) : string = "  + string2)
        }
        continue
    }
    queue.async { // write operation
        let range = string2.startIndex ..< string2.index(string2.startIndex, offsetBy: string2.characters.count)
        string2.removeSubrange(range)
        string2 += "\( index2 )"
    }
}

//Step 3: Process parallel with .barrier
let queueBarrier = DispatchQueue(label: "Parallel with .barrier", attributes: .concurrent)
var string3 = " "
for index3 in 0 ..< 100 {
    guard index3 % 10 == 0 else {
        queueBarrier.async { // loading process
            print("\( index3 ) : string = "  + string3)
        }
        continue
    }
    queueBarrier.async(flags: .barrier) { // write operation
        let range = string3.startIndex ..< string3.index(string3.startIndex, offsetBy: string3.characters.count)
        string3.removeSubrange(range)
        string3 += "\( index3 )"
    }
}
