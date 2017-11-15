//
//  SettingsRemindersViewController.swift
//  MovieStore
//
//  Created by Nhat (Norman) H.M. VU on 11/2/17.
//  Copyright © 2017 enclaveit. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

protocol SettingsRemindersViewControllerDelegate: class {
    func closeViewController(_ viewController: SettingsRemindersViewController, didTapBackButton button: UIBarButtonItem)
}

class SettingsRemindersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var reminderList: UITableView!
    @IBOutlet weak var backButton: UIBarButtonItem!

    weak var delegate: SettingsRemindersViewControllerDelegate?
    var allReminderList = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.reminderList.allowsMultipleSelectionDuringEditing = false
        self.reminderList.delegate = self
        self.reminderList.dataSource = self

        self.reminderList.register(UINib(nibName: "ReminderViewCell", bundle: nil), forCellReuseIdentifier: "ReminderViewCell")

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.allReminderList = MovieReminderDatabase.getInstance().getAllData()
        reminderList.reloadData()
    }
    
    @IBAction func backButtonTapped(_ sender: UIBarButtonItem) {
        delegate?.closeViewController(self, didTapBackButton: backButton)
    }


    //MARK: Reminder list table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allReminderList.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReminderViewCell", for: indexPath) as! ReminderViewCell

        cell.tag = indexPath.row
        var reminder = MovieReminders()
        reminder = self.allReminderList.object(at: indexPath.row) as! MovieReminders
        cell.movieId = reminder.movieId
        cell.reminderTitle.text = reminder.title
        cell.rating.text = reminder.rating
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        cell.releaseDate.text = formatter.string(from: reminder.releaseDate!)
        cell.reminderImage.kf.setImage(with: ImageResource(downloadURL: (reminder.imagePathURL!)))

        return cell
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        var reminder = MovieReminders()
        reminder = self.allReminderList.object(at: indexPath.row) as! MovieReminders
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            let reminderDelete = MovieReminderDatabase.getInstance().deleteRecord(recordId: reminder.movieId!)
            if (reminderDelete != nil) {
                self.allReminderList.removeObject(at: indexPath.item)
                self.reminderList.reloadData()
            }

        }
    }

}
