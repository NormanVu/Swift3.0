//
//  MoviesViewController.swift
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
import SWRevealViewController

class MoviesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate{

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var layoutButton: UIBarButtonItem!
    @IBOutlet weak var menuButton: UIBarButtonItem!

    let movieAPI = APIManager()
    var gridLayout: GridLayout!
    var listLayout: ListLayout!
    var allMovies = [Movie]()
    var requestToken: String?
    var sessionID: String?
    var userID: Int?
    var currentMovieId: Int?
    var currentMovieSetting: MovieSettings?
    var profile = Profile()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        //Side menu using SWRevealViewController framework
        if (revealViewController() != nil) {

            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().rearViewRevealWidth = self.view.frame.width - 60
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            //Close rear view controller when tap on front view controller
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        }

        movieAPI.getPopularMovies(completionHandler:{(UIBackgroundFetchResult) -> Void in
            self.allMovies = self.movieAPI.allMovies
            self.collectionView.reloadData()
        })

        self.autoLogin()

        gridLayout = GridLayout(numberOfColumns: 2)
        listLayout = ListLayout()

        collectionView.register(UINib(nibName: "MovieViewCell", bundle: nil), forCellWithReuseIdentifier: "MovieViewCell")
        collectionView.collectionViewLayout = gridLayout
        self.layoutButton.image = #imageLiteral(resourceName: "ic_view_list")

        self.collectionView.delegate = self
        self.collectionView.dataSource = self


        
        //Receive(Get) Notification:
        NotificationCenter.default.addObserver(self, selector: #selector(MoviesViewController.onCreatedNotification), name: NSNotification.Name(rawValue: "createdSettingsNotification"), object: nil)
    }

    //Method handler for received Notification
    func onCreatedNotification(notification: NSNotification) {
        //Receive settings did change
        self.currentMovieSetting = UserDefaultManager.getMovieSettings()
        
        //Reload data to change following current settings from user
        
    }
    
    //Remove Notification
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "createdNotification"), object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView.reloadData()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

    }

    // MARK: collectionView methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.allMovies.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieViewCell", for: indexPath) as! MovieViewCell
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd"

        cell.title.text = self.allMovies[indexPath.item].title
        cell.posterImage.kf.setImage(with: ImageResource(downloadURL: self.allMovies[indexPath.item].posterURL!))
        cell.releaseDate.text = dateFormater.string(from: self.allMovies[indexPath.item].releaseDate)
        cell.topRating.text = "\(self.allMovies[indexPath.item].voteAverage)/10"
        cell.overview.text = self.allMovies[indexPath.item].overview
        cell.movieId = self.allMovies[indexPath.item].movieId

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let favoriteViewCell = collectionView.cellForItem(at: indexPath) as? MovieViewCell
        self.currentMovieId = favoriteViewCell?.movieId
        favoriteViewCell?.favoriteMovieButton?.addTarget(self, action: #selector(favoriteMovieButtonTapped(_:)), for: .touchUpInside)
    }


    @IBAction func layoutButtonTapped(_ sender: UIBarButtonItem) {
        if (collectionView.collectionViewLayout == gridLayout) {
            layoutButton.image = #imageLiteral(resourceName: "ic_view_module")
            UIView.animate(withDuration: 0.1, animations: {
                self.collectionView.collectionViewLayout.invalidateLayout()
                self.collectionView.setCollectionViewLayout(self.listLayout, animated: false)
            })
        } else {
            layoutButton.image = #imageLiteral(resourceName: "ic_view_list")
            UIView.animate(withDuration: 0.1, animations: {
                self.collectionView.collectionViewLayout.invalidateLayout()
                self.collectionView.setCollectionViewLayout(self.gridLayout, animated: false)
            })
        }
    }

    @IBAction func menuButtonTapped(_ sender: UIBarButtonItem) {

    }

    func autoLogin() {
        //Step 1: Create a new request token
        self.movieAPI.getRequestToken(completionHandler:{(UIBackgroundFetchResult) -> Void in
            self.requestToken = self.movieAPI.requestToken
            //Step 2: Ask the user for permission via the API
            self.movieAPI.loginWithToken(validateRequestToken: self.requestToken!, completionHandler:{(UIBackgroundFetchResult) -> Void in
                //Step 3: Create a session ID
                self.movieAPI.getSessionID(requestToken: self.requestToken!, completionHandler: {(UIBackgroundFetchResult) -> Void in
                    self.sessionID = self.movieAPI.sessionID
                    //Step 4: Get the user id
                    self.movieAPI.getUserID(sessionID: self.sessionID!, completionHandler: {(UIBackgroundFetchResult) -> Void in
                        self.userID = self.movieAPI.userID
                        self.profile.userId = self.userID
                        self.profile.sessionId = self.sessionID
                        //Force login by user authentication via email and password are same as calling API
                        self.profile.email = "norman@enclave.vn"
                        self.profile.userName = "NormanVu"
                        self.profile.gender = true
                        self.profile.avatar = #imageLiteral(resourceName: "ic_placeholder")
                        self.profile.birthday = Date()

                        //Store session id and user information into user default manager
                        //UserDefaultManager.updateProfile(userProfile: self.profile)
                    })
                })
            })
        })
    }


    //@TODO: Implement to update image favorite/unfavorite
    func favoriteMovieButtonTapped(_ movieViewCell: MovieViewCell) {
        print("Favorite current movie id: \(self.currentMovieId!)")
        movieAPI.setFavoriteMovies(mediaID: self.currentMovieId!, userID: self.userID!, sessionID: self.sessionID!, favorite: true, completionHandler: {(UIBackgroundFetchResult) -> Void in
            print("favorite or unfavorite movie")
        })
    }
}




