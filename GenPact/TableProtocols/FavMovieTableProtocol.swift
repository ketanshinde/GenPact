//
//  FavMovieTableProtocol.swift
//  GenPact
//
//  Created by ketan shinde on 15/09/19.
//  Copyright © 2019 ketan shinde. All rights reserved.
//

import Foundation
import UIKit

class FavMovieTableProtocol: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    var moviesList: [Movie] = []
    var uiHandler: (([Movie]) -> (Void))?
    
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
        viewController.isFromFav = true
        viewController.movieDetail = moviesList[indexPath.row]
        APP_DELEGATE.appNavController?.pushViewController(viewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            DatabaseManager.instance.deleteData(movie: moviesList[indexPath.row], completion: { [weak self] (isFinished, error) in
                
                guard let strongSelf = self else {
                    return
                }
                if isFinished! {
                    strongSelf.moviesList.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath as IndexPath], with: .automatic)
                    
                    if (strongSelf.moviesList.count == 0) {
                        strongSelf.uiHandler?(strongSelf.moviesList)
                    }
                }
            })
        }
    }
    
}
