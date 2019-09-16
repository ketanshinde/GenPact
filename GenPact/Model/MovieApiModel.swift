//
//  MovieApiModel.swift
//  GenPact
//
//  Created by ketan shinde on 15/09/19.
//  Copyright © 2019 ketan shinde. All rights reserved.
//

import Foundation

struct MovieResponse: Codable {
    
    var page: Int?
    var total_results: Int?
    var total_pages: Int?
    var results: [Movie]?
 
    enum MovieResponseCodingKeys: String, CodingKey {
        case page
        case total_results
        case total_pages
        case results
    }
    
    init(from decoder: Decoder) throws {
        let movieResponseContainer = try decoder.container(keyedBy: MovieResponseCodingKeys.self)
        
        page = movieResponseContainer.contains(.page) ? try movieResponseContainer.decode(Int.self, forKey: .page) : 0
        total_results = movieResponseContainer.contains(.total_results) ? try movieResponseContainer.decode(Int.self, forKey: .total_results) : 0
        total_pages = movieResponseContainer.contains(.total_pages) ? try movieResponseContainer.decode(Int.self, forKey: .total_pages) : 0
        results = movieResponseContainer.contains(.results) ? try movieResponseContainer.decode([Movie].self, forKey: .results) : []
    }
}

class Movie: Codable {
    
    var voteCount: Int?
    var posterPath: String?
    var id: Int?
    var originalLanguage: String?
    var title: String?
    var overview: String?
    var releaseDate: String?
    var isFav: Bool?
    
    enum MovieCodingKeys: String, CodingKey {
        
        case voteCount = "vote_count"
        case posterPath = "poster_path"
        case id
        case originalLanguage = "original_language"
        case title
        case overview
        case releaseDate = "release_date"
        case isFav
    }
    
    required init(from decoder: Decoder) throws {
    
        let movieContainer = try decoder.container(keyedBy: MovieCodingKeys.self)
        
        voteCount = movieContainer.contains(.voteCount) ? try movieContainer.decodeIfPresent(Int.self, forKey: .voteCount) : 0
        posterPath = movieContainer.contains(.posterPath) ? try movieContainer.decodeIfPresent(String.self, forKey: .posterPath) : ""
        id = movieContainer.contains(.id) ? try movieContainer.decodeIfPresent(Int.self, forKey: .id) : 0
        
        originalLanguage = movieContainer.contains(.originalLanguage) ? try movieContainer.decodeIfPresent(String.self, forKey: .originalLanguage) : ""
        
        title = movieContainer.contains(.title) ? try movieContainer.decodeIfPresent(String.self, forKey: .title) : ""
        
        overview = movieContainer.contains(.overview) ? try movieContainer.decodeIfPresent(String.self, forKey: .overview) : ""
        releaseDate = movieContainer.contains(.releaseDate) ? try movieContainer.decodeIfPresent(String.self, forKey: .releaseDate) : ""
        
      //  isFav = movieContainer.contains(.isFav) ? try movieContainer.decodeIfPresent(Bool.self, forKey: .isFav) : false
        
        do {
            isFav = try movieContainer.decodeIfPresent(Bool.self, forKey: .isFav)
        } catch DecodingError.typeMismatch {
            if let getVal = try movieContainer.decodeIfPresent(Int.self, forKey: .isFav) {
                if getVal == 1 {
                    isFav = true
                } else {
                    isFav = false
                }
            }
        }
    }
}
