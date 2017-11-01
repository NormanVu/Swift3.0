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
    let api = APIManager()
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
        gridLayout = GridLayout(numberOfColumns: 2)
        listLayout = ListLayout()
        
        collectionView.register(UINib(nibName: "MovieViewCell", bundle: nil), forCellWithReuseIdentifier: "MovieViewCell")
        collectionView.collectionViewLayout = gridLayout
        self.layoutButton.image = #imageLiteral(resourceName: "ic_view_module")
        collectionView.reloadData()
        
        api.getPopularMovies(pageNumber: 1)
        print(api.count)
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
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieViewCell", for: indexPath) as! MovieCollectionViewCell
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd"
        
        //cell.title.text = api.get(indexPath.item)?.title
        //cell.posterImage.kf.setImage(with: ImageResource(downloadURL: (api.get(indexPath.item)?.backdropURL!)!))
        //cell.releaseDate.text = dateFormater.string(from: (api.get(indexPath.item)?.releaseDate)!)
        //cell.topRating.text = "\(String(describing: api.get(indexPath.item)?.voteAverage))" + "/" + "\(String(describing: api.get(indexPath.item)?.voteCount))"
        //cell.overview.text = api.get(indexPath.item)?.overview
        
        return cell
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    // MARK: tableView methods
    
    
    // MARK: Action methods
    @IBAction func backButtonTapped(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func layoutButtonTapped(_ sender: UIBarButtonItem) {
        
        if (collectionView.collectionViewLayout == gridLayout) {
            layoutButton.image = #imageLiteral(resourceName: "ic_view_list")
            UIView.animate(withDuration: 0.1, animations: {
                self.collectionView.collectionViewLayout.invalidateLayout()
                self.collectionView.setCollectionViewLayout(self.listLayout, animated: false)
            })
        } else {
            layoutButton.image = #imageLiteral(resourceName: "ic_view_module")
            UIView.animate(withDuration: 0.1, animations: {
                self.collectionView.collectionViewLayout.invalidateLayout()
                self.collectionView.setCollectionViewLayout(self.gridLayout, animated: false)
            })
        }
    }
    
    
}
