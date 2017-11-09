//
//  MoviesDetailViewController.swift
//  MovieStore
//
//  Created by Nhat (Norman) H.M. VU on 11/2/17.
//  Copyright © 2017 enclaveit. All rights reserved.
//

import Foundation
import UIKit

protocol MovieDetailViewControllerDelegate: class {
    func closeViewController(_ viewController: MovieDetailViewController, didTapBackButton button: UIBarButtonItem)
}

class MovieDetailViewController: UIViewController, iCarouselDelegate, iCarouselDataSource {
    
    @IBOutlet weak var carouselView: iCarousel!
    @IBOutlet weak var favoriteImage: UIImageView!
    @IBOutlet weak var reminderButton: UIButton!
    @IBOutlet weak var moviePosterImage: UIImageView!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var overview: UILabel!
    @IBOutlet weak var backButton: UIBarButtonItem!

    
    var imagesCashAndCrew = [UIImage]()
    weak var delegate: MovieDetailViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    
    //MARK: Data source iCarousel
    func numberOfItems(in carousel: iCarousel) -> Int {
        return imagesCashAndCrew.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        //Create a UIView
        let tempView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 75))
        
        //Create a UIImageView
        let frame = CGRect(x: 0, y: 0, width: 75, height: 75)
        let imageView = UIImageView()
        imageView.frame = frame
        imageView.contentMode = .scaleAspectFit
        
        //Set the images to the imageView and add it to the tempView.
        imageView.image = imagesCashAndCrew[index]
        tempView.addSubview(imageView)
        
        return tempView
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if (option == iCarouselOption.spacing) {
            return (value * 1.2)
        }
        return value
    }
    
    @IBAction func backButtonTapped(_ sender: UIBarButtonItem) {
        delegate?.closeViewController(self, didTapBackButton: backButton)
    }
}
