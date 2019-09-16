//
//  FavMoviesVC.swift
//  GenPact
//
//  Created by ketan shinde on 15/09/19.
//  Copyright © 2019 ketan shinde. All rights reserved.
//

import UIKit
import SVProgressHUD

class FavMoviesVC: UIViewController {
    
    var barButton: UIBarButtonItem!

    @IBOutlet private weak var tableViewFavs : UITableView!
    @IBOutlet private weak var lblNoFavs: UILabel!
    
    fileprivate var viewModel = FavMoviesVM()
    fileprivate let favTableStubs = FavMovieTableProtocol()
    
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewFavs.register(UINib(nibName: "MovieTableViewCell", bundle: nil), forCellReuseIdentifier:MovieTableViewCell.identifier)

        tableViewFavs.delegate = favTableStubs
        tableViewFavs.dataSource = favTableStubs
        tableViewFavs.setEditing(true, animated: true)

        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.parent?.title = "Favourites"
        tableViewFavs.setEditing(false, animated: true)

        fetchFavMoviesViewModel()
        setUpBarButon()
    }
    
    //MARK: - UIThings
    private func setUpBarButon () {
        
        if (tableViewFavs.isEditing == true) {
            barButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(setEditOrNot))
            self.parent?.navigationItem.rightBarButtonItem = barButton
        }
        else {
            barButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(setEditOrNot))
            self.parent?.navigationItem.rightBarButtonItem = barButton
        }
    }
    
    @objc func setEditOrNot() {
        if (tableViewFavs.isEditing == true) {
            tableViewFavs.setEditing(false, animated: true)
            barButton.title = "Edit"
        }
        else {
            tableViewFavs.setEditing(true, animated: true)
            barButton.title = "Done"
        }
    }
    
    //MARK: - Helpers
    
    @objc func fetchFavMoviesViewModel() {
        viewModel.fetchfavouriteMovies()
    }
    
    private func bindViewModel() {
        
        viewModel.dataHandler = { [weak self] (movies, error) in
            guard let strongSelf = self else {
                return
            }
            if error != nil {
                strongSelf.showAlertWithText(text: error!)
            }
            else {
                strongSelf.handleUI(moviesList: movies)
                strongSelf.favTableStubs.moviesList = movies
                strongSelf.tableViewFavs.reloadData()
            }
        }
        
        favTableStubs.uiHandler = { [weak self] (movies) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.handleUI(moviesList: movies)
        }
    }
    
    //MARK: - UI Things
    
    func handleUI(moviesList: [Movie]) {
        if moviesList.count > 0 {
            tableViewFavs.isHidden = false
            lblNoFavs.isHidden = true
        }
        else {
            tableViewFavs.isHidden = true
            lblNoFavs.isHidden = false
        }
    }
    private func showAlertWithText(text: String) {
        
        let alert = UIAlertController(title: "Error", message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

