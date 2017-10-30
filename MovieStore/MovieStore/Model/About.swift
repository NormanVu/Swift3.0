//
//  About.swift
//  MovieStore
//
//  Created by Nhat (Norman) H.M. VU on 10/19/17.
//  Copyright © 2017 enclaveit. All rights reserved.
//

import Foundation
import Alamofire

class About {

    fileprivate var requestURLString: String!

    init() {//https://www.themoviedb.org/about/our-history
        requestURLString = "\(APIURLPrefix)/about"
    }
}
