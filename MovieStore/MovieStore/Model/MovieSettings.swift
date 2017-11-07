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
    var movieReleaseFromYear: Int
    var releaseDate: Bool
    var rating: Bool

    override init() {
        self.popularMovies = false
        self.topRatedMovies = false
        self.upComingMovies = false
        self.nowPlayingMovies = false
        self.movieWithRate = 0
        self.movieReleaseFromYear = 1970
        self.releaseDate = false
        self.rating = false
        super.init()
    }

    init(popularMovie: Bool, topRatedMovie: Bool, upComingMovie: Bool, nowPlayingMovie: Bool, movieWithRate: Float, movieReleaseYear: Int, releaseDate: Bool, rating: Bool) {
        self.popularMovies = popularMovie
        self.topRatedMovies = topRatedMovie
        self.upComingMovies = upComingMovie
        self.nowPlayingMovies = nowPlayingMovie
        self.movieWithRate = movieWithRate
        self.movieReleaseFromYear = movieReleaseYear
        self.releaseDate = releaseDate
        self.rating = rating
    }

    init(dictionary dict: [String : Any]) {
        print("Init at getMovieSettings: \(dict)")
        self.popularMovies = false//dict["popularMovies"] == YES ? true: false
        self.topRatedMovies = true//dict["topRatedMovies"] = 1 ? true: false
        self.upComingMovies = false //dict["upComingMovies"] as! Bool
        self.nowPlayingMovies = false //dict["nowPlayingMovies"] as! Bool
        self.movieWithRate = dict["movieWithRate"] as? Float ?? 0
        self.movieReleaseFromYear = 2017 //dict["movieReleaseFromYear"] as! Int
        self.releaseDate = false //dict["releaseDate"] as! Bool
        self.rating = false //dict["rating"] as! Bool
    }
}
