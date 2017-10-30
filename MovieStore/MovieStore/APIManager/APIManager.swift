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

class APIManager {
    var movies: [[String: Any?]] = []
    let headers: HTTPHeaders = [
        "X-Mashape-Key": APIKey,
        "Accept": "application/json"
    ]
    /*
    func aboutMovieStore() {
        let about = About()
        Alamofire.request(about.requestURLString, method: .get, parameters: nil).responseJSON(response in
            switch response.result {
                case let .success(response):

                case let .failure(error):
                    print(error)
            }
        }
    }*/

    func getPopularMovies() {
        let movieAPI = MovieAPI(popular: true)
        Alamofire.request(movieAPI.requestURLString, method: .get, parameters: nil).responseJSON{response in
            switch response.result {
                case let .success(response):
                    do {
                        let json = JSON(response)
                        json.forEach { (_, json) in
                            let movie: [String: Any?] = [
                                "movieId": json["movie_id"].int,
                                "title": json["title"].string,
                                "overview": json["overview"].string
                            ]
                            self.movies.append(movie)
                        }
                    }catch let e{
                        print(e)
                    }
                case let .failure(error):
                    print(error)
            }
        }
    }
}
