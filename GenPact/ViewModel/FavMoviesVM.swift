//
//  FavMoviesVM.swift
//  GenPact
//
//  Created by ketan shinde on 15/09/19.
//  Copyright © 2019 ketan shinde. All rights reserved.
//

import Foundation
import UIKit

class FavMoviesVM: NSObject {
  
    var dataHandler:(([Movie], String?) -> Void)?
    var getMovies: [Movie] = [] // for future use

    override init() {
        super.init()
    }
    
    func fetchfavouriteMovies() {
        
        DatabaseManager.instance.retrieveData { [weak self] (coreMovies, error) in
            
            DispatchQueue.main.async(execute: {
                
                guard let strongSelf = self else {
                    return
                }
                if error != nil {
                    strongSelf.dataHandler?([], error?.localizedDescription)
                }
                else {
                    if let moviesData = coreMovies {
                        print("RESPONSE: \(moviesData)")
                        
                        strongSelf.getMovies = moviesData
                        strongSelf.dataHandler?(strongSelf.getMovies, nil)
                    }
                }
            })
        }

    }
}
