//
//  PopularMoviesVM.swift
//  GenPact
//
//  Created by ketan shinde on 15/09/19.
//  Copyright © 2019 ketan shinde. All rights reserved.
//

import Foundation
import UIKit

class PopularMoviesVM: NSObject {
  
    var apiSession = ApiSession()
    var dataHandler:(([Movie], String?) -> Void)?
    var getMovies: [Movie] = [] // for future use
    
    override init() {
        super.init()
    }
    
    func fetchPopularMovies() {

        apiSession.urlString = String(format: "%@&api_key=%@", EndPoints.popularMoviesApi, API_KEY)
        
        apiSession.fetchData(type: MovieResponse.self) { [weak self] (response, error) in
            
            DispatchQueue.main.async(execute: {
                
                guard let strongSelf = self else {
                    return
                }
                if error != nil {
                    strongSelf.dataHandler?([], error?.localizedDescription)
                }
                else {
                    if let moviesData = response?.results {
                        print("RESPONSE: \(moviesData)")

                        strongSelf.getMovies = moviesData
                        strongSelf.dataHandler?(strongSelf.getMovies, nil)
                    }
                }
            })
        }
    }
}
