//
//  Constants.swift
//  MovieStore
//
//  Created by Nhat (Norman) H.M. VU on 10/19/17.
//  Copyright © 2017 enclaveit. All rights reserved.
//

import Foundation
import UIKit

let APIKey = "0267c13d8c7d1dcddb40001ba6372235"
let APIURLPrefix = "https://api.themoviedb.org/3"
let imageURLPrefix = "https://image.tmdb.org/t/p"
let delta: Int = 8

enum TypeCollection: Int {
    case popular = 1
    case topRated = 2
    case nowPlaying = 3
    case upComing = 4
    case credit = 5
    case search = 6
}

let userDefault = UserDefaults.standard

