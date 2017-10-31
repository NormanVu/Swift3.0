//
//  Movie.swift
//  MovieStore
//
//  Created by Nhat (Norman) H.M. VU on 10/19/17.
//  Copyright © 2017 enclaveit. All rights reserved.
//

import Foundation
import Alamofire

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
    var voteAverage: Float?
    var voteCount: Int?
    var releaseDate: Date?

    var releaseYear: Int {
        get {
            let calendar = Calendar.current

            if let releaseDate = self.releaseDate {
                let components = (calendar as NSCalendar).components(.year, from: releaseDate)
                return components.year!
            } else {
                return 0
            }
        }
    }

    var releaseDateString: String {
        get {
            let dateTimeFormatter = DateFormatter()
            dateTimeFormatter.dateFormat = "yyyy-MM-dd"

            return dateTimeFormatter.string(from: self.releaseDate!)
        }
    }


    init(rawData: NSDictionary) {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd"

        self.movieId = rawData["id"] as! Int
        self.title = rawData["title"] as! String
        self.overview = rawData["overview"] as! String
        self.posterPath = rawData["poster_path"] as! String
        self.backdropPath = rawData["backdrop_path"] as! String
        self.voteAverage = rawData["vote_average"] as? Float
        self.voteCount = rawData["vote_count"] as? Int
        self.releaseDate = dateFormater.date(from: rawData["release_date"] as! String)
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


