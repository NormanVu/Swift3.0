//
//  MovieCollection.swift
//  MovieStore
//
//  Created by Nhat (Norman) H.M. VU on 10/19/17.
//  Copyright © 2017 enclaveit. All rights reserved.
//

import Foundation

class MovieCollection {

    enum TypeCollection: Int {
        case popular = 1
        case topRated = 2
        case nowPlaying = 3
        case upComing = 4
        case credit = 5
        case search = 6
    }

    var movies = [Movie]()
    var type: TypeCollection = .popular

    fileprivate var requestURLString: String!
    fileprivate var parameters: Dictionary<String, AnyObject> = [
        "api_key": APIKey as AnyObject
    ]
    fileprivate var currentPage: Int = -1

    var count: Int {
        get {
            return self.movies.count
        }
    }

    func get(_ index: Int) -> Movie? {
        return index < movies.count ? self.movies[index] : nil
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

    init(search: String) {//https://api.themoviedb.org/3/search/movie
        requestURLString = "\(APIURLPrefix)/search/movie"
        parameters["query"] = search as AnyObject
        type = .search
    }
}
