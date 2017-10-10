//: Playground - noun: a place where people can play

import UIKit

//--------------------------------------------------------
//Task: classify the object created in assignment 2 (JSON)
//--------------------------------------------------------

enum Gender: Int {
    case man
    case female
}

class User: CustomStringConvertible {
    let name    : String
    let gender  : Gender
    let year    : Int
    let age     : Int
    let visits  : [Int]!


    var description: String {
        return "\nUser:\n"
            + "    name   = \(name)\n"
            + "    year   = \(year)\n"
            + "    age    = \(age)\n"
            + "    visits = \(visits)\n"
    }

    init?(dict: [String : Any?]) {
        guard
            let name = dict["name"] as? String,
            let rawGender = dict["gender"] as? Int,
            let gender = Gender(rawValue: rawGender),
            let year = dict["year"] as? Int,
            let age = dict["age"] as? Int
            else {
                return nil
        }
        self.name   = name
        self.gender = gender
        self.year   = year
        self.age    = age
        self.visits = dict["visits"] as? [Int]
    }
}

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


let users: [User] = (dict["users"] ?? []).flatMap { User(dict: $0) }

print(users)

