//
//  FavoriteViewController.swift
//  MovieStore
//
//  Created by Nhat (Norman) H.M. VU on 11/1/17.
//  Copyright © 2017 enclaveit. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher
import ESPullToRefresh

class FavoriteViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var noneDataView: UIView!

    let movieAPI = APIManager()
    var allMovies = [Movie]()
    var requestToken: String?
    var sessionID: String?
    var userID: Int?
    var listLayout: ListLayout!
    var refresh = UIRefreshControl()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        
        if (self.allMovies.count == 0) {
            self.collectionView.isHidden = true
            self.noneDataView.isHidden = false
        } else {
            self.collectionView.isHidden = false
            self.noneDataView.isHidden = true
        }
        
        listLayout = ListLayout()

        collectionView.register(UINib(nibName: "MovieViewCell", bundle: nil), forCellWithReuseIdentifier: "MovieViewCell")
        collectionView.collectionViewLayout = listLayout
        self.collectionView.delegate = self

        self.collectionView.es.addPullToRefresh {[weak self] in
            self?.collectionView.reloadData()
        }
        self.collectionView.es.startPullToRefresh()
    }
    
    func loadData() {
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
                        //Step 5: Get favorite movies
                        self.movieAPI.getFavoriteMovies(userID: self.userID!, sessionID: self.sessionID!, completionHandler: {(UIBackgroundFetchResult) -> Void in
                            self.allMovies = self.movieAPI.allMovies
                            self.collectionView.reloadData()
                        })
                    })
                })
            })
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.collectionView.es.stopPullToRefresh()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView.es.startPullToRefresh()
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
        cell.posterImage.kf.setImage(with: ImageResource(downloadURL: self.allMovies[indexPath.item].backdropURL!))
        cell.releaseDate.text = dateFormater.string(from: self.allMovies[indexPath.item].releaseDate)
        cell.topRating.text = "\(self.allMovies[indexPath.item].voteAverage)/10"
        cell.overview.text = self.allMovies[indexPath.item].overview

        return cell
    }
}
