//
//  ProfileViewController.swift
//  MovieStore
//
//  Created by Nhat (Norman) H.M. VU on 11/2/17.
//  Copyright © 2017 enclaveit. All rights reserved.
//

import UIKit
import SWRevealViewController
import CoreData
import SWRevealViewController

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var showAllButton: UIButton!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var reminderLabel: UILabel!
    @IBOutlet weak var reminderList: UITableView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var maleButton: UIButton!
    @IBOutlet weak var femaleButton: UIButton!
    @IBOutlet weak var femaleLabel: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var avatarButton: UIButton!
    @IBOutlet weak var birthday: UILabel!
    @IBOutlet weak var email: UILabel!
    
    var userProfileManagedObject: NSManagedObject? = nil
    var userProfile = Profile()
    var gender: Bool?

    override func viewDidLoad() {
        super.viewDidLoad()

        //Get user information from user default manager
        self.userProfile = UserDefaultManager.getUserProfile()
        //Update user information
        updateUI()
        //self.loadProfileFromCoreData()

    }

    func updateUI() {
        cancelButton.isHidden = true
        doneButton.isHidden = true
        maleButton.isHidden = true
        femaleLabel.isHidden = true
        femaleButton.isHidden = true
        avatarButton.isHidden = true

        //Update user information
        self.genderLabel.text = (self.userProfile.gender == true ? "Male" : "Female")
        self.userNameLabel.text = self.userProfile.userName
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        self.birthday.text = formatter.string(from: self.userProfile.birthday!)
        self.email.text = self.userProfile.email
        editButton.layer.cornerRadius = 3.0
        doneButton.layer.cornerRadius = 3.0
        cancelButton.layer.cornerRadius = 3.0
        showAllButton.layer.cornerRadius = 3.0
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
            let email = userProfileManagedObject?.value(forKeyPath: "email") as? String
            userProfile.email = email!
            let gender = userProfileManagedObject?.value(forKeyPath: "gender") as? Bool
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
        userProfileManagedObject?.setValue(userProfile.userId, forKeyPath: "userId")
        userProfileManagedObject?.setValue(userProfile.email, forKeyPath: "email")
        userProfileManagedObject?.setValue(userProfile.gender, forKeyPath: "gender")
        userProfileManagedObject?.setValue(userProfile.userName, forKeyPath: "userName")
        userProfileManagedObject?.setValue(userProfile.birthday, forKeyPath: "birthday")
        //@TODO: Reminder list
    }

    func updateLayout(isChanged: Bool) {
        cancelButton.isHidden = !isChanged
        doneButton.isHidden = !isChanged
        femaleLabel.isHidden = !isChanged
        maleButton.isHidden = !isChanged
        femaleButton.isHidden = !isChanged
        avatarButton.isHidden = !isChanged
        showAllButton.isHidden = isChanged
        reminderLabel.isHidden = isChanged
        reminderList.isHidden = isChanged
        editButton.isHidden = isChanged
        genderLabel.text = "Male"
        if (self.userProfile.gender == true) {
            maleButton.setImage(#imageLiteral(resourceName: "ic_checked_box"), for: UIControlState.normal)
            femaleButton.setImage(#imageLiteral(resourceName: "ic_check_box"), for: UIControlState.normal)
        } else {
            maleButton.setImage(#imageLiteral(resourceName: "ic_check_box"), for: UIControlState.normal)
            femaleButton.setImage(#imageLiteral(resourceName: "ic_checked_box"), for: UIControlState.normal)
        }
    }

    @IBAction func editButtonTapped(_ sender: UIButton) {
        updateLayout(isChanged: true)
        if (revealViewController() != nil) {
            //Right most front view controller is same as hidden
            revealViewController().frontViewPosition = FrontViewPosition.rightMost
        }
    }

    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        updateLayout(isChanged: false)
        if (revealViewController() != nil) {
            //Right front view controller is previously
            revealViewController().frontViewPosition = FrontViewPosition.right
        }

        //Reset gender label
        self.genderLabel.text = (self.userProfile.gender == true ? "Male" : "Female")
    }

    @IBAction func doneButtonTapped(_ sender: UIButton) {
        updateLayout(isChanged: false)
        if (revealViewController() != nil) {
            //Right front view controller is previously
            revealViewController().frontViewPosition = FrontViewPosition.right
        }

        //Reset gender label
        self.genderLabel.text = (gender == true ? "Male" : "Female")
        self.userProfile.gender = gender
    }

    @IBAction func maleButtonTapped(_ sender: UIButton) {
        maleButton.setImage(#imageLiteral(resourceName: "ic_checked_box"), for: UIControlState.normal)
        femaleButton.setImage(#imageLiteral(resourceName: "ic_check_box"), for: UIControlState.normal)
        gender = true
    }

    @IBAction func femaleButtonTapped(_ sender: UIButton) {
        maleButton.setImage(#imageLiteral(resourceName: "ic_check_box"), for: UIControlState.normal)
        femaleButton.setImage(#imageLiteral(resourceName: "ic_checked_box"), for: UIControlState.normal)
        gender = false
    }

    @IBAction func avatarImageButtonTapped() {
        let imagePickerVC = UIImagePickerController()
        //UIImagePickerControllerSourceType.savedPhotosAlbum
        imagePickerVC.sourceType  = .photoLibrary
        // Whether to enable editing of selected media
        imagePickerVC.allowsEditing = true

        // selectable media limitation. The default is photo only.
        imagePickerVC.mediaTypes = UIImagePickerController.availableMediaTypes(for: imagePickerVC.sourceType)!
        imagePickerVC.delegate = self
        present(imagePickerVC, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        dismiss(animated: true, completion: nil)
        self.avatar.image = info[UIImagePickerControllerOriginalImage] as? UIImage
    }
}
