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
import MBProgressHUD

class APIManager: NSObject {

    var typeMovie: TypeCollection?
    public var requestToken: String?
    public var sessionID: String?
    public var userID: Int?
    public var statusCode: Int?
    public var genresImagePath: String?
    public var allMovies = [Movie]()
    public var favoriteMovies = [Movie]()
    public var favoriteTotalPages: Int?
    public var favoriteTotalResults: Int?
    public var allGenres = [Genres]()
    static let sharedAPI = APIManager()

    var pagedResults = [Any]()

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
    func getRequestToken(completionHandler: ((UIBackgroundFetchResult) -> Void)!) {
        let movieAPI = MovieAPI(requestToken: true)
        Alamofire.request(movieAPI.requestURLString, method: .get, parameters: movieAPI.parameters).responseJSON{ (dataResponse) -> Void in
            if((dataResponse.result.value) != nil) {
                let json = JSON(dataResponse.result.value!)
                self.requestToken = json["request_token"].stringValue
                print("Step 1: Create a new request token is successfully!!!")
                print("request_token: " + self.requestToken!)
                completionHandler(UIBackgroundFetchResult.newData)
            }
        }
    }

    //Step 2: Ask the user for permission via the API
    func loginWithToken(validateRequestToken: String, completionHandler: ((UIBackgroundFetchResult) -> Void)!) {
        let movieAPI = MovieAPI(validateRequestToken: validateRequestToken)
        print("Request token in step 2: \(validateRequestToken)")
        Alamofire.request(movieAPI.requestURLString, method: .get, parameters: movieAPI.parameters).responseJSON{ (dataResponse) -> Void in
            if((dataResponse.result.value) != nil) {
                print("Step 2: Ask the user for permission via the API is successfully!!!")
                completionHandler(UIBackgroundFetchResult.newData)
            }
        }
    }

    //Step 3: Create a session ID
    func getSessionID(requestToken: String, completionHandler: ((UIBackgroundFetchResult) -> Void)!) {
        let movieAPI = MovieAPI(requestNewToken: self.requestToken!)
        Alamofire.request(movieAPI.requestURLString, method: .get, parameters: movieAPI.parameters).responseJSON{ (dataResponse) -> Void in
            if((dataResponse.result.value) != nil) {
                let json = JSON(dataResponse.result.value!)
                let sessionID = json["session_id"].stringValue
                self.sessionID = sessionID
                print("Step 3: Create a session ID \(self.sessionID) is successfully!!!")
                print(sessionID)
                completionHandler(UIBackgroundFetchResult.newData)
            }
        }
    }

    //Step 4: Get the user id
    func getUserID(sessionID: String, completionHandler: ((UIBackgroundFetchResult) -> Void)!) {
        let movieAPI = MovieAPI(sessionId: sessionID)
        print("Get the user id with session id \(sessionID)")
        Alamofire.request(movieAPI.requestURLString, method: .get, parameters: movieAPI.parameters).responseJSON{ (dataResponse) -> Void in
            if((dataResponse.result.value) != nil) {
                let json = JSON(dataResponse.result.value!)
                let userID = json["id"].intValue
                self.userID = userID
                print("Step 4: Get the user ID is successfully!!!")
                print(userID)
                completionHandler(UIBackgroundFetchResult.newData)
            }
        }
    }

    //Step 5: Get favorite movies
    func getFavoriteMovies(userID: Int, sessionID: String, completionHandler: ((UIBackgroundFetchResult) -> Void)!) {
        let movieAPI = MovieAPI(userId: userID, sessionId: sessionID)
        print("Get favorite movies with session id \(sessionID)")
        self.favoriteMovies.removeAll()
        Alamofire.request(movieAPI.requestURLString, method: .get, parameters: movieAPI.parameters).responseJSON{ (dataResponse) -> Void in
            if((dataResponse.result.value) != nil) {
                let json = JSON(dataResponse.result.value!)
                for result in json["results"].arrayValue {
                    let movie = Movie(rawData: result)
                    self.favoriteMovies.append(movie)
                }
                self.favoriteTotalPages = json["total_pages"].intValue
                self.favoriteTotalResults = json["total_results"].intValue
                if (self.favoriteMovies.count > 0) {
                    print("Get favorite movies are successfully!!!")
                    completionHandler(UIBackgroundFetchResult.newData)
                } else {
                    print("None favorite movies!!!")
                }
            }
        }
    }

    func getPopularMovies(currentPage: Int, completionHandler: ((UIBackgroundFetchResult) -> Void)!) {
        let movieAPI = MovieAPI(popular: true)
        typeMovie = .popular
        movieAPI.parameters["page"] = currentPage as AnyObject
        Alamofire.request(movieAPI.requestURLString, method: .get, parameters: movieAPI.parameters).responseJSON{[weak self] (dataResponse) -> Void in
            if let strongSelf = self {
                if((dataResponse.result.value) != nil) {
                    let json = JSON(dataResponse.result.value!)
                    let totalPages = json["total_pages"].intValue
                    let currentPage = json["page"].intValue
                    print("Page = \(currentPage)")
                    //Merging data current page
                    if (json["results"].arrayObject != nil) {
                        let results = json["results"].arrayObject!
                        strongSelf.pagedResults += results
                    } else {
                        strongSelf.pagedResults = (self?.pagedResults)!
                    }
                    //Next page
                    if (currentPage < totalPages) {
                        strongSelf.getPopularMovies(currentPage: currentPage + 1, completionHandler: completionHandler)
                    } else {
                        //Parsing data
                        let rawData = JSON(strongSelf.pagedResults)
                        for i in 0..<rawData.count {
                            let movie = Movie(rawData: rawData[i])
                            strongSelf.allMovies.append(movie)
                        }
                    }
                    completionHandler(UIBackgroundFetchResult.newData)
                }
            }
        }
    }

