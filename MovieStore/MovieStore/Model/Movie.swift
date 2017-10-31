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

class Movie {
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




    init(rawData: JSON) {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd"

        self.movieId = rawData["id"].int!
        self.title = rawData["title"].string!
        self.overview = rawData["overview"].string!
        self.posterPath = rawData["poster_path"].string!
        self.backdropPath = rawData["backdrop_path"].string!
        self.voteAverage = rawData["vote_average"].float!
        self.voteCount = rawData["vote_count"].int!
        self.releaseDate = dateFormater.date(from: (rawData["release_date"].string)!)!
    }

    func toParameters() -> [String : Any] {
        let parameters = ["id" : movieId, "title" : title, "overview" : overview, "poster_path": posterPath, "backdrop_path": backdropPath as Any, "vote_average": voteAverage as Any, "vote_count": voteCount as Any, "release_date": releaseDate as Any] as [String : Any]
        return parameters
    }

    public var backdropURL: URL? {
        return URL(string: imageURLPrefix + "/w500" + self.backdropPath)
    }

    public var iconURL: URL? {
        return URL(string: imageURLPrefix + "/w75" + self.backdropPath)
    }
}


