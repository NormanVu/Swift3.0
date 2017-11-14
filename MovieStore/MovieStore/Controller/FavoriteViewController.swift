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
import CoreData

class FavoriteViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var noneDataView: UIView!

    let movieAPI = APIManager()
    var allMovies = [Movie]()
    var requestToken: String?
    var profile = Profile()
    var isFavorited: Bool?
    var currentMovieId: Int?
    var listLayout: ListLayout!
    var refresher: UIRefreshControl!
    var favoriteMovie: NSManagedObject? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        
        listLayout = ListLayout()

        collectionView.register(UINib(nibName: "MovieViewCell", bundle: nil), forCellWithReuseIdentifier: "MovieViewCell")
        collectionView.collectionViewLayout = listLayout
        self.collectionView.delegate = self

        //Refresh collection view
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Release to refresh")
        refresher.addTarget(self, action: #selector(FavoriteViewController.needRefresh(_ :)), for : .valueChanged)
        if #available(iOS 10.0, *) {
            self.collectionView.refreshControl = refresher
        } else {
            // Fallback on earlier versions
            self.collectionView.addSubview(refresher)
        }
    }
    
    func loadData() {
        self.profile = UserDefaultManager.getUserProfile()
        print("Session id = \(self.profile.sessionId)")

        //Step 5: Get favorite movies
        self.movieAPI.getFavoriteMovies(userID: profile.userId!, sessionID: profile.sessionId!, completionHandler: {(UIBackgroundFetchResult) -> Void in
            self.allMovies = self.movieAPI.favoriteMovies
            if (self.allMovies.count == 0) {
                self.collectionView.isHidden = true
                self.noneDataView.isHidden = false
            } else {
                self.collectionView.isHidden = false
                self.noneDataView.isHidden = true
            }
            self.collectionView.reloadData()
        })

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        isFavorited = self.isFavoriteMovie(movieId: self.allMovies[indexPath.item].movieId)
        cell.favoriteImageView.image = isFavorited! ? #imageLiteral(resourceName: "ic_favorite") : #imageLiteral(resourceName: "ic_unfavorite")
        cell.delegate = self

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let favoriteViewCell = collectionView.cellForItem(at: indexPath) as? MovieViewCell
        self.currentMovieId = favoriteViewCell?.movieId

        //Select current movie to load movie detail
        guard let movieDetailViewController = storyboard?.instantiateViewController(withIdentifier: "MovieDetailViewController") as? MovieDetailViewController else {
            return
        }
        movieDetailViewController.delegate = self
        print("Current movie ID: \(allMovies[indexPath.row].movieId)")
        movieDetailViewController.currentMovie = allMovies[indexPath.row]
        navigationController?.pushViewController(movieDetailViewController, animated: true)
    }

    // MARK: - Release to refresh
    func needRefresh(_ sender : UIRefreshControl) {
        perform(#selector(FavoriteViewController.finishRefresh), with : nil, afterDelay : 3)
    }

    func finishRefresh() {
        refresher?.endRefreshing()
        collectionView.reloadData()
    }

    func isFavoriteMovie(movieId: Int) -> Bool {
        for movie in self.allMovies {
            if (movie.movieId == movieId) {
                return true
            }
        }
        return false
    }
}

extension FavoriteViewController: MovieDetailViewControllerDelegate {
    func closeViewController(_ viewController: MovieDetailViewController, didTapBackButton button: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
}

extension FavoriteViewController: FavoriteMovieViewCellDelegate {
    func didTapFavoriteMovieButton(_ movieViewCell: MovieViewCell) {
        //No need change unfavorite at this screen, this screen only display favorited movies
        print("No need change unfavorite at this screen")
    }
}
