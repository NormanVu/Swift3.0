//
//  Movie.swift
//  MovieStore
//
//  Created by Nhat (Norman) H.M. VU on 10/19/17.
//  Copyright © 2017 enclaveit. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class Movie: NSObject {
    enum ImageSize: Int {
        case small = 0
        case medium = 1
        case large = 2
    }

    var movieId: Int
    var title: String
    var overview: String
    var posterPath: String
    var backdropPath: String
    var voteAverage: Float
    var voteCount: Int
    var releaseDate: Date
    var genres = [Genres]()

    var _isFavorited: Bool?
    var isFavorited: Bool? {
        get{
            return self._isFavorited
        }
        set(newValue) {
            self._isFavorited = newValue
        }
    }

    var _userId: Int?
    var userId: Int? {
        get{
            return self._userId
        }
        set(newValue) {
            self._userId = newValue
        }
    }

    var _sessionId: String?
    var sessionId: String? {
        get{
            return self._sessionId
        }
        set(newValue) {
            self._sessionId = newValue
        }
    }

    init(rawData: JSON) {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd"

        self.movieId = rawData["id"].intValue
        self.title = rawData["title"].stringValue
        self.overview = rawData["overview"].stringValue
        self.posterPath = rawData["poster_path"].stringValue
        self.backdropPath = rawData["backdrop_path"].stringValue
        self.voteAverage = rawData["vote_average"].floatValue
        self.voteCount = rawData["vote_count"].intValue
        self.releaseDate = dateFormater.date(from: rawData["release_date"].stringValue)!
        super.init()
    }

    func toParameters() -> [String : Any] {
        let parameters = ["id" : movieId, "title" : title, "overview" : overview, "poster_path": posterPath, "backdrop_path": backdropPath, "vote_average": voteAverage, "vote_count": voteCount, "release_date": releaseDate] as [String : Any]
        return parameters
    }

    public var backdropURL: URL? {
        return URL(string: imageURLPrefix + "/w500" + self.backdropPath)
    }

    public var posterURL: URL? {
        return URL(string: imageURLPrefix + "/w500" + self.posterPath)
    }
}


