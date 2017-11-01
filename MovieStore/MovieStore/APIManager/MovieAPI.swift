//
//  MovieAPI.swift
//  MovieStore
//
//  Created by Nhat (Norman) H.M. VU on 10/30/17.
//  Copyright © 2017 enclaveit. All rights reserved.
//

import Foundation

class MovieAPI {
    enum TypeCollection: Int {
        case popular = 1
        case topRated = 2
        case nowPlaying = 3
        case upComing = 4
        case credit = 5
        case search = 6
    }

    var type: TypeCollection = .popular

    var requestURLString: String

    var parameters: Dictionary<String, AnyObject> = [
        "api_key": APIKey as AnyObject
    ]

    init() {//https://www.themoviedb.org/about
        requestURLString = "\(APIURLPrefix)/about"
    }

    init(popular: Bool) {//https://api.themoviedb.org/3/movie/popular
        requestURLString = "\(APIURLPrefix)/movie/popular"
        if (popular) {
            type = .popular
        }
    }

    init(topRated: Bool) {//https://api.themoviedb.org/3/movie/top_rated
        requestURLString = "\(APIURLPrefix)/movie/top_rated"
        if (topRated) {
            type = .topRated
        }
    }

    init(nowPlaying: Bool) {//https://api.themoviedb.org/3/movie/now_playing
        requestURLString = "\(APIURLPrefix)/movie/now_playing"
        if (nowPlaying) {
            type = .nowPlaying
        }
    }

    init(upComing: Bool) {//https://api.themoviedb.org/3/movie/upcoming
        requestURLString = "\(APIURLPrefix)/movie/upcoming"
        if (upComing) {
            type = .upComing
        }
    }

    init(movieId: Int) {//https://api.themoviedb.org/3/movie/{movie_id}/credits
        requestURLString = "\(APIURLPrefix)/movie/\(movieId)/credits"
        parameters["movie_id"] = movieId as AnyObject
        type = .credit
    }

    init(searchText: String) {//https://api.themoviedb.org/3/search/movie
        requestURLString = "\(APIURLPrefix)/search/movie"
        parameters["query"] = searchText as AnyObject
        type = .search
    }

    init(requestToken: Bool) {
        requestURLString = "\(APIURLPrefix)/authentication/token/new"
        if (requestToken) {
            print("Request token")
        }
    }

    init(validateRequestToken: String) {
        requestURLString = "\(APIURLPrefix)/authentication/token/validate_with_login"
        parameters["request_token"] = validateRequestToken as AnyObject
    }

    init(requestToken: String) {
        requestURLString = "\(APIURLPrefix)/authentication/session/new"
        parameters["request_token"] = requestToken as AnyObject
    }

    init(sessionId: String) {//https://www.themoviedb.org/account
        requestURLString = "\(APIURLPrefix)/account"
        parameters["session_id"] = sessionId as AnyObject
    }
}
