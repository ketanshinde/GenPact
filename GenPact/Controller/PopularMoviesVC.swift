//
//  PopularMoviesVC.swift
//  GenPact
//
//  Created by ketan shinde on 15/09/19.
//  Copyright © 2019 ketan shinde. All rights reserved.
//

import UIKit
import SVProgressHUD

class PopularMoviesVC: UIViewController {
    
    @IBOutlet private weak var tableViewMovies : UITableView!
    fileprivate var viewModel = PopularMoviesVM()
    fileprivate let tableDelegateAndDataSource = MovieTableProtocol()
    
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableViewMovies.register(UINib(nibName: "MovieTableViewCell", bundle: nil), forCellReuseIdentifier:MovieTableViewCell.identifier)

        tableViewMovies.delegate = tableDelegateAndDataSource
        tableViewMovies.dataSource = tableDelegateAndDataSource
        createRefreshController()

        bindViewModel()
        fetchMoviesFromViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.parent?.title = "Movies"
        self.parent?.navigationItem.rightBarButtonItem = nil
    }
    
   private func createRefreshController() {
        DispatchQueue.main.async(execute: {
            
            if (self.refreshControl == nil) {
                self.refreshControl = UIRefreshControl()
            }
            if #available(iOS 10.0, *) {
                self.tableViewMovies.refreshControl = self.refreshControl
            } else {
                self.tableViewMovies.addSubview(self.refreshControl)
            }
            self.refreshControl.addTarget(self, action: #selector(self.fetchMoviesFromViewModel), for: .valueChanged)
        })
    }
    
    //MARK: - Helpers
    
    @objc func fetchMoviesFromViewModel() {
        SVProgressHUD.show()
        viewModel.fetchPopularMovies()
    }
    
   private func bindViewModel() {
        viewModel.dataHandler = { [weak self] (movies, error) in
            guard let strongSelf = self else {
                return
            }
            SVProgressHUD.dismiss()
            strongSelf.refreshControl.endRefreshing()

            if error != nil {
                strongSelf.showAlertWithText(text: error!)
            }
            else {
                strongSelf.tableDelegateAndDataSource.moviesList = movies
                strongSelf.tableViewMovies.reloadData()
            }
        }
    }

    //MARK: - UI Things
   private func showAlertWithText(text: String) {
        
        let alert = UIAlertController(title: "Error", message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}

