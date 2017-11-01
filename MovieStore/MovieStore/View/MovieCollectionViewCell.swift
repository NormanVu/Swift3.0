//
//  MovieCollectionViewCell.swift
//  MovieStore
//
//  Created by Nhat (Norman) H.M. VU on 10/31/17.
//  Copyright © 2017 enclaveit. All rights reserved.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var topRating: UILabel!
    @IBOutlet weak var overview: UILabel!
    @IBOutlet weak var favoriteImageView: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        posterImage.image = #imageLiteral(resourceName: "ic_default")
        favoriteImageView.image = #imageLiteral(resourceName: "ic_star")
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd"
        releaseDate.text = dateFormater.string(from: dateFormater.date(from: "2017-09-17")!)
        topRating.text = "9.0/10"
        overview.text = "This is default movie"
        title.text = "Default movie"
    }
    
}
