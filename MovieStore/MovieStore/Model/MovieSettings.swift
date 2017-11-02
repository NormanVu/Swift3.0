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


    init(rawData: NSDictionary) {
        self.popularMovies = Bool?((rawData.object(forKey: "popularMovies") as! Bool))!
        self.topRatedMovies = Bool?((rawData.object(forKey: "topRatedMovies") as! Bool))!
        self.upComingMovies = Bool?((rawData.object(forKey: "upComingMovies") as! Bool))!
        self.nowPlayingMovies = Bool?((rawData.object(forKey: "nowPlayingMovies") as! Bool))!
        self.movieWithRate = Float?((rawData.object(forKey: "movieWithRate") as! Float))!
        self.movieReleaseFromYear = Int?((rawData.object(forKey: "movieReleaseFromYear") as! Int))!
        self.releaseDate = Bool?((rawData.object(forKey: "releaseDate") as! Bool))!
        self.rating = Bool?((rawData.object(forKey: "rating") as! Bool))!
        super.init()
    }
}
