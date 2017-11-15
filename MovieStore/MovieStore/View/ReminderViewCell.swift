//
//  ReminderViewCell.swift
//  MovieStore
//
//  Created by Nhat (Norman) H.M. VU on 11/15/17.
//  Copyright © 2017 enclaveit. All rights reserved.
//

import Foundation
import UIKit

class ReminderViewCell: UITableViewCell {
    @IBOutlet weak var reminderImage: UIImageView!
    @IBOutlet weak var reminderTitle: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var releaseDate: UILabel!

    var _movieId: Int?
    var movieId: Int? {
        get{
            return self._movieId
        }
        set(newValue) {
            self._movieId = newValue
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
