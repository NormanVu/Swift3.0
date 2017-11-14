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

class MovieDetailViewController: UIViewController, iCarouselDataSource, iCarouselDelegate{
    @IBOutlet weak var carouselView: iCarousel!
    @IBOutlet weak var favoriteImage: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var reminderButton: UIButton!
    @IBOutlet weak var moviePosterImage: UIImageView!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var overviewTextView: UITextView!

    let movieAPI = APIManager()
    var imagesCashAndCrew = [UIImage]()
    var _currentMovie: Movie?
    var genres = [Genres]()
    var isFavorited: Bool?
    var tempImage: UIImageView?
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
        carouselView.delegate = self
        carouselView.dataSource = self
        carouselView.type = iCarouselType.linear

        //Call API to load movie detail
        self.imagesCashAndCrew.removeAll()
        movieAPI.getMovieDetail(movieID: (self.currentMovie?.movieId)!, completionHandler:{(UIBackgroundFetchResult) -> Void in
            //Call API to get image of genres to display at Cash & Crew
            self.genres = self.movieAPI.allGenres
            print("Number of genres: \(self.genres.count)")
            for _genres in self.genres {
                self.movieAPI.getGenresDetail(genresID: _genres.genresId!, completionHandler:{(UIBackgroundFetchResult) -> Void in
                    if (self.movieAPI.genresImage == "") {
                        self.imagesCashAndCrew.append(#imageLiteral(resourceName: "ic_placeholder"))
                    } else {
                        self.imagesCashAndCrew.append(#imageLiteral(resourceName: "ic_placeholder"))

                        //@TODO: Can't set image resource from URL
                        _genres.genresImage = self.movieAPI.genresImage
                        self.tempImage?.kf.setImage(with: ImageResource(downloadURL: (_genres.genresImageURL!)))
                        guard let genresImage: UIImageView = self.tempImage else {
                            return
                        }
                        self.imagesCashAndCrew.append(genresImage.image!)
                    }
                    self.genres = self.movieAPI.allGenres
                    self.carouselView.reloadData()
                })
            }
        })
        self.updateUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    func updateUI() {
        self.title = self.currentMovie?.title
        self.reminderButton.layer.cornerRadius = 3.0
        self.moviePosterImage.kf.setImage(with: ImageResource(downloadURL: (self.currentMovie?.posterURL!)!))
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
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
        print("Carousel number of images: \(self.imagesCashAndCrew.count)")

    }
    
    //MARK: Data source iCarousel
    func numberOfItems(in carousel: iCarousel) -> Int {
        return self.imagesCashAndCrew.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        var label: UILabel
        var tempView: UIImageView

        //reuse view if available, otherwise create a new view
        if let view = view as? UIImageView {
            tempView = view
            label = tempView.viewWithTag(1) as! UILabel
        } else {
            tempView = UIImageView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
            tempView.image = imagesCashAndCrew[index]
            tempView.contentMode = .scaleAspectFit

            label = UILabel(frame: CGRect(x: 0, y: 81, width: 80, height: 25))
            label.backgroundColor = UIColor.clear
            label.textAlignment = .center
            label.font = label.font.withSize(17.0)
            label.tag = 1
            tempView.addSubview(label)
        }
        label.text = "\(genres[index].genresName)"
        return tempView
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if (option == iCarouselOption.spacing) {
            return (value * 1.2)
        }
        return value
    }
    
    @IBAction func backButtonTapped(_ sender: UIBarButtonItem) {
        delegate?.closeViewController(self, didTapBackButton: backButton)
    }

    @IBAction func favoriteButtonTapped(_ sendr: UIButton) {
        print("self.isFavorited = \(!self.isFavorited!)")
        movieAPI.setFavoriteMovies(mediaID: (self.currentMovie?.movieId)!, userID: (self.currentMovie?.userId!)!, sessionID: (self.currentMovie?.sessionId)!, favorite: !self.isFavorited!, completionHandler: {(UIBackgroundFetchResult) -> Void in
            if (self.movieAPI.statusCode! == 1 || self.movieAPI.statusCode! == 12 || self.movieAPI.statusCode! == 13) {
                self.favoriteImage.image = !self.isFavorited! == true ? #imageLiteral(resourceName: "ic_favorite") : #imageLiteral(resourceName: "ic_unfavorite")
                self.isFavorited = !self.isFavorited!
            }
        })
    }
}
