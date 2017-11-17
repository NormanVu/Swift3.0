//
//  LoadMoreViewCell.swift
//  MovieStore
//
//  Created by Nhat (Norman) H.M. VU on 11/17/17.
//  Copyright © 2017 enclaveit. All rights reserved.
//

import Foundation
import UIKit

class LoadMoreViewCell : UICollectionViewCell {
    @IBOutlet weak var progressView : UIActivityIndicatorView!
    @IBOutlet weak var progressLabel : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func startStopLoading(_ isStart : Bool)
    {
        if(isStart){
            progressView.startAnimating()
            progressLabel.text = "Loading"
        } else {
            progressView.stopAnimating()
            progressLabel.text = "Load more"
        }
    }
}
