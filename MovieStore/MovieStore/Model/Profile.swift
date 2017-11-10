//
//  UserProfile.swift
//  MovieStore
//
//  Created by Nhat (Norman) H.M. VU on 11/8/17.
//  Copyright © 2017 enclaveit. All rights reserved.
//

import Foundation
import UIKit

class Profile: NSObject {
    var _userId: Int?
    var userId: Int? {
        get{
            return self._userId!
        }
        set(newValue) {
            self._userId = newValue
        }
    }

    var _sessionId: String?
    var sessionId: String? {
        get{
            return self._sessionId!
        }
        set(newValue) {
            self._sessionId = newValue
        }
    }

    var _avatar: UIImage?
    var avatar: UIImage? {
        get{
            return self._avatar!
        }
        set(newValue) {
            self._avatar = newValue
        }
    }

    var _email: String?
    var email: String? {
        get{
            return self._email!
        }
        set(newValue) {
            self._email = newValue
        }
    }

    var _gender: Int?
    var gender: Int? {
        get{
            return self._gender
        }
        set(newValue) {
            self._gender = newValue
        }
    }

    var _userName: String?
    var userName: String? {
        get{
            return self._userName!
        }
        set(newValue) {
            self._userName = newValue
        }
    }

    var _birthday: Date?
    var birthday: Date? {
        get{
            return self._birthday!
        }
        set(newValue) {
            self._birthday = newValue
        }
    }

    var reminderList: [MovieReminders] = []

    override init() {
        self._userId = 0
        self._sessionId = ""
        self._avatar = #imageLiteral(resourceName: "ic_placeholder")
        self._email = ""
        self._gender = 1 //Female
        self._userName = ""
        self._birthday = Date()
        super.init()
    }
}
