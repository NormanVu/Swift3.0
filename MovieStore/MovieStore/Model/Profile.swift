//
//  UserProfile.swift
//  MovieStore
//
//  Created by Nhat (Norman) H.M. VU on 11/8/17.
//  Copyright © 2017 enclaveit. All rights reserved.
//

import Foundation

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

    var _avatar: String?
    var avatar: String? {
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

    var _gender: String?
    var gender: String? {
        get{
            return self._gender!
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
        super.init()
    }
}
