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
    var indexPathOldSection0: IndexPath = NSIndexPath(row: 0, section: 0) as IndexPath
    var indexPathOldSection1: IndexPath = NSIndexPath(row: 0, section: 1) as IndexPath
    var movieSettings: [Dictionary<String, AnyObject>] = []

    @IBOutlet weak var settingsMovies: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        //Load userDafault

        // Do any additional setup after loading the view, typically from a nib.
        settingsMovies.register(UITableViewCell.self, forCellReuseIdentifier: "normalViewCell")
        settingsMovies.register(UINib(nibName: "FilterMovieRatingViewCell", bundle: nil), forCellReuseIdentifier: "FilterMovieRatingViewCell")
        self.settingsMovies.delegate = self
        self.settingsMovies.dataSource = self
        let userDefaultManager = UserDefaultManager()
        userDefaultManager.registerSettingsBundle()

        print("movieSetting object is \(userDefaultManager.getMovieSettings())")
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
        print("Selected at section:\(indexPath.section) - row: \(indexPath.row)")
        if (indexPath == indexPathReleaseYearMovie) {
            self.chooseReleaseYear()
        }
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath == indexPathRatingMovie || indexPath == indexPathReleaseYearMovie) {
            tableView.cellForRow(at: indexPathRatingMovie)?.setSelected(false, animated: true)
            tableView.cellForRow(at: indexPathRatingMovie)?.setHighlighted(false, animated: true)
            tableView.cellForRow(at: indexPathReleaseYearMovie)?.setSelected(false, animated: true)
            tableView.cellForRow(at: indexPathReleaseYearMovie)?.setHighlighted(false, animated: true)
        }

        if (indexPath != indexPathRatingMovie) {
            let cellNormal = self.settingsMovies.dequeueReusableCell(withIdentifier: "normalViewCell", for: indexPath)
            switch (indexPath.section) {
            case 0:
                switch (indexPath.row) {
                case 0:
                    cellNormal.textLabel?.text = self.titleFilterMovies[0]
                case 1:
                    cellNormal.textLabel?.text = self.titleFilterMovies[1]
                case 2:
                    cellNormal.textLabel?.text = self.titleFilterMovies[2]
                case 3:
                    cellNormal.textLabel?.text = self.titleFilterMovies[3]
                case 5:
                    cellNormal.textLabel?.text = self.titleFilterMovies[4]
                    
                    yearLabel.text = "1970"
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
                } else {
                    cellNormal.textLabel?.text = self.titleSortType[1]
                }
            default:
                print("Section")
            }
            return cellNormal
        } else {
            let cell = self.settingsMovies.dequeueReusableCell(withIdentifier: "FilterMovieRatingViewCell", for: indexPathRatingMovie)
            cell.sizeThatFits(CGSize(width: self.settingsMovies.bounds.width, height: 60))
            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath == indexPathRatingMovie) {
            return 70
        }
        return 40
    }

    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        let oldIndex = tableView.indexPathForSelectedRow
        if (indexPath.section == 0) {
            if (oldIndex?.section == self.indexPathOldSection0.section) {
                self.indexPathOldSection0 = oldIndex!
            }
            if (indexPath.section == self.indexPathOldSection0.section) {
                tableView.cellForRow(at: self.indexPathOldSection0)?.accessoryType = .none
            }
            if (indexPath != indexPathRatingMovie && indexPath != indexPathReleaseYearMovie) {
                tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            } else {
                tableView.cellForRow(at: indexPathRatingMovie)?.accessoryType = .none
                tableView.cellForRow(at: indexPathReleaseYearMovie)?.accessoryType = .none
            }
        } else {
            if (oldIndex?.section == self.indexPathOldSection1.section) {
                self.indexPathOldSection1 = oldIndex!
            }
            if (indexPath.section == self.indexPathOldSection1.section) {
                tableView.cellForRow(at: self.indexPathOldSection1)?.accessoryType = .none
            }
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        //Store settings
        
        //userDefault.set(self.movieSettings, forKey: "movieSettings")
        return indexPath
    }
    
    func chooseReleaseYear() {
        
        let alert = UIAlertController(title: "", message: "Please choose a release year", preferredStyle: UIAlertControllerStyle.actionSheet)
        alert.isModalInPopover = true
        let releaseYearPicker = UIDatePicker()
        releaseYearPicker.datePickerMode = UIDatePickerMode.dateAndTime
        var formatter = DateFormatter()
        formatter.dateFormat = "YYYY"
        alert.view.addSubview(releaseYearPicker)

        //Add UIDatePiker into UIAlertController
        alert.addAction(UIAlertAction(title: "Select", style: UIAlertActionStyle.default, handler: nil))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}
