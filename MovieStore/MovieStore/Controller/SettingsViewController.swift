//
//  SettingsViewController.swift
//  MovieStore
//
//  Created by Nhat (Norman) H.M. VU on 11/2/17.
//  Copyright © 2017 enclaveit. All rights reserved.
//

import UIKit
import Kingfisher
import Alamofire
import ESPullToRefresh
import FMDB
import SwiftyJSON

class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate {
    let titleSections: [String] = ["Filter", "Sort by"]
    let titleFilterMovies: [String] = ["Popular Movies", "Top Rated Movies", "Upcoming Movies", "NowPlaying Movies", "From Release Year"]
    let titleSortType: [String] = ["Release Date", "Rating"]
    let yearLabel = UILabel(frame: CGRect(x: 254, y: 8, width: 50, height: 20))
    let indexPathRatingMovie: IndexPath = NSIndexPath(row: 4, section: 0) as IndexPath
    let indexPathReleaseYearMovie: IndexPath = NSIndexPath(row: 5, section: 0) as IndexPath
    var currentMovieSetting = MovieSettings()
    var movieRatingViewCell: FilterMovieRatingViewCell?

    @IBOutlet weak var settingsMovies: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        //Load update user defauls
        UserDefaultManager.updateSettings(movieSettings: currentMovieSetting)
        

