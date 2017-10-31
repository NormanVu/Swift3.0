//
//  APIManager.swift
//  MovieStore
//
//  Created by Nhat (Norman) H.M. VU on 10/30/17.
//  Copyright © 2017 enclaveit. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class APIManager: NSObject {
    var movies: [[String: Any?]] = []
    var allMovies = [Movie]()

    static let sharedAPI = APIManager()
    private var currentMovieIndex = 0
    private var currentMovieData: [Movie]?

    override init() {
        super.init()
    }

    func get(_ index: Int) -> Movie? {
        return index < allMovies.count ? self.allMovies[index] : nil
    }

    var count: Int {
        get {
            return self.allMovies.count
        }
    }

    /*
    func aboutMovieStore() -> URLRequest {
        let movieAPI = MovieAPI()
        Alamofire.request(movieAPI.requestURLString, method: .get, parameters: nil).responseJSON{response in
            switch response.result {
                case let .success(response):
                    return
                case let .failure(error):
                    print(error)
            }
        }
    }*/


    func getPopularMovies(pageNumber: Int) {
        let movieAPI = MovieAPI(popular: true)
        movieAPI.parameters["page"] = pageNumber as AnyObject
        Alamofire.request(movieAPI.requestURLString, method: .get, parameters: movieAPI.parameters).responseJSON{ (dataResponse) -> Void in
            switch dataResponse.result {
                case let .success(dataResponse):
                    do {
                        let json = JSON(dataResponse)
                        for result in json["results"].arrayValue {
                            let movie: [String: Any?] = [
                                "movieId": result["id"].int,
                                "title": result["title"].string,
                                "overview": result["overview"].string,
                                "posterPath": result["poster_path"].string,
                                "backdropPath": result["backdrop_path"].string,
                                "voteAverage": result["vote_average"].float,
                                "voteCount": result["vote_count"].int,
                                "releaseDate": result["release_date"].string
                            ]
                            print(movie)
                            self.movies.append(movie)
                        }
                    }catch let error {
                        print(error)
                    }
                case let .failure(error):
                    print(error)
            }
        }

    }


}
