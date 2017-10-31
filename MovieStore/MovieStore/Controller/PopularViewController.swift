//
//  PopularViewController.swift
//  MovieStore
//
//  Created by Nhat (Norman) H.M. VU on 10/31/17.
//  Copyright © 2017 enclaveit. All rights reserved.
//

import Foundation
import UIKit

class PopularViewController: UIViewController {
    var movies = [Movie]()
    let api = APIManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        movies = api.getPopularMovies(pageNumber: 1)
        for movie in movies {
            print(movie.toParameters())
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
}
