//
//  AppConstants.swift
//  GenPact
//
//  Created by ketan shinde on 15/09/19.
//  Copyright © 2019 ketan shinde. All rights reserved.
//

import Foundation
import UIKit

var API_KEY = "0af317b60dbe0cbb815be52df0de1e08"
let APP_DELEGATE = UIApplication.shared.delegate as! AppDelegate

struct EndPoints {
    
    static let popularMoviesApi = "https://api.themoviedb.org/3/discover/movie?sort_by=popularity.desc"
    static let smallImagePath = "https://image.tmdb.org/t/p/w200"
    static let bigImagePath = "https://image.tmdb.org/t/p/w500"
}
