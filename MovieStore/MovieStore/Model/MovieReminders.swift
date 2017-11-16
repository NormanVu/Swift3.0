//
//  MovieReminders.swift
//  MovieStore
//
//  Created by Nhat (Norman) H.M. VU on 11/8/17.
//  Copyright © 2017 enclaveit. All rights reserved.
//

import Foundation

class MovieReminders: NSObject {
    var _movieId: Int?
    var movieId: Int? {
        get{
            return self._movieId
        }
        set(newValue) {
            self._movieId = newValue
        }
    }

    var _voteAverage: Float?
    var voteAverage: Float? {
        get{
            return self._voteAverage
        }
        set(newValue) {
            self._voteAverage = newValue
        }
    }

    var _title: String?
    var title: String? {
        get{
            return self._title
        }
        set(newValue) {
            self._title = newValue
        }
    }

    var _releaseDate: Date?
    var releaseDate: Date? {
        get{
            return self._releaseDate
        }
        set(newValue) {
            self._releaseDate = newValue
        }
    }

    var _movieReminderImagePath: String?
    var movieReminderImagePath: String? {
        get{
            return self._movieReminderImagePath
        }
        set(newValue) {
            self._movieReminderImagePath = newValue
        }
    }


    override init() {
        super.init()
    }

    public var imagePathURL: URL? {
        return URL(string: imageURLPrefix + "/w500" + self.movieReminderImagePath!)
    }
}
