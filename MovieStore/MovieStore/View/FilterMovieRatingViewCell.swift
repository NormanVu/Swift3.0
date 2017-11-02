//
//  SortByViewCell.swift
//  MovieStore
//
//  Created by Nhat (Norman) H.M. VU on 11/2/17.
//  Copyright © 2017 enclaveit. All rights reserved.
//

import UIKit

class FilterMovieRatingViewCell: UITableViewCell {
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var slider: UISlider!

    override func prepareForReuse() {
        super.prepareForReuse()
        self.rating.text = "0.0"
        self.slider.value = 0
    }

    @IBAction func sliderValueChanged(_ sender: UISlider) {
        let currentValue = Int(sender.value)
        print("Slider changing to \(currentValue)")
        rating.text = "\(currentValue)"
    }
}
