//: Playground - noun: a place where people can play

import UIKit

//----------------------------------------------------------------------
//Task: Reproduce the object with the following data structure from JSON
//----------------------------------------------------------------------
/* JSON format as below
 
 {
     "users" : [
         {
             name   : "Dr. Emmett Brown",
             gender : 1,
             year   : 1985,
             age    : 65,
             visits : [1885, 1955, 1985, 2015]
         },
         {
             name   : "Marty McFly",
             gender : 1,
             year   : 1985,
             age    : 17,
             visits : [1885, 1955, 1985, 2015]
         },
         {
             name   : "Lorraine Baines",
             gender : 0,
             year   : 1955,
             age    : 18,
             visits : null
         }
     ]
 }
 
*/


let dict: [String : [[String : Any?]]] = [
    "users" : [
        [
            "name"   : "Dr. Emmett Brown",
            "gender" : 1,
            "year"   : 1985,
            "age"    : 65,
            "visits" : [1885, 1955, 1985, 2015]
        ],
        [
            "name"   : "Marty McFly",
            "gender" : 1,
            "year"   : 1985,
            "age"    : 17,
            "visits" : [1885, 1955, 1985, 2015]
        ],
        [
            "name"   : "Lorraine Baines",
            "gender" : 1,
            "year"   : 1955,
            "age"    : 18,
            "visits" : nil
        ]
    ]
]




