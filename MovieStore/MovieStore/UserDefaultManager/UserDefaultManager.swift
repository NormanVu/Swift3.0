//
//  UserDefaultManager.swift
//  MovieStore
//
//  Created by Nhat (Norman) H.M. VU on 11/6/17.
//  Copyright © 2017 enclaveit. All rights reserved.
//

import Foundation

class UserDefaultManager {
    struct BundleSettingsKey {
        static let popularMovies = "POPULAR_MOVIES_KEY"
        static let topRatedMovies = "TOP_RATED_MOVIES_KEY"
        static let upComingMovies = "UP_COMING_MOVIES_KEY"
        static let nowPlayingMovies = "NOW_PLAYING_MOVIES_KEY"
        static let movieWithRate = "MOVIE_WITH_RATE_KEY"
        static let fromReleaseYear = "FROM_RELEASE_YEAR_KEY"
        static let releaseYear = "RELEASE_YEAR_KEY"
        static let rating = "RATING_KEY"
    }

    class func registerSettingsBundle() {
        let appDefaults = [String:AnyObject]()
        userDefault.register(defaults: appDefaults)
    }

    class func resetSettings() {
        let appDomain: String? = Bundle.main.bundleIdentifier
        userDefault.removePersistentDomain(forName: appDomain!)
    }

    class func updateSettings() {
        //If user would like to reset default
        //let appDomain: String? = Bundle.main.bundleIdentifier
        //userDefault.removePersistentDomain(forName: appDomain!)

        //let popularMovie: Bool = Bundle.main.object(forInfoDictionaryKey: "CFBundlePopularMovieBool") as! Bool
        //userDefault.set(false, forKey: BundleSettingsKey.popularMovies)
    }



    class func getMovieSettings() -> MovieSettings {
        let movieSettings = MovieSettings()
        movieSettings.popularMovies = userDefault.bool(forKey: BundleSettingsKey.popularMovies)
        return movieSettings
    }
}
