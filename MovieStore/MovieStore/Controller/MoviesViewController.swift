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
import CoreData

class MoviesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate{

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var layoutButton: UIBarButtonItem!
    @IBOutlet weak var menuButton: UIBarButtonItem!

    let movieAPI = APIManager.sharedAPI
    var gridLayout: GridLayout!
    var listLayout: ListLayout!
    var allMovies = [Movie]()
    var favoriteMovies = [Movie]()
    var requestToken: String?
    var sessionID: String?
    var userID: Int?
    var currentMovieId: Int?
    var favorited: Bool?
    var currentMovieSetting: MovieSettings?
    var movieSetting: NSManagedObject? = nil
    var profile = Profile()
    var notifyFavorite: Movie?

    var currentPage: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        //Load setting from core data
        loadMovieSettingsFromCoreData()

        //Force auto login
        self.autoLogin()

        //Side menu using SWRevealViewController framework
        if (revealViewController() != nil) {
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().rearViewRevealWidth = self.view.frame.width - 60
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            //Close rear view controller when tap on front view controller
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        }

        //Load default popular movies without appling filter movies
        if (currentMovieSetting == nil) {
            self.navigationItem.title = "Popular"
            self.currentPage = 1
            movieAPI.getPopularMovies(currentPage: self.currentPage, completionHandler:{(UIBackgroundFetchResult) -> Void in
                self.allMovies = self.movieAPI.allMovies
                self.collectionView.reloadData()
            })
        } else {
            self.applyFilterMovies()
        }
        //Receive(Get) Notification: Setting
        NotificationCenter.default.addObserver(self, selector: #selector(MoviesViewController.onCreatedSettingNotification), name: NSNotification.Name(rawValue: "createdSettingsNotification"), object: nil)

        //Receive(Get) Notification: Favorite/Unfavorite
        NotificationCenter.default.addObserver(self, selector: #selector(MoviesViewController.onCreatedFavoriteNotification), name: NSNotification.Name(rawValue: "createdFavoritesNotification"), object: nil)

        gridLayout = GridLayout(numberOfColumns: 2)
        listLayout = ListLayout()

        collectionView.register(UINib(nibName: "MovieViewCell", bundle: nil), forCellWithReuseIdentifier: "MovieViewCell")
        //collectionView.register(UINib(nibName: "LoadMoreViewCell", bundle: nil), forCellWithReuseIdentifier: "LoadMoreViewCell")
        collectionView.collectionViewLayout = gridLayout
        self.layoutButton.image = #imageLiteral(resourceName: "ic_view_list")

        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }

    func applyFilterMovies() {
        self.allMovies.removeAll()
        movieAPI.allMovies.removeAll()
        self.navigationItem.title = ""
        self.title = "Movies"
        self.currentPage = 1
        if (currentMovieSetting?.popularMovies)! {
            movieAPI.getPopularMovies(currentPage: self.currentPage, completionHandler:{(UIBackgroundFetchResult) -> Void in
                self.allMovies = self.movieAPI.allMovies
                self.collectionView.reloadData()
            })
            self.navigationItem.title = "Popular"
        }
        if (currentMovieSetting?.topRatedMovies)! {
            movieAPI.getTopRatingMovies(currentPage: self.currentPage, completionHandler:{(UIBackgroundFetchResult) -> Void in
                self.allMovies = self.movieAPI.allMovies
                self.collectionView.reloadData()
            })
            self.navigationItem.title = "Top Rated"
        }
        if (currentMovieSetting?.upComingMovies)! {
            movieAPI.getUpComingMovies(currentPage: self.currentPage, completionHandler:{(UIBackgroundFetchResult) -> Void in
                self.allMovies = self.movieAPI.allMovies
                self.collectionView.reloadData()
            })
            self.navigationItem.title = "Up Coming"
        }
        if (currentMovieSetting?.nowPlayingMovies)! {
            movieAPI.getNowPlayingMovies(currentPage: self.currentPage, completionHandler:{(UIBackgroundFetchResult) -> Void in
                self.allMovies = self.movieAPI.allMovies
                self.collectionView.reloadData()
            })
            self.navigationItem.title = "Now Playing"
        }
    }

    func loadMoreData(indexPath: IndexPath) {
        if (currentMovieSetting != nil) {
            if (currentMovieSetting?.popularMovies)! {
                if ((self.currentPage < movieAPI.totalPage!) && (indexPath.row == self.allMovies.count - delta)) {
                    self.currentPage = self.currentPage + 1
                    movieAPI.getPopularMovies(currentPage: self.currentPage, completionHandler:{(UIBackgroundFetchResult) -> Void in
                        self.allMovies += self.movieAPI.allMovies
                        self.collectionView.reloadData()
                    })
                }
            }
            if (currentMovieSetting?.topRatedMovies)! {
                if ((self.currentPage < movieAPI.totalPage!) && (indexPath.row == self.allMovies.count - delta)) {
                    self.currentPage = self.currentPage + 1
                    movieAPI.getTopRatingMovies(currentPage: self.currentPage, completionHandler:{(UIBackgroundFetchResult) -> Void in
                        self.allMovies += self.movieAPI.allMovies
                        self.collectionView.reloadData()
                    })
                }
            }
            if (currentMovieSetting?.upComingMovies)! {
                if ((self.currentPage < movieAPI.totalPage!) && (indexPath.row == self.allMovies.count - delta)) {
                    self.currentPage = self.currentPage + 1
                    movieAPI.getUpComingMovies(currentPage: self.currentPage, completionHandler:{(UIBackgroundFetchResult) -> Void in
                        self.allMovies += self.movieAPI.allMovies
                        self.collectionView.reloadData()
                    })
                }
            }
            if (currentMovieSetting?.nowPlayingMovies)! {
                if ((self.currentPage < movieAPI.totalPage!) && (indexPath.row == self.allMovies.count - delta)) {
                    self.currentPage = self.currentPage + 1
                    movieAPI.getNowPlayingMovies(currentPage: self.currentPage, completionHandler:{(UIBackgroundFetchResult) -> Void in
                        self.allMovies += self.movieAPI.allMovies
                        self.collectionView.reloadData()
                    })
                }
            }
        } else {
            //Load default popular movies
            if ((self.currentPage < movieAPI.totalPage!) && (indexPath.row == self.allMovies.count - delta)) {
                self.currentPage = self.currentPage + 1
                movieAPI.getPopularMovies(currentPage: self.currentPage, completionHandler:{(UIBackgroundFetchResult) -> Void in
                    self.allMovies += self.movieAPI.allMovies
                    self.collectionView.reloadData()
                })
            }
        }
    }

    //Method handler for received Notification Settings
    func onCreatedSettingNotification(notification: NSNotification) {
        //Receive settings did change
        self.currentMovieSetting = UserDefaultManager.getMovieSettings()
        if (self.currentMovieSetting != nil) {
            //Reload data to change following current settings from user
            applyFilterMovies()
        }
    }

    //Method handler for received Notification Favorites
    func onCreatedFavoriteNotification(notification: NSNotification) {
        //Receive favorites
        if let favoriteDict = notification.object as? [String: Movie] {
            if (favoriteDict["notifyFavorite"]) != nil {
                notifyFavorite = favoriteDict["notifyFavorite"]
            }
        }
    }

    //Remove Notification
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "createdSettingsNotification"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "createdFavoritesNotification"), object: nil)
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
        notifyFavorite = nil
        saveMovieSettingsToCoreData()
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
        self.allMovies[indexPath.item].genres.removeAll()

        //Call API to load genres list
        self.movieAPI.getMovieDetail(movieID: self.allMovies[indexPath.row].movieId, completionHandler:{(UIBackgroundFetchResult) -> Void in
            self.allMovies[indexPath.item].genres = self.movieAPI.allGenres
        })
        if (notifyFavorite != nil && notifyFavorite?.movieId == self.allMovies[indexPath.row].movieId) {
            //Update following notify favorite
            print("Update following notify favorite")
            if let isFavorited = notifyFavorite?.isFavorited {
                cell.favoriteImageView.image = isFavorited ? #imageLiteral(resourceName: "ic_favorite") : #imageLiteral(resourceName: "ic_unfavorite")
            }
        } else {
            let isFavorited = self.isFavoriteMovie(movieId: cell.movieId!)
            cell.favorite = isFavorited
            cell.favoriteImageView.image = isFavorited ? #imageLiteral(resourceName: "ic_favorite") : #imageLiteral(resourceName: "ic_unfavorite")
        }
        cell.delegate = self
        loadMoreData(indexPath: indexPath)


        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? MovieViewCell
        self.currentMovieId = cell?.movieId

        //Select current movie to load movie detail
        guard let movieDetailViewController = storyboard?.instantiateViewController(withIdentifier: "MovieDetailViewController") as? MovieDetailViewController else {
            return
        }
        movieDetailViewController.delegate = self
        movieDetailViewController.currentMovie = allMovies[indexPath.row]
        if (notifyFavorite != nil && notifyFavorite?.movieId == self.allMovies[indexPath.row].movieId) {
            movieDetailViewController.currentMovie?.isFavorited = (notifyFavorite?.isFavorited)! ? true: false
        } else {
            if (self.isFavoriteMovie(movieId: allMovies[indexPath.row].movieId)) {
                movieDetailViewController.currentMovie?.isFavorited = true
            } else {
                movieDetailViewController.currentMovie?.isFavorited = false
            }
        }
        movieDetailViewController.currentMovie?.userId = self.profile.userId
        movieDetailViewController.currentMovie?.sessionId = self.profile.sessionId
        navigationController?.pushViewController(movieDetailViewController, animated: true)
    }

    //MARK: Actions
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
                        self.profile.gender = 2
                        self.profile.avatar = #imageLiteral(resourceName: "ic_placeholder")
                        self.profile.birthday = Date()

                        //Store session id and user information into user default manager
                        UserDefaultManager.updateProfile(userProfile: self.profile)
                        //Step 5: Get favorite movies
                        self.movieAPI.getFavoriteMovies(userID: self.userID!, sessionID: self.sessionID!, completionHandler: {(UIBackgroundFetchResult) -> Void in
                            self.favoriteMovies = self.movieAPI.favoriteMovies
                            self.movieAPI.favoriteMovies.removeAll()
                        })
                    })
                })
            })
        })
    }

    func isFavoriteMovie(movieId: Int) -> Bool {
        for movie in self.favoriteMovies {
            if (movie.movieId == movieId) {
                return true
            }
        }
        return false
    }

    func loadMovieSettingsFromCoreData() {
        //
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        if #available(iOS 10.0, *) {
            // managed context
            let managedContext =
                appDelegate.persistentContainer.viewContext
            // movieSetting entity
            let movieSettingEntity =
                NSEntityDescription.entity(forEntityName: "MovieSetting", in: managedContext)!
            movieSetting = NSManagedObject(entity: movieSettingEntity, insertInto: managedContext)

            // Get values
            let popularMovie = movieSetting?.value(forKeyPath: "popularMovies") as? Bool
            currentMovieSetting?.popularMovies = popularMovie!
            let topRatedMovie = movieSetting?.value(forKeyPath: "topRatedMovies") as? Bool
            currentMovieSetting?.topRatedMovies = topRatedMovie!
            let upComingMovie = movieSetting?.value(forKeyPath: "upComingMovies") as? Bool
            currentMovieSetting?.upComingMovies = upComingMovie!
            let nowPlayingMovie = movieSetting?.value(forKeyPath: "nowPlayingMovies") as? Bool
            currentMovieSetting?.nowPlayingMovies = nowPlayingMovie!
            currentMovieSetting?.movieWithRate = movieSetting?.value(forKeyPath: "movieWithRate") as! Float
            currentMovieSetting?.fromReleaseYear = movieSetting?.value(forKeyPath: "fromReleaseYear") as! Int
            let releaseDate = movieSetting?.value(forKeyPath: "releaseDate") as? Bool
            currentMovieSetting?.releaseDate = releaseDate!
            let rating = movieSetting?.value(forKeyPath: "rating") as? Bool
            currentMovieSetting?.rating = rating!
        } else {
            // Fallback on earlier versions
        }
    }


    func saveMovieSettingsToCoreData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        if #available(iOS 10.0, *) {
            // managed context
            let managedContext =
                appDelegate.persistentContainer.viewContext
            // movieSetting entity
            let movieSettingEntity =
                NSEntityDescription.entity(forEntityName: "MovieSetting", in: managedContext)!
            movieSetting = NSManagedObject(entity: movieSettingEntity, insertInto: managedContext)
            movieSetting?.setValue(self.currentMovieSetting?.popularMovies, forKeyPath: "popularMovies")
            movieSetting?.setValue(self.currentMovieSetting?.topRatedMovies, forKeyPath: "topRatedMovies")
            movieSetting?.setValue(self.currentMovieSetting?.upComingMovies, forKeyPath: "upComingMovies")
            movieSetting?.setValue(self.currentMovieSetting?.nowPlayingMovies, forKeyPath: "nowPlayingMovies")
            movieSetting?.setValue(self.currentMovieSetting?.movieWithRate, forKeyPath: "movieWithRate")
            movieSetting?.setValue(self.currentMovieSetting?.fromReleaseYear, forKeyPath: "fromReleaseYear")
            movieSetting?.setValue(self.currentMovieSetting?.releaseDate, forKeyPath: "releaseDate")
            movieSetting?.setValue(self.currentMovieSetting?.rating, forKeyPath: "rating")
        } else {
            //Fall back
        }
    }
}

