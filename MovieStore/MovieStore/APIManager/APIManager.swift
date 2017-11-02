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

//TODO: After calling
final class APIManager: NSObject {

    var typeMovie: TypeCollection?
    public var requestToken: String?
    public var sessionID: String?
    public var userID: Int?
    public var allMovies = [Movie]()
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

    //Step 1: Create a new request token
    func getRequestToken(){
        let movieAPI = MovieAPI(requestToken: true)
        Alamofire.request(movieAPI.requestURLString, method: .get, parameters: movieAPI.parameters).responseJSON{ (dataResponse) -> Void in
            if((dataResponse.result.value) != nil) {
                let json = JSON(dataResponse.result.value!)
                self.requestToken = json["request_token"].stringValue
                print("Step 1: Create a new request token is successfully!!!")
                print("request_token: " + self.requestToken!)
            }
        }
    }

    //Step 2: Ask the user for permission via the API
    func loginWithToken() {
        let movieAPI = MovieAPI(validateRequestToken: self.requestToken!)
        Alamofire.request(movieAPI.requestURLString, method: .get, parameters: movieAPI.parameters).responseJSON{ (dataResponse) -> Void in
            if((dataResponse.result.value) != nil) {
                let json = JSON(dataResponse.result.value!)
                print("Step 2: Ask the user for permission via the API is successfully!!!")
                print(json["success"].boolValue)
            }
        }
    }

    //Step 3: Create a session ID
    func getSessionID(requestToken: String) {
        let movieAPI = MovieAPI(requestNewToken: self.requestToken!)
        Alamofire.request(movieAPI.requestURLString, method: .get, parameters: movieAPI.parameters).responseJSON{ (dataResponse) -> Void in
            if((dataResponse.result.value) != nil) {
                let json = JSON(dataResponse.result.value!)
                let sessionID = json["session_id"].stringValue
                self.sessionID = sessionID
                print("Step 3: Create a session ID is successfully!!!")
                print(sessionID)
            }
        }
    }

    //Step 4: Get the user id
    func getUserID(sessionID: String) {
        let movieAPI = MovieAPI(sessionId: sessionID)
        Alamofire.request(movieAPI.requestURLString, method: .get, parameters: movieAPI.parameters).responseJSON{ (dataResponse) -> Void in
            if((dataResponse.result.value) != nil) {
                let json = JSON(dataResponse.result.value!)
                let userID = json["id"].intValue
                self.userID = userID
                print("Step 4: Get the user ID is successfully!!!")
                print(userID)
            }
        }
    }

    func getPopularMovies(completionHandler: ((UIBackgroundFetchResult) -> Void)!) {
        let movieAPI = MovieAPI(popular: true)
        typeMovie = .popular
        Alamofire.request(movieAPI.requestURLString, method: .get, parameters: movieAPI.parameters).responseJSON{ (dataResponse) -> Void in
            if((dataResponse.result.value) != nil) {
                let json = JSON(dataResponse.result.value!)
                for result in json["results"].arrayValue {
                    let movie = Movie(rawData: result)
                    self.allMovies.append(movie)
                }
                if (self.allMovies.count > 0) {
                    print("Get popular movies are successfully!!!")
                    completionHandler(UIBackgroundFetchResult.newData)
                }
            }
        }
    }

    func getTopRatingMovies(pageNumber: Int) {
        let movieAPI = MovieAPI(topRated: true)
        typeMovie = .topRated
        movieAPI.parameters["page"] = pageNumber as AnyObject
        Alamofire.request(movieAPI.requestURLString, method: .get, parameters: movieAPI.parameters).responseJSON{ (dataResponse) -> Void in
            if((dataResponse.result.value) != nil) {
                let json = JSON(dataResponse.result.value!)
                for result in json["results"].arrayValue {
                    let movie = Movie(rawData: result)
                    self.allMovies.append(movie)
                }
                if (self.allMovies.count > 0) {
                    print("Get top rating movies are successfully!!!")
                }
            }
        }
    }

    func getNowPlayingMovies(pageNumber: Int) {
        let movieAPI = MovieAPI(nowPlaying: true)
        typeMovie = .nowPlaying
        movieAPI.parameters["page"] = pageNumber as AnyObject
        Alamofire.request(movieAPI.requestURLString, method: .get, parameters: movieAPI.parameters).responseJSON{ (dataResponse) -> Void in
            if((dataResponse.result.value) != nil) {
                let json = JSON(dataResponse.result.value!)
                for result in json["results"].arrayValue {
                    let movie = Movie(rawData: result)
                    self.allMovies.append(movie)
                }
                if (self.allMovies.count > 0) {
                    print("Get now playing movies are successfully!!!")
                }
            }
        }
    }

    func getUpComingMovies(pageNumber: Int) {
        let movieAPI = MovieAPI(upComing: true)
        typeMovie = .upComing
        movieAPI.parameters["page"] = pageNumber as AnyObject
        Alamofire.request(movieAPI.requestURLString, method: .get, parameters: movieAPI.parameters).responseJSON{ (dataResponse) -> Void in
            if((dataResponse.result.value) != nil) {
                let json = JSON(dataResponse.result.value!)
                for result in json["results"].arrayValue {
                    let movie = Movie(rawData: result)
                    self.allMovies.append(movie)
                }
                if (self.allMovies.count > 0) {
                    print("Get up coming movies are successfully!!!")
                }
            }
        }
    }

    //Step 5: Get favorite movies
    func getFavoriteMovies() {
        let movieAPI = MovieAPI(userId: self.userID!, sessionId: self.sessionID!)
        Alamofire.request(movieAPI.requestURLString, method: .get, parameters: movieAPI.parameters).responseJSON{ (dataResponse) -> Void in
            if((dataResponse.result.value) != nil) {
                let json = JSON(dataResponse.result.value!)
                for result in json["results"].arrayValue {
                    let movie = Movie(rawData: result)
                    self.allMovies.append(movie)
                }
                if (self.allMovies.count > 0) {
                    print("Get favorite movies are successfully!!!")
                }
            }
        }
    }
}
