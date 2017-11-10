//
//  Genres.swift
//  MovieStore
//
//  Created by Nhat (Norman) H.M. VU on 11/10/17.
//  Copyright © 2017 enclaveit. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class Genres: NSObject {
    var _genresId: Int?
    var genresId: Int? {
        get{
            return self._genresId!
        }
        set(newValue) {
            self._genresId = newValue
        }
    }

    var _genresName: String?
    var genresName: String? {
        get{
            return self._genresName!
        }
        set(newValue) {
            self._genresName = newValue
        }
    }

    var _genresImage: String?
    var genresImage: String? {
        get{
            return self._genresImage
        }
        set(newValue) {
            self._genresImage = newValue
        }
    }

    init(rawData: JSON) {
        self._genresId = rawData["id"].intValue
        self._genresName = rawData["name"].stringValue
        super.init()
    }

    public var genresImageURL: URL? {
        return URL(string: imageURLPrefix + "/w500" + self._genresImage!)
    }
}
