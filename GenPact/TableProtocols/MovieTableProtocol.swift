//
//  MoviesTableProtocol.swift
//  GenPact
//
//  Created by ketan shinde on 15/09/19.
//  Copyright © 2019 ketan shinde. All rights reserved.
//

import Foundation
import UIKit

class MovieTableProtocol: NSObject, UITableViewDelegate, UITableViewDataSource {

    var moviesList: [Movie] = []
    
    override init() {
        super.init()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviesList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as? MovieTableViewCell {
            cell.selectionStyle = .none
            cell.accessoryType = .disclosureIndicator
            cell.loadData(facts: moviesList[indexPath.row])
            cell.minHeight = 100
            return cell
        }
       return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let viewController = AppDelegate.mainStoryboard.instantiateViewController(withIdentifier: "MovieDetailVC") as! MovieDetailVC
        viewController.movieDetail = moviesList[indexPath.row]
        viewController.favHandler = { [weak self] (movie) in
            guard let strongSelf = self else {
                return
            }
          if let geti = strongSelf.moviesList.firstIndex(where: { (mov) -> Bool in
                mov.id == movie.id
          })
          {
            strongSelf.moviesList[geti].isFav = movie.isFav
            tableView.reloadData()
           }
        }
        APP_DELEGATE.appNavController?.pushViewController(viewController, animated: true)
        
    }
}
