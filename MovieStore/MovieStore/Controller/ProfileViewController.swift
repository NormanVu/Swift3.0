//
//  ProfileViewController.swift
//  MovieStore
//
//  Created by Hiền Hoà Co.,LTD on 11/3/17.
//  Copyright © 2017 enclaveit. All rights reserved.
//

import UIKit
import SWRevealViewController
import CoreData
import SWRevealViewController

class ProfileViewController: UIViewController {
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var showAllButton: UIButton!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var reminderLabel: UILabel!
    @IBOutlet weak var reminderList: UITableView!


    var maleRadioButton: RadioButton!
    var femaleRadioButton: RadioButton!
    var userProfileManagedObject: NSManagedObject? = nil
    var userProfile = Profile()

    override func awakeFromNib() {
        super.awakeFromNib()
        self.view.layoutIfNeeded()
        //maleRadioButton.isSelected = true
        //femaleRadioButton.isSelected = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        updateUI()

        //self.loadProfileFromCoreData()

        //
        //maleRadioButton?.alternateButton = [maleRadioButton!]
        //femaleRadioButton?.alternateButton = [femaleRadioButton!]
    }

    func updateUI() {
        cancelButton.isHidden = true
        doneButton.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("Current profile will be saved to coredata when view disappear")
        //self.saveProfileToCoreData()
    }

    func loadProfileFromCoreData() {
        //
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        if #available(iOS 10.0, *) {
            // managed context
            let managedContext =
                appDelegate.persistentContainer.viewContext
            // movieSetting entity
            let userProfileEntity =
                NSEntityDescription.entity(forEntityName: "UserProfile", in: managedContext)!
            userProfileManagedObject = NSManagedObject(entity: userProfileEntity, insertInto: managedContext)

            // Get values
            let userId = userProfileManagedObject?.value(forKeyPath: "userId") as? Int
            userProfile.userId = userId!
            let avatar = userProfileManagedObject?.value(forKeyPath: "avatar") as? String
            userProfile.avatar = avatar!
            let email = userProfileManagedObject?.value(forKeyPath: "email") as? String
            userProfile.email = email!
            let gender = userProfileManagedObject?.value(forKeyPath: "gender") as? String
            userProfile.gender = gender!
            let userName = userProfileManagedObject?.value(forKeyPath: "userName") as? String
            userProfile.userName = userName!
            let birthday = userProfileManagedObject?.value(forKeyPath: "birthday") as? Date
            userProfile.birthday = birthday!
            //@TODO: Reminder list

        } else {
            // Fallback on earlier versions
        }
    }

    func saveProfileToCoreData() {
        print("userId: \(userProfile.userId), avatar: \(userProfile.avatar), email: \(userProfile.email), gender: \(userProfile.gender), userName: \(userProfile.userName), birthday: \(userProfile.birthday)")

        userProfileManagedObject?.setValue(userProfile.userId, forKeyPath: "userId")
        userProfileManagedObject?.setValue(userProfile.avatar, forKeyPath: "avatar")
        userProfileManagedObject?.setValue(userProfile.email, forKeyPath: "email")
        userProfileManagedObject?.setValue(userProfile.gender, forKeyPath: "gender")
        userProfileManagedObject?.setValue(userProfile.userName, forKeyPath: "userName")
        userProfileManagedObject?.setValue(userProfile.birthday, forKeyPath: "birthday")
        //@TODO: Reminder list

    }

    func updateLayout(isChanged: Bool) {
        cancelButton.isHidden = !isChanged
        doneButton.isHidden = !isChanged
        showAllButton.isHidden = isChanged
        reminderLabel.isHidden = isChanged
        reminderList.isHidden = isChanged
        editButton.isHidden = isChanged
    }

    @IBAction func editButtonTapped(_ sender: UIButton) {
        updateLayout(isChanged: true)

    }

    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        updateLayout(isChanged: false)
    }

    @IBAction func doneButtonTapped(_ sender: UIButton) {
        updateLayout(isChanged: false)
    }
}
