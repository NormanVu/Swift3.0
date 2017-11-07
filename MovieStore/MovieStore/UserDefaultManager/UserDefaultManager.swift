//
//  UserDefaultManager.swift
//  MovieStore
//
//  Created by Nhat (Norman) H.M. VU on 11/6/17.
//  Copyright © 2017 enclaveit. All rights reserved.
//

import Foundation

class UserDefaultManager {
    private static let movieSettingsKey = "movieSettings"

    func registerSettingsBundle() {
        let settingsUrl = Bundle.main.url(forResource: "Settings", withExtension: "bundle")!.appendingPathComponent("Root.plist")
        let settingsPlist = NSDictionary(contentsOf:settingsUrl)!
        let preferences = settingsPlist["PreferenceSpecifiers"] as! [NSDictionary]

        var defaultsToRegister = Dictionary<String, Any>()
        for preference in preferences {
            guard let key = preference["Key"] as? String else {
                NSLog("Key not fount")
                continue
            }
            defaultsToRegister[key] = preference[UserDefaultManager.movieSettingsKey]
        }
        userDefault.register(defaults: defaultsToRegister)
        userDefault.synchronize()
    }

    func getMovieSettings() -> MovieSettings {
        let movieSettings = MovieSettings(   popularMovie: userDefault.bool(forKey: "popularMovies"),
                                            topRatedMovie: userDefault.bool(forKey: "topRatedMovies"),
                                            upComingMovie: userDefault.bool(forKey: "upComingMovies"),
                                          nowPlayingMovie: userDefault.bool(forKey: "nowPlayingMovies"),
                                            movieWithRate: userDefault.float(forKey: "movieWithRate"),
                                         movieReleaseYear: userDefault.integer(forKey: "movieReleaseFromYear"),
                                              releaseDate: userDefault.bool(forKey: "releaseDate"),
                                                   rating: userDefault.bool(forKey: "rating"))
        return movieSettings
    }

    func updateMovieSettings(popularMovie: Bool, topRatedMovie: Bool, upComingMovie: Bool, nowPlayingMovie: Bool, movieWithRate: Float, movieReleaseYear: Int, releaseDate: Bool, rating: Bool) -> Bool {
        var dict = Dictionary<String, Any>()
        dict["popularMovies"] = popularMovie
        dict["topRatedMovies"] = topRatedMovie
        dict["upComingMovies"] = upComingMovie
        dict["nowPlayingMovies"] = nowPlayingMovie
        dict["movieWithRate"] = movieWithRate
        dict["movieReleaseFromYear"] = movieReleaseYear
        dict["releaseDate"] = releaseDate
        dict["rating"] = rating
        userDefault.set(dict, forKey: UserDefaultManager.movieSettingsKey)
        return userDefault.synchronize()
    }
}
