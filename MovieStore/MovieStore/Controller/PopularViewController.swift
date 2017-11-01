//
//  PopularViewController.swift
//  MovieStore
//
//  Created by Nhat (Norman) H.M. VU on 10/31/17.
//  Copyright © 2017 enclaveit. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

class PopularViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    let movieAPI: APIManager = APIManager()
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var layoutButton: UIBarButtonItem!
    
    var gridLayout: GridLayout!
    var listLayout: ListLayout!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        movieAPI.getPopularMovies(pageNumber: 1)

        gridLayout = GridLayout(numberOfColumns: 2)
        listLayout = ListLayout()
        
        collectionView.register(UINib(nibName: "MovieViewCell", bundle: nil), forCellWithReuseIdentifier: "MovieViewCell")
        collectionView.collectionViewLayout = gridLayout
        self.layoutButton.image = #imageLiteral(resourceName: "ic_view_list")
        self.collectionView.reloadData()
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
        return movieAPI.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieViewCell", for: indexPath) as! MovieCollectionViewCell
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd"
        
        cell.title.text = movieAPI.get(indexPath.item)?.title
        cell.posterImage.kf.setImage(with: ImageResource(downloadURL: (movieAPI.get(indexPath.item)?.backdropURL!)!))
        cell.releaseDate.text = dateFormater.string(from: (movieAPI.get(indexPath.item)?.releaseDate)!)
        cell.topRating.text = "\(movieAPI.get(indexPath.item)?.voteAverage ?? 5)/10"
        cell.overview.text = movieAPI.get(indexPath.item)?.overview
        
        return cell
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    
    // MARK: Action methods
    @IBAction func backButtonTapped(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
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
    
    
}
