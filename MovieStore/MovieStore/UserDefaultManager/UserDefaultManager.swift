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
            if ((preference[UserDefaultManager.movieSettingsKey]) != nil) {
                defaultsToRegister = preference as! [String : Any]
                break
            }
        }
        userDefault.register(defaults: defaultsToRegister)
        userDefault.synchronize()
    }

    func getMovieSettings() -> [MovieSettings] {
        return userDefault.array(forKey: UserDefaultManager.movieSettingsKey) as! [MovieSettings]
    }

    func updateMovieSettings(popularMovie: Bool, topRatedMovie: Bool, upComingMovie: Bool, nowPlayingMovie: Bool, movieWithRate: Float, movieReleaseYear: Int, releaseDate: Bool, rating: Bool) -> Bool {
        let movieSetting = MovieSettings.init(   popularMovie: popularMovie,
                                                topRatedMovie: topRatedMovie,
                                                upComingMovie: upComingMovie,
                                              nowPlayingMovie: nowPlayingMovie,
                                                movieWithRate: movieWithRate,
                                             movieReleaseYear: movieReleaseYear,
                                                  releaseDate: releaseDate,
                                                       rating: rating)

        userDefault.set(movieSetting, forKey: UserDefaultManager.movieSettingsKey)
        return userDefault.synchronize()
    }
}
