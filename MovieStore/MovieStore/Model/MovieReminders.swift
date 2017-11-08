//
//  MovieReminders.swift
//  MovieStore
//
//  Created by Nhat (Norman) H.M. VU on 11/8/17.
//  Copyright © 2017 enclaveit. All rights reserved.
//

import Foundation

class MovieReminders: NSObject {
    var movieId: Int?
    var rating: String?
    var title: String?
    var releaseDate: Date?

    override init() {
        super.init()
    }
}
