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

class FavoriteViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!

    var listLayout: ListLayout!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        listLayout = ListLayout()

        collectionView.register(UINib(nibName: "MovieViewCell", bundle: nil), forCellWithReuseIdentifier: "MovieViewCell")
        collectionView.collectionViewLayout = listLayout
        self.collectionView.reloadData()
        self.collectionView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView.reloadData()
    }

    // MARK: collectionView methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieViewCell", for: indexPath) as! MovieCollectionViewCell
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd"

        //cell.title.text = movieAPI.get(indexPath.item)?.title
        //cell.posterImage.kf.setImage(with: ImageResource(downloadURL: (movieAPI.get(indexPath.item)?.backdropURL!)!))
        //cell.releaseDate.text = dateFormater.string(from: (movieAPI.get(indexPath.item)?.releaseDate)!)
        //cell.topRating.text = "\(movieAPI.get(indexPath.item)?.voteAverage ?? 5)/10"
        //cell.overview.text = movieAPI.get(indexPath.item)?.overview

        return cell
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView.collectionViewLayout.invalidateLayout()
    }


}
