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

final class APIManager: NSObject {
    var requestToken: String?

    var allMovies = [Movie]()
    static let sharedAPI = APIManager()

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

    func getRequestToken() -> Bool {
        let movieAPI = MovieAPI(requestToken: true)
        var result: Bool = false
        Alamofire.request(movieAPI.requestURLString, method: .get, parameters: movieAPI.parameters).responseJSON{ (dataResponse) -> Void in
            switch dataResponse.result {
            case let .success(dataResponse):
                do {
                    let json = JSON(dataResponse)
                    self.requestToken = json["request_token"].stringValue
                    result = true
                }catch let error {
                    print(error)
                }
            case let .failure(error):
                print(error)
            }
        }
        return result
    }

    func getPopularMovies(pageNumber: Int) {
        let movieAPI = MovieAPI(popular: true)
        movieAPI.parameters["page"] = pageNumber as AnyObject
        Alamofire.request(movieAPI.requestURLString, method: .get, parameters: movieAPI.parameters).responseJSON{ (dataResponse) -> Void in
            switch dataResponse.result {
                case let .success(dataResponse):
                    do {
                        let json = JSON(dataResponse)
                        for result in json["results"].arrayValue {
                            let movie = Movie(rawData: result)
                            //print(movie.toParameters())
                            self.allMovies.append(movie)
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
