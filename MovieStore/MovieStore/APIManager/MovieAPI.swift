//
//  MovieAPI.swift
//  MovieStore
//
//  Created by Nhat (Norman) H.M. VU on 10/30/17.
//  Copyright © 2017 enclaveit. All rights reserved.
//

import Foundation

class MovieAPI: NSObject {

    var type: TypeCollection = .popular

    var requestURLString: String

    var parameters: Dictionary<String, AnyObject> = [
        "api_key": APIKey as AnyObject
    ]

    override init() {//https://www.themoviedb.org/about
        requestURLString = "\(APIURLPrefix)/about"
        super.init()
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

    init(movieId: Int, isCredit: Bool) {//https://api.themoviedb.org/3/movie/{movie_id}/credits
        requestURLString = "\(APIURLPrefix)/movie/\(movieId)/credits"
        parameters["movie_id"] = movieId as AnyObject
        type = .credit
    }

    init(movieId: Int) {//https://api.themoviedb.org/3/movie/{movie_id}
        requestURLString = "\(APIURLPrefix)/movie/\(movieId)"
        parameters["movie_id"] = movieId as AnyObject
    }


    init(searchText: String) {//https://api.themoviedb.org/3/search/movie
        requestURLString = "\(APIURLPrefix)/search/movie"
        parameters["query"] = searchText as AnyObject
        type = .search
    }

    init(requestToken: Bool) {//https://api.themoviedb.org/3/authentication/token/new
        requestURLString = "\(APIURLPrefix)/authentication/token/new"
        if (requestToken) {
            print("Request token")
        }
    }

    init(validateRequestToken: String) {//https://api.themoviedb.org/3/authentication/token/validate_with_login
        requestURLString = "\(APIURLPrefix)/authentication/token/validate_with_login"
        parameters["request_token"] = validateRequestToken as AnyObject
        parameters["username"] = "NormanVu" as AnyObject
        parameters["password"] = "1234567890" as AnyObject
    }

    init(requestNewToken: String) {//https://api.themoviedb.org/3/authentication/session/new
        requestURLString = "\(APIURLPrefix)/authentication/session/new"
        parameters["request_token"] = requestNewToken as AnyObject
    }

    init(sessionId: String) {//https://www.themoviedb.org/account
        requestURLString = "\(APIURLPrefix)/account"
        parameters["session_id"] = sessionId as AnyObject
    }

    init(userId: Int, sessionId: String) {//https://www.themoviedb.org/account/{user_id}/favorite/movies
        requestURLString = "\(APIURLPrefix)/account/\(userId)/favorite/movies"
        parameters["session_id"] = sessionId as AnyObject
    }

    init(mediaId: Int, userId: Int, sessionId: String, favorite: Bool) {
        //POST: https://www.themoviedb.org/account/{account_id}/favorite
        requestURLString = "\(APIURLPrefix)/account/\(userId)/favorite"
        parameters["session_id"] = sessionId as AnyObject
        parameters["media_type"] = "movie" as AnyObject
        parameters["media_id"] = mediaId as AnyObject
        parameters["favorite"] = favorite as AnyObject
    }
}
