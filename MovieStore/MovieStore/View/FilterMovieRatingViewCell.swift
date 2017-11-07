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
    var _movieWithRate: Float?
    var movieWithRate: Float {
        get {
            return self._movieWithRate!
        }
        set(newValue) {
            self._movieWithRate = newValue
            slider.value = self._movieWithRate!
        }
    }

    var _movieRating: String?
    var movieRating: String {
        get {
            return self._movieRating!
        }
        set(newValue) {
            self._movieRating = newValue
            rating.text = self._movieRating!
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.rating.text = self._movieRating
        self.slider.value = self._movieWithRate!
    }
    


    @IBAction func sliderValueChanged(_ sender: UISlider) {
        let currentValue = Int(sender.value)
        self._movieWithRate = Float(currentValue)
        print("Slider changing to \(currentValue)")
        rating.text = "\(currentValue).0"
    }
}
