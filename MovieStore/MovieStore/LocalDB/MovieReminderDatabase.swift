//
//  MovieReminderDatabase.swift
//  MovieStore
//
//  Created by Nhat (Norman) H.M. VU on 11/15/17.
//  Copyright © 2017 enclaveit. All rights reserved.
//

import Foundation
import UIKit
import FMDB

let sharedInstance = MovieReminderDatabase()
class MovieReminderDatabase: NSObject {

    var database: FMDatabase? = nil

    class func getInstance() -> MovieReminderDatabase {
        if (sharedInstance.database == nil) {
            sharedInstance.database = FMDatabase(path: Util.getPath(fileName: "MovieDatabase.sqlite"))
        }
        return sharedInstance
    }

    //MARK:- insert data into MovieReminders table
    func insertData(_ reminder: MovieReminders) -> Bool {
        sharedInstance.database!.open()
        let isInserted = sharedInstance.database!.executeUpdate("INSERT INTO MovieReminders(Title,VoteAverage,ReleaseDate,ImagePath) VALUES(?,?,?,?)", withArgumentsIn: [reminder.title!, reminder.voteAverage!, reminder.releaseDate!, reminder.movieReminderImagePath!])

        sharedInstance.database!.close()
        return (isInserted != nil)

    }

    func getAllData() -> NSMutableArray {
        sharedInstance.database!.open()

        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery("SELECT * FROM MovieReminders", withArgumentsIn: [0])

        let itemReminder: NSMutableArray = NSMutableArray ()
        if (resultSet != nil) {
            while resultSet.next() {
                let item: MovieReminders = MovieReminders()
                item.movieId = Int(resultSet.int(forColumn: "Id"))
                item.title = String(resultSet.string(forColumn: "Title")!)
                item.voteAverage = Float(resultSet.double(forColumn: "VoteAverage"))
                item.releaseDate = resultSet.date(forColumn: "ReleaseDate")!
                item.movieReminderImagePath = String(resultSet.string(forColumn: "ImagePath")!)
                itemReminder.add(item)
            }
        }

        sharedInstance.database!.close()
        return itemReminder
    }

    func updateRecord(recordId: Int, title: String, rating: String, imagePath: String, releaseDate: Date) -> NSMutableArray {
        sharedInstance.database!.open()

        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery("UPDATE MovieReminders SET Title = ?,VoteAverage = ?,ReleaseDate = ?,ImagePath = ? WHERE Id = ?", withArgumentsIn: [title, rating, releaseDate, imagePath, recordId])

        let itemReminder: NSMutableArray = NSMutableArray ()
        if (resultSet != nil) {
            while resultSet.next() {
                let item: MovieReminders = MovieReminders()
                item.movieId = Int(resultSet.int(forColumn: "Id"))
                item.title = String(resultSet.string(forColumn: "Title")!)
                item.voteAverage = Float(resultSet.double(forColumn: "VoteAverage"))
                item.releaseDate = resultSet.date(forColumn: "ReleaseDate")!
                item.movieReminderImagePath = String(resultSet.string(forColumn: "ImagePath")!)
                itemReminder.add(item)
            }
        }

        sharedInstance.database!.close()
        return itemReminder

    }

    func deleteRecord(recordId: Int) -> NSMutableArray {
        sharedInstance.database!.open()

        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery("DELETE FROM MovieReminders WHERE Id = ?", withArgumentsIn: [recordId])

        let itemReminder: NSMutableArray = NSMutableArray()
        if (resultSet != nil) {
            while resultSet.next() {
                let item: MovieReminders = MovieReminders()
                item.movieId = Int(resultSet.int(forColumn: "Id"))
                item.title = String(resultSet.string(forColumn: "Title")!)
                item.voteAverage = Float(resultSet.double(forColumn: "VoteAverage"))
                item.releaseDate = resultSet.date(forColumn: "ReleaseDate")!
                item.movieReminderImagePath = String(resultSet.string(forColumn: "ImagePath")!)
                itemReminder.add(item)
            }
        }

        sharedInstance.database!.close()
        return itemReminder
    }
}
