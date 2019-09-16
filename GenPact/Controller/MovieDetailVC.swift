//
//  MovieDetailVC.swift
//  GenPact
//
//  Created by ketan shinde on 15/09/19.
//  Copyright © 2019 ketan shinde. All rights reserved.
//

import UIKit

class MovieDetailVC: UIViewController {

    var barButton: UIBarButtonItem!
    
    @IBOutlet private weak var imgViewPoster: UIImageView!
    @IBOutlet private weak var lblTitle: UILabel!
    @IBOutlet private weak var lblOverView: UILabel!
    @IBOutlet private weak var lblLanguage: UILabel!
    @IBOutlet private weak var lblTotalVotes: UILabel!
    @IBOutlet private weak var lblDate: UILabel!
   
    var movieDetail: Movie!
    var favHandler: ((Movie) -> (Void))?
    var isFromFav: Bool = false

    
    //MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Details"
        setUpBarButon()
        loadMovieDetails()
    }
    
    //MARK: - UIThings
   private func setUpBarButon () {
        
        if (movieDetail.isFav == true) {
            barButton = UIBarButtonItem(title: "UnFavourite", style: .plain, target: self, action: #selector(toggleMovieForFavUnfav))
            self.navigationItem.rightBarButtonItem = barButton
        }
        else {
            barButton = UIBarButtonItem(title: "Favourite", style: .plain, target: self, action: #selector(toggleMovieForFavUnfav))
            self.navigationItem.rightBarButtonItem = barButton
        }
            if isFromFav {
                self.navigationItem.rightBarButtonItem = nil
            }
    }
    
   private func loadMovieDetails() {
        
        if let imgURL = movieDetail.posterPath {
            
            let formatURL = String(format: "%@/%@", EndPoints.bigImagePath, imgURL)
            imgViewPoster.sd_setImage(with: URL.init(string: formatURL), placeholderImage: UIImage(named: "default_icon"))
        } else {
            imgViewPoster.image = UIImage(named: "default_icon")
        }
        
        if let name = movieDetail.title {
            lblTitle.text = name
        } else {
            lblTitle.text = "-NA-"
        }
        
        if let overView = movieDetail.overview {
            lblOverView.text = overView
        } else {
            lblOverView.text = "-NA-"
        }
        
        if let lang = movieDetail.originalLanguage {
            lblLanguage.text = lang
        } else {
            lblLanguage.text = "-NA-"
        }
        
        if let voteCount = movieDetail.voteCount {
            lblTotalVotes.text = String(format: "%ld", voteCount)
        } else {
            lblTotalVotes.text = "-NA-"
        }
        
        if let dateRelease = movieDetail.releaseDate {
            lblDate.text = dateRelease
        } else {
            lblDate.text = "-NA-"
        }
    
        DatabaseManager.instance.fetchData(movie: movieDetail) { [weak self] (isExist) in
            guard let strongSelf = self else {
                return
            }
            if isExist! {
                strongSelf.movieDetail.isFav = true
                strongSelf.barButton.title = "UnFavourite"
                strongSelf.favHandler?(strongSelf.movieDetail)

            } else {
                strongSelf.makeMovieUnFav()
            }
        }
    }
    
    //MARK: - Helpers
    
    @objc func toggleMovieForFavUnfav() {
        
        if (movieDetail.isFav == true) {
            DatabaseManager.instance.deleteData(movie: movieDetail, completion: { [weak self] (isFinished, error) in
               
                guard let strongSelf = self else {
                   return
                }
                if isFinished! {
                    strongSelf.makeMovieUnFav()
                }
            })
        } else {
            movieDetail.isFav = true
            barButton.title = "UnFavourite"
            DatabaseManager.instance.createData(movie: movieDetail)
            favHandler?(movieDetail)
        }
    }
    
    func makeMovieUnFav() {
        movieDetail.isFav = false
        barButton.title = "Favourite"
        favHandler?(movieDetail)
    }

}
