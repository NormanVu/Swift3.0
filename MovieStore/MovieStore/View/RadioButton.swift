//
//  RadioButton.swift
//  MovieStore
//
//  Created by Nhat (Norman) H.M. VU on 11/8/17.
//  Copyright © 2017 enclaveit. All rights reserved.
//

import Foundation
import UIKit

class RadioButton: UIButton {
    var alternateButton:Array<RadioButton>?

    override func awakeFromNib() {
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 2.0
        self.layer.masksToBounds = true
    }

    func unselectAlternateButtons(){
        if alternateButton != nil {
            self.isSelected = true

            for aButton:RadioButton in alternateButton! {
                aButton.isSelected = false
            }
        }else{
            toggleButton()
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        unselectAlternateButtons()
        super.touchesBegan(touches, with: event)
    }

    func toggleButton(){
        self.isSelected = !isSelected
    }

    override var isSelected: Bool {
        didSet {
            if isSelected {
                self.layer.borderColor = UIColor.green.cgColor
            } else {
                self.layer.borderColor = UIColor.lightGray.cgColor
            }
        }
    }
}
