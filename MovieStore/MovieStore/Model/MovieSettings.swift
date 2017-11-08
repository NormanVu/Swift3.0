//
//  MovieSettings.swift
//  MovieStore
//
//  Created by Nhat (Norman) H.M. VU on 11/2/17.
//  Copyright © 2017 enclaveit. All rights reserved.
//

import Foundation

class MovieSettings: NSObject {
    var popularMovies: Bool
    var topRatedMovies: Bool
    var upComingMovies: Bool
    var nowPlayingMovies: Bool
    var movieWithRate: Float
    var fromReleaseYear: Int
    var releaseDate: Bool
    var rating: Bool

    override init() {
        self.popularMovies = true
        self.topRatedMovies = false
        self.upComingMovies = false
        self.nowPlayingMovies = false
        self.movieWithRate = 5
        self.fromReleaseYear = 2017
        self.releaseDate = true
        self.rating = false
        super.init()
    }
}
