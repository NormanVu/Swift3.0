//
//  UserDefaultManager.swift
//  MovieStore
//
//  Created by Nhat (Norman) H.M. VU on 11/6/17.
//  Copyright © 2017 enclaveit. All rights reserved.
//

import Foundation
import UIKit

class UserDefaultManager {
    struct MovieSettingsKey {
        static let popularMovies = "POPULAR_MOVIES_KEY"
        static let topRatedMovies = "TOP_RATED_MOVIES_KEY"
        static let upComingMovies = "UP_COMING_MOVIES_KEY"
        static let nowPlayingMovies = "NOW_PLAYING_MOVIES_KEY"
        static let movieWithRate = "MOVIE_WITH_RATE_KEY"
        static let fromReleaseYear = "FROM_RELEASE_YEAR_KEY"
        static let releaseDate = "RELEASE_DATE_KEY"
        static let rating = "RATING_KEY"
    }

    struct ProfileKey {
        static let userID = "USER_ID_KEY"
        static let sessionID = "SESSION_ID_KEY"
        static let avatar = "AVATAR_KEY"
        static let email = "EMAIL_KEY"
        static let gender = "GENDER_KEY"
        static let userName = "USER_NAME_KEY"
        static let birthday = "BIRTHDAY_KEY"
    }

    class func updateSettings(movieSettings: MovieSettings) {
        

        //Popular Movies
        userDefault.set(movieSettings.popularMovies, forKey: MovieSettingsKey.popularMovies)
        
        //Top rated Movies
        userDefault.set(movieSettings.topRatedMovies, forKey: MovieSettingsKey.topRatedMovies)
        
        //Up coming Movies
        userDefault.set(movieSettings.upComingMovies, forKey: MovieSettingsKey.upComingMovies)
        
        //Now playing Movies
        userDefault.set(movieSettings.nowPlayingMovies, forKey: MovieSettingsKey.nowPlayingMovies)
        
        //Movie with rate
        userDefault.set(movieSettings.movieWithRate, forKey: MovieSettingsKey.movieWithRate)
        
        //From release year
        userDefault.set(movieSettings.fromReleaseYear, forKey: MovieSettingsKey.fromReleaseYear)
        
        //Release Date Movies
        userDefault.set(movieSettings.releaseDate, forKey: MovieSettingsKey.releaseDate)

        //Rating Movie
        userDefault.set(movieSettings.rating, forKey: MovieSettingsKey.rating)
    }


    class func getMovieSettings() -> MovieSettings {
        let movieSettings = MovieSettings()
        //Popular Movies
        let popularMovies = userDefault.object(forKey: MovieSettingsKey.popularMovies)
        if let popularMovie = popularMovies as? Bool {
            movieSettings.popularMovies = popularMovie
        }
        //Top rated Movies
        let topRatedMovies = userDefault.object(forKey: MovieSettingsKey.topRatedMovies)
        if let topRatedMovie = topRatedMovies as? Bool {
            movieSettings.topRatedMovies = topRatedMovie
        }
        //Up coming Movies
        let upComingMovies = userDefault.object(forKey: MovieSettingsKey.upComingMovies)
        if let upComingMovie = upComingMovies as? Bool {
            movieSettings.upComingMovies = upComingMovie
        }
        //Now playing Movies
        let nowPlayingMovies = userDefault.object(forKey: MovieSettingsKey.nowPlayingMovies)
        if let nowPlayingMovie = nowPlayingMovies as? Bool {
            movieSettings.nowPlayingMovies = nowPlayingMovie
        }
        //Movie with rate
        let movieWithRates = userDefault.object(forKey: MovieSettingsKey.movieWithRate)
        if let movieWithRate = movieWithRates as? Float {
            movieSettings.movieWithRate = movieWithRate
        }
        //From release year
        let fromReleaseYears = userDefault.object(forKey: MovieSettingsKey.fromReleaseYear)
        if let fromReleaseYear = fromReleaseYears as? Int {
            movieSettings.fromReleaseYear = fromReleaseYear
        }
        //Release Date Movies
        let releaseDateMovies = userDefault.object(forKey: MovieSettingsKey.releaseDate)
        if let releaseDateMovie = releaseDateMovies as? Bool {
            movieSettings.releaseDate = releaseDateMovie
        }
        //Rating Movie
        let ratingMovies = userDefault.object(forKey: MovieSettingsKey.rating)
        if let ratingMovie = ratingMovies as? Bool {
            movieSettings.rating = ratingMovie
        }
        return movieSettings
    }

    class func updateProfile(userProfile: Profile) {
        //User id
        userDefault.set(userProfile.userId, forKey: ProfileKey.userID)

        //Session id
        userDefault.set(userProfile.sessionId, forKey: ProfileKey.sessionID)

        //Avatar
        //@TODO: Can't store UIImage
        //userDefault.set(userProfile.avatar, forKey: ProfileKey.avatar)

        //Email
        userDefault.set(userProfile.email, forKey: ProfileKey.email)

        //Gender
        userDefault.set(userProfile.gender, forKey: ProfileKey.gender)

        //User name
        userDefault.set(userProfile.userName, forKey: ProfileKey.userName)

        //Birthday
        userDefault.set(userProfile.birthday, forKey: ProfileKey.birthday)

    }

    class func getUserProfile() -> Profile {
        let userProfile = Profile()
        //User id
        let userID = userDefault.object(forKey: ProfileKey.userID)
        if let _userId = userID as? Int {
            userProfile.userId = _userId
        }

        //Session id
        let sessionID = userDefault.object(forKey: ProfileKey.sessionID)
        if let _sessionId = sessionID as? String {
            userProfile.sessionId = _sessionId
        }

        //Avatar
        //@TODO: Can't store UIImage
        /*
        let avatar = userDefault.object(forKey: ProfileKey.avatar)
        if let _avatar = avatar as? UIImage {
            userProfile.avatar = _avatar
        }*/

        //Email
        let email = userDefault.object(forKey: ProfileKey.email)
        if let _email = email as? String {
            userProfile.email = _email
        }

        //Gender
        let gender = userDefault.object(forKey: ProfileKey.gender)
        if let _gender = gender as? Bool {
            userProfile.gender = _gender
        }

        //User name
        let userName = userDefault.object(forKey: ProfileKey.userName)
        if let _userName = userName as? String {
            userProfile.userName = _userName
        }

        //Birthday
        let birthday = userDefault.object(forKey: ProfileKey.birthday)
        if let _birthday = birthday as? Date {
            userProfile.birthday = _birthday
        }
        return userProfile
    }
}
