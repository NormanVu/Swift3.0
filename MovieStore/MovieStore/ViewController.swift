//
//  ViewController.swift
//  MovieStore
//
//  Created by Nhat (Norman) H.M. VU on 10/17/17.
//  Copyright © 2017 enclaveit. All rights reserved.
//

import UIKit
import Kingfisher
import Alamofire
import ESPullToRefresh
import FMDB
import SwiftyJSON

class ViewController: UIViewController {
    let movieAPI: APIManager = APIManager()
    @IBOutlet weak var popular: UIImageView!
    @IBOutlet weak var tapGestureImageView: UITapGestureRecognizer!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tapGestureImageView.addTarget(self, action: #selector(tapPopular))
        self.view!.addGestureRecognizer(tapGestureImageView)
        movieAPI.getPopularMovies(pageNumber: 1)

        //movieAPI.getFavoriteMovies()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    func tapPopular() {
        let popularViewController = storyboard?.instantiateViewController(withIdentifier: "popularViewController") as! PopularViewController
        popularViewController.popularMovies = movieAPI.allMovies
        navigationController?.pushViewController(popularViewController, animated: true)
    }
}

