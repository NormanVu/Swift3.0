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

class MoviesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var layoutButton: UIBarButtonItem!
    @IBOutlet weak var filterButton: UIBarButtonItem!

    let movieAPI = APIManager()
    var gridLayout: GridLayout!
    var listLayout: ListLayout!
    var allMovies = [Movie]()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        userDefault.value(forKeyPath: "movieSettings")
        print("value 0: \(userDefault.array(forKey: "movieSettings")?.count)")
        //print("value 1: \(userDefault.arrayValue(forKeyPath: "movieSettings").object(at: 1))")
        /*
 self.popularMovies = Bool?((rawData.object(forKey: "popularMovies") as! Bool))!
 self.topRatedMovies = Bool?((rawData.object(forKey: "topRatedMovies") as! Bool))!
 self.upComingMovies = Bool?((rawData.object(forKey: "upComingMovies") as! Bool))!
 self.nowPlayingMovies = Bool?((rawData.object(forKey: "nowPlayingMovies") as! Bool))!
 self.movieWithRate = Float?((rawData.object(forKey: "movieWithRate") as! Float))!
 self.movieReleaseFromYear = Int?((rawData.object(forKey: "movieReleaseFromYear") as! Int))!
 self.releaseDate = Bool?((rawData.object(forKey: "releaseDate") as! Bool))!
 self.rating = Bool?((rawData.object(forKey: "rating") as! Bool))!
 */

        movieAPI.getPopularMovies(completionHandler:{(UIBackgroundFetchResult) -> Void in
            self.allMovies = self.movieAPI.allMovies
            self.collectionView.reloadData()
        })

        gridLayout = GridLayout(numberOfColumns: 2)
        listLayout = ListLayout()

        collectionView.register(UINib(nibName: "MovieViewCell", bundle: nil), forCellWithReuseIdentifier: "MovieViewCell")
        collectionView.collectionViewLayout = gridLayout
        self.layoutButton.image = #imageLiteral(resourceName: "ic_view_list")

        self.collectionView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        cell.posterImage.kf.setImage(with: ImageResource(downloadURL: self.allMovies[indexPath.item].posterURL!))
        cell.releaseDate.text = dateFormater.string(from: self.allMovies[indexPath.item].releaseDate)
        cell.topRating.text = "\(self.allMovies[indexPath.item].voteAverage)/10"
        cell.overview.text = self.allMovies[indexPath.item].overview

        return cell
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView.collectionViewLayout.invalidateLayout()
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
}
