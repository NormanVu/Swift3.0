//
//  MoviesDetailViewController.swift
//  MovieStore
//
//  Created by Nhat (Norman) H.M. VU on 11/2/17.
//  Copyright © 2017 enclaveit. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

protocol MovieDetailViewControllerDelegate: class {
    func closeViewController(_ viewController: MovieDetailViewController, didTapBackButton button: UIBarButtonItem)
}

class MovieDetailViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var favoriteImage: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var reminderButton: UIButton!
    @IBOutlet weak var moviePosterImage: UIImageView!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var overviewTextView: UITextView!
    @IBOutlet weak var cashAndCrewList: UICollectionView!

    let movieAPI = APIManager()
    var isFavorited: Bool?
    var _currentMovie: Movie?
    var currentMovie: Movie? {
        get{
            return self._currentMovie
        }
        set(newValue) {
            self._currentMovie = newValue
        }
    }

    weak var delegate: MovieDetailViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = ""
        self.updateUI()

        self.cashAndCrewList.register(UINib(nibName: "GenresViewCell", bundle: nil), forCellWithReuseIdentifier: "GenresViewCell")
        print("Number of genres: \(self.currentMovie?.genres.count)")

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let n = self.currentMovie?.genres.count else {
            return
        }
        for i in 0..<n {
            //Call API to get genres detail
            self.movieAPI.getGenresDetail(genresID: (self.currentMovie?.genres[i].genresId!)!, completionHandler:{(UIBackgroundFetchResult) -> Void in
                print("genres image path at index \(i): \(self.movieAPI.genresImagePath)")
                if (self.movieAPI.genresImagePath != nil && self.movieAPI.genresImagePath != "") {
                    self.currentMovie?.genres[i].genresImagePath = self.movieAPI.genresImagePath
                }
                self.cashAndCrewList.reloadData()
            })
        }
    }

    func updateUI() {
        self.title = self.currentMovie?.title
        self.reminderButton.layer.cornerRadius = 3.0
        self.moviePosterImage.kf.setImage(with: ImageResource(downloadURL: (self.currentMovie?.posterURL!)!))
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        self.releaseDate.text = formatter.string(from: (self.currentMovie?.releaseDate)!)
        guard let rating = self.currentMovie?.voteAverage else {
            return
        }
        self.rating.text = String("\(rating)/10")
        guard let overview = self.currentMovie?.overview else {
            return
        }
        self.overviewTextView.text = overview
        self.favoriteImage.image = (self.currentMovie?.isFavorited)! ? #imageLiteral(resourceName: "ic_favorite") : #imageLiteral(resourceName: "ic_unfavorite")
        isFavorited = (self.currentMovie?.isFavorited)!
    }
    
    @IBAction func backButtonTapped(_ sender: UIBarButtonItem) {
        delegate?.closeViewController(self, didTapBackButton: backButton)
    }

    @IBAction func favoriteButtonTapped(_ sender: UIButton) {
        print("self.isFavorited = \(!self.isFavorited!)")
        movieAPI.setFavoriteMovies(mediaID: (self.currentMovie?.movieId)!, userID: (self.currentMovie?.userId!)!, sessionID: (self.currentMovie?.sessionId)!, favorite: !self.isFavorited!, completionHandler: {(UIBackgroundFetchResult) -> Void in
            if (self.movieAPI.statusCode! == 1 || self.movieAPI.statusCode! == 12 || self.movieAPI.statusCode! == 13) {
                self.favoriteImage.image = !self.isFavorited! == true ? #imageLiteral(resourceName: "ic_favorite") : #imageLiteral(resourceName: "ic_unfavorite")
                self.isFavorited = !self.isFavorited!
            }
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.currentMovie?.genres.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GenresViewCell", for: indexPath) as! GenresViewCell
        if (self.currentMovie?.genres[indexPath.item].genresImagePath == nil) {
            cell.genresImage.image = #imageLiteral(resourceName: "ic_placeholder")
        } else {
            cell.genresImage.kf.setImage(with: ImageResource(downloadURL: (self.currentMovie?.genres[indexPath.item].genresImageURL!)!))
        }
        cell.genresName.text = self.currentMovie?.genres[indexPath.item].genresName
        return cell
    }

    @IBAction func reminderButtonTapped(_ sender: UIButton) {
        let movieReminder: MovieReminders = MovieReminders()
        movieReminder.title = self.currentMovie?.title
        movieReminder.rating = "\(self.currentMovie?.voteAverage)/10"
        movieReminder.releaseDate = self.currentMovie?.releaseDate
        movieReminder.movieReminderImagePath = self.currentMovie?.backdropPath

        let isInserted = MovieReminderDatabase.getInstance().insertData(movieReminder)
        if isInserted{
            Util.invokeAlertMethod(title: "", body: "Insert data successfully", delegate: nil)
        }else
        {
            Util.invokeAlertMethod(title: "", body: "Error in inserting record", delegate: nil)
        }
    }
}