        // Do any additional setup after loading the view, typically from a nib.
        settingsMovies.register(UITableViewCell.self, forCellReuseIdentifier: "normalViewCell")
        settingsMovies.register(UINib(nibName: "FilterMovieRatingViewCell", bundle: nil), forCellReuseIdentifier: "FilterMovieRatingViewCell")
        self.settingsMovies.delegate = self
        self.settingsMovies.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    //MARK: Table view delegate and data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
        return (section == 0 ? titleSections[0] : titleSections[1])
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (section == 0 ? 6 : 2)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath == indexPathReleaseYearMovie) {
            self.chooseReleaseYear()
        }
        switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
            case 0:
                let currentIndex: IndexPath = NSIndexPath(row: 0, section: 0) as IndexPath
                if (indexPath == currentIndex) {
                    currentMovieSetting.popularMovies = true
                }
            case 1:
                let currentIndex: IndexPath = NSIndexPath(row: 1, section: 0) as IndexPath
                if (indexPath == currentIndex) {
                    currentMovieSetting.topRatedMovies = true
                }
            case 2:
                let currentIndex: IndexPath = NSIndexPath(row: 2, section: 0) as IndexPath
                if (indexPath == currentIndex) {
                    currentMovieSetting.upComingMovies = true
                }
            case 3:
                let currentIndex: IndexPath = NSIndexPath(row: 3, section: 0) as IndexPath
                if (indexPath == currentIndex) {
                    currentMovieSetting.nowPlayingMovies = true
                }
            case 4:
                let currentIndex: IndexPath = NSIndexPath(row: 4, section: 0) as IndexPath
                if (indexPath == currentIndex) {
                    currentMovieSetting.movieWithRate = (movieRatingViewCell?.movieWithRate)!
                }
            case 5:
                let currentIndex: IndexPath = NSIndexPath(row: 5, section: 0) as IndexPath
                if (indexPath == currentIndex) {
                    currentMovieSetting.fromReleaseYear = Int(yearLabel.text!)!
                }
            default:
                print("Row default")
            }
        case 1:
            switch (indexPath.row) {
            case 0:
                let currentIndex: IndexPath = NSIndexPath(row: 0, section: 1) as IndexPath
                if (indexPath == currentIndex) {
                    currentMovieSetting.releaseDate = true
                }
            case 1:
                let currentIndex: IndexPath = NSIndexPath(row: 1, section: 1) as IndexPath
                if (indexPath == currentIndex) {
                    currentMovieSetting.rating = true
                }
            default:
                print("Row default")
            }
        default:
            print("Section default")
        }
        //Send(Post) Notification
        let thisNotification = NSNotification(name: NSNotification.Name(rawValue: "createdNotification"), object: nil) as Notification
        NotificationCenter.default.post(thisNotification)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath != indexPathRatingMovie) {
            let cellNormal = self.settingsMovies.dequeueReusableCell(withIdentifier: "normalViewCell", for: indexPath)
            switch (indexPath.section) {
            case 0:
                switch (indexPath.row) {
                case 0:
                    cellNormal.textLabel?.text = self.titleFilterMovies[0]
                    if (self.currentMovieSetting.popularMovies) {
                        cellNormal.accessoryType = .checkmark
                    }
                case 1:
                    cellNormal.textLabel?.text = self.titleFilterMovies[1]
                    if (self.currentMovieSetting.topRatedMovies) {
                        cellNormal.accessoryType = .checkmark
                    }
                case 2:
                    cellNormal.textLabel?.text = self.titleFilterMovies[2]
                    if (self.currentMovieSetting.upComingMovies) {
                        cellNormal.accessoryType = .checkmark
                    }
                case 3:
                    cellNormal.textLabel?.text = self.titleFilterMovies[3]
                    if (self.currentMovieSetting.nowPlayingMovies) {
                        cellNormal.accessoryType = .checkmark
                    }
                case 5:
                    cellNormal.textLabel?.text = self.titleFilterMovies[4]
                    yearLabel.text = String(self.currentMovieSetting.fromReleaseYear)
                    yearLabel.textAlignment = NSTextAlignment.right
                    
                    yearLabel.translatesAutoresizingMaskIntoConstraints = false
                    cellNormal.contentView.addSubview(yearLabel)

                    let trailingConstraint = NSLayoutConstraint(item: cellNormal.contentView, attribute: .trailing, relatedBy: .equal, toItem: yearLabel, attribute: .trailing, multiplier: 1.0, constant: 16.0)
                    let topConstraint = NSLayoutConstraint(item: cellNormal.contentView, attribute: .top, relatedBy: .equal, toItem: yearLabel, attribute: .top, multiplier: 1.0, constant: 0)
                    let bottomConstraint = NSLayoutConstraint(item: cellNormal.contentView, attribute: .bottom, relatedBy: .equal, toItem: yearLabel, attribute: .bottom, multiplier: 1.0, constant: 0)
                    
                    cellNormal.contentView.addConstraint(trailingConstraint)
                    cellNormal.contentView.addConstraint(topConstraint)
                    cellNormal.contentView.addConstraint(bottomConstraint)
                    cellNormal.layoutIfNeeded()
                default:
                    print("Row")
                }

            case 1:
                if (indexPath.row == 0) {
                    cellNormal.textLabel?.text = self.titleSortType[0]
                    if (self.currentMovieSetting.releaseDate) {
                        cellNormal.accessoryType = .checkmark
                    }
                } else {
                    cellNormal.textLabel?.text = self.titleSortType[1]
                    if (self.currentMovieSetting.rating) {
                        cellNormal.accessoryType = .checkmark
                    }
                }
            default:
                print("Section")
            }
            return cellNormal
        } else {
            movieRatingViewCell = self.settingsMovies.dequeueReusableCell(withIdentifier: "FilterMovieRatingViewCell", for: indexPathRatingMovie) as? FilterMovieRatingViewCell
            movieRatingViewCell?.sizeThatFits(CGSize(width: self.settingsMovies.bounds.width, height: 60))
            movieRatingViewCell?.movieWithRate = self.currentMovieSetting.movieWithRate
            movieRatingViewCell?.movieRating = "\(self.currentMovieSetting.movieWithRate)"
            return movieRatingViewCell!
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath == indexPathRatingMovie) {
            return 70
        }
        return 40
    }

    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if (indexPath.section == 0) {
            //Reset all check mark
            for i in 0...3 {
                let currentIndex: IndexPath = NSIndexPath(row: i, section: 0) as IndexPath
                tableView.cellForRow(at: currentIndex)?.accessoryType = .none
            }
            if (indexPath != indexPathRatingMovie && indexPath != indexPathReleaseYearMovie) {
                tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            } else {
                tableView.cellForRow(at: indexPathRatingMovie)?.accessoryType = .none
                tableView.cellForRow(at: indexPathReleaseYearMovie)?.accessoryType = .none
            }
        } else {
            //Reset all check mark
            for i in 0...1 {
                let currentIndex: IndexPath = NSIndexPath(row: i, section: 1) as IndexPath
                tableView.cellForRow(at: currentIndex)?.accessoryType = .none
            }
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        return indexPath
    }
    
    func chooseReleaseYear() {
        let alert = UIAlertController(title: "\n\n\n\n\n\n", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        alert.isModalInPopover = true
        let releaseYearPicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: alert.view.frame.width - 20, height: 150))
        releaseYearPicker.datePickerMode = UIDatePickerMode.date

        alert.addAction(UIAlertAction(title: "Select", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction!) in
            let formatter = DateFormatter()
            formatter.dateFormat = "YYYY"
            self.yearLabel.text = formatter.string(from: releaseYearPicker.date)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: {(action:UIAlertAction!) in
            print("Cancel")
        }))
        alert.view.addSubview(releaseYearPicker)
        self.present(alert, animated: true, completion: nil)
    }
}
