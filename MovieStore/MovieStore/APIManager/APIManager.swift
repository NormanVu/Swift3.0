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
    func getRequestToken() -> Bool {
        let movieAPI = MovieAPI(requestToken: true)
        var result: Bool = false
        Alamofire.request(movieAPI.requestURLString, method: .get, parameters: movieAPI.parameters).responseJSON{ (dataResponse) -> Void in
            if((dataResponse.result.value) != nil) {
                let json = JSON(dataResponse.result.value!)
                self.requestToken = json["request_token"].stringValue
                result = true
                print(json)
            }
        }
        return result
    }

    //Step 2: Ask the user for permission via the API
    func loginWithToken(requestToken: String) -> Bool {
        if (requestToken != self.requestToken) {
            self.requestToken = requestToken
        }
        var result: Bool = false
        let movieAPI = MovieAPI(validateRequestToken: self.requestToken!)
        Alamofire.request(movieAPI.requestURLString, method: .get, parameters: movieAPI.parameters).responseJSON{ (dataResponse) -> Void in
            if((dataResponse.result.value) != nil) {
                let json = JSON(dataResponse.result.value!)
                result = json["success"].boolValue
                print(result)
            }
        }
        return result
    }

    //Step 3: Create a session ID
    func getSessionID(requestToken: String) {
        if (requestToken != self.requestToken) {
            self.requestToken = requestToken
        }
        let movieAPI = MovieAPI(requestToken: self.requestToken!)
        Alamofire.request(movieAPI.requestURLString, method: .get, parameters: movieAPI.parameters).responseJSON{ (dataResponse) -> Void in
            if((dataResponse.result.value) != nil) {
                let json = JSON(dataResponse.result.value!)
                let sessionID = json["session_id"].stringValue
                self.sessionID = sessionID
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
                print(sessionID)
            }
        }
    }

    func getPopularMovies(pageNumber: Int) {
        let movieAPI = MovieAPI(popular: true)
        movieAPI.parameters["page"] = pageNumber as AnyObject
        Alamofire.request(movieAPI.requestURLString, method: .get, parameters: movieAPI.parameters).responseJSON{ (dataResponse) -> Void in
            if((dataResponse.result.value) != nil) {
                let json = JSON(dataResponse.result.value!)
                for result in json["results"].arrayValue {
                    let movie = Movie(rawData: result)
                    self.allMovies.append(movie)
                }
            }
        }
    }

    //Step 5: Get favorite movies
    func getFavoriteMovies(userId: Int, sessionId: String) {
        let movieAPI = MovieAPI(userId: userId, sessionId: sessionId)
        Alamofire.request(movieAPI.requestURLString, method: .get, parameters: movieAPI.parameters).responseJSON{ (dataResponse) -> Void in
            if((dataResponse.result.value) != nil) {
                let json = JSON(dataResponse.result.value!)
                for result in json["results"].arrayValue {
                    let movie = Movie(rawData: result)
                    self.allMovies.append(movie)
                }
            }
        }
    }
}