    func getTopRatingMovies(completionHandler: ((UIBackgroundFetchResult) -> Void)!) {
        let movieAPI = MovieAPI(topRated: true)
        typeMovie = .topRated
        self.allMovies.removeAll()
        Alamofire.request(movieAPI.requestURLString, method: .get, parameters: movieAPI.parameters).responseJSON{ (dataResponse) -> Void in
            if((dataResponse.result.value) != nil) {
                let json = JSON(dataResponse.result.value!)
                for result in json["results"].arrayValue {
                    let movie = Movie(rawData: result)
                    self.allMovies.append(movie)
                }
                if (self.allMovies.count > 0) {
                    print("Get top rating movies are successfully!!!")
                    completionHandler(UIBackgroundFetchResult.newData)
                }
            }
        }
    }

    func getNowPlayingMovies(completionHandler: ((UIBackgroundFetchResult) -> Void)!) {
        let movieAPI = MovieAPI(nowPlaying: true)
        typeMovie = .nowPlaying
        self.allMovies.removeAll()
        Alamofire.request(movieAPI.requestURLString, method: .get, parameters: movieAPI.parameters).responseJSON{ (dataResponse) -> Void in
            if((dataResponse.result.value) != nil) {
                let json = JSON(dataResponse.result.value!)
                for result in json["results"].arrayValue {
                    let movie = Movie(rawData: result)
                    self.allMovies.append(movie)
                }
                if (self.allMovies.count > 0) {
                    print("Get now playing movies are successfully!!!")
                    completionHandler(UIBackgroundFetchResult.newData)
                }
            }
        }
    }

    func getUpComingMovies(completionHandler: ((UIBackgroundFetchResult) -> Void)!) {
        let movieAPI = MovieAPI(upComing: true)
        typeMovie = .upComing
        self.allMovies.removeAll()
        Alamofire.request(movieAPI.requestURLString, method: .get, parameters: movieAPI.parameters).responseJSON{ (dataResponse) -> Void in
            if((dataResponse.result.value) != nil) {
                let json = JSON(dataResponse.result.value!)
                for result in json["results"].arrayValue {
                    let movie = Movie(rawData: result)
                    self.allMovies.append(movie)
                }
                if (self.allMovies.count > 0) {
                    print("Get up coming movies are successfully!!!")
                    completionHandler(UIBackgroundFetchResult.newData)
                }
            }
        }
    }

    func setFavoriteMovies(mediaID: Int, userID: Int, sessionID: String, favorite: Bool, completionHandler: ((UIBackgroundFetchResult) -> Void)!) {
        let movieAPI = MovieAPI(mediaId: mediaID, userId: userID, sessionId: sessionID, favorite: favorite)
        Alamofire.request(movieAPI.requestURLString, method: .post, parameters: movieAPI.parameters).responseJSON{ (dataResponse) -> Void in
            if((dataResponse.result.value) != nil) {
                let json = JSON(dataResponse.result.value!)
                if (json["status_code"] == 1 || json["status_code"] == 12 || json["status_code"] == 13) {
                    self.statusCode = json["status_code"].intValue
                    print("Mark favorite movie is successfully!!!")
                    completionHandler(UIBackgroundFetchResult.newData)
                }

            }
        }
    }

    func getMovieDetail(movieID: Int, completionHandler: ((UIBackgroundFetchResult) -> Void)!) {
        let movieAPI = MovieAPI(movieId: movieID)
        self.allGenres.removeAll()
        Alamofire.request(movieAPI.requestURLString, method: .get, parameters: movieAPI.parameters).responseJSON{ (dataResponse) -> Void in
            if((dataResponse.result.value) != nil) {
                let json = JSON(dataResponse.result.value!)
                print(json)
                for genres in json["genres"].arrayValue {
                    let _genres = Genres(rawData: genres)
                    self.allGenres.append(_genres)
                }
                completionHandler(UIBackgroundFetchResult.newData)
            }
        }
    }

    func getGenresDetail(genresID: Int, completionHandler: ((UIBackgroundFetchResult) -> Void)!) {
        let movieAPI = MovieAPI(genresId: genresID)
        Alamofire.request(movieAPI.requestURLString, method: .get, parameters: movieAPI.parameters).responseJSON{ (dataResponse) -> Void in
            if((dataResponse.result.value) != nil) {
                let json = JSON(dataResponse.result.value!)
                if (json["profile_path"].exists()) {
                    self.genresImagePath = json["profile_path"].stringValue
                    print("Get image profile path: \(self.genresImagePath)")
                    completionHandler(UIBackgroundFetchResult.newData)
                }
            }
        }
    }
}