extension MoviesViewController: MovieDetailViewControllerDelegate {
    func closeViewController(_ viewController: MovieDetailViewController, didTapBackButton button: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
        self.collectionView.reloadData()
    }
}

extension MoviesViewController: FavoriteMovieViewCellDelegate {
    func didTapFavoriteMovieButton(_ movieViewCell: MovieViewCell) {
        if (!movieViewCell.favorite! == false) {
            let alert = UIAlertController(title: nil, message: "Are you sure you want to\n unfavortie this item?", preferredStyle: UIAlertControllerStyle.alert)
            alert.isModalInPopover = true

            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction!) in
                self.movieAPI.setFavoriteMovies(mediaID: movieViewCell.movieId!, userID: self.userID!, sessionID: self.sessionID!, favorite: !movieViewCell.favorite!, completionHandler: {(UIBackgroundFetchResult) -> Void in
                    if (self.movieAPI.statusCode! == 1 || self.movieAPI.statusCode! == 12 || self.movieAPI.statusCode! == 13) {
                        print("Status code: \(self.movieAPI.statusCode!)")
                        movieViewCell.favoriteImageView.image = !movieViewCell.favorite! ? #imageLiteral(resourceName: "ic_favorite") : #imageLiteral(resourceName: "ic_unfavorite")
                        movieViewCell.favorite = !movieViewCell.favorite!
                    }
                })
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: {(action:UIAlertAction!) in
                print("Cancel")
            }))
            self.present(alert, animated: true, completion: nil)
        } else {
            print("Favorite!!!")
            movieAPI.setFavoriteMovies(mediaID: movieViewCell.movieId!, userID: self.userID!, sessionID: self.sessionID!, favorite: !movieViewCell.favorite!, completionHandler: {(UIBackgroundFetchResult) -> Void in
                if (self.movieAPI.statusCode! == 1 || self.movieAPI.statusCode! == 12 || self.movieAPI.statusCode! == 13) {
                    print("Status code: \(self.movieAPI.statusCode!)")
                    movieViewCell.favoriteImageView.image = !movieViewCell.favorite! ? #imageLiteral(resourceName: "ic_favorite") : #imageLiteral(resourceName: "ic_unfavorite")
                    movieViewCell.favorite = !movieViewCell.favorite!
                }
            })
        }
    }
}
