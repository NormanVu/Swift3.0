//
//  Util.swift
//  MovieStore
//
//  Created by Nhat (Norman) H.M. VU on 11/15/17.
//  Copyright © 2017 enclaveit. All rights reserved.
//

import Foundation
import UIKit

class Util: NSObject {

    class func getPath(fileName: String) -> String {

        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsURL.appendingPathComponent(fileName)

        print(fileURL)
        return fileURL.path
    }

    class func copyFile(fileName: NSString) {
        let dbPath: String = getPath(fileName: fileName as String)
        let fileManager = FileManager.default
        if (!fileManager.fileExists(atPath: dbPath)) {
            let documentsURL = Bundle.main.resourceURL
            let fromPath = documentsURL!.appendingPathComponent(fileName as String)
            print("Database is copied from : \(fromPath)")
            var error : NSError?
            do {
                try fileManager.copyItem(atPath: fromPath.path, toPath: dbPath)
            } catch let error1 as NSError {
                error = error1
            }
            
            let alert: UIAlertView = UIAlertView()
            if (error != nil) {
                alert.title = "Error Occured"
                alert.message = error?.localizedDescription
                alert.delegate = nil
                alert.addButton(withTitle: "OK")
                alert.show()
            } else {
                alert.title = "Successfully Copy"
                alert.message = "Your database is copied successfully"
            }

        }
    }

    class func invokeAlertMethod(title: NSString, body: NSString, delegate: AnyObject?) {
        let alert: UIAlertView = UIAlertView()
        alert.message = body as String
        alert.title = title as String
        alert.delegate = delegate
        alert.addButton(withTitle: "OK")
        alert.show()
    }
}

extension String {
    func toDate(dateFormat: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat

        let date: Date? = dateFormatter.date(from: self)
        return date
    }
}
