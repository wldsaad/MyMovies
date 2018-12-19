//
//  Movie.swift
//  MyMovies
//
//  Created by Waleed Saad on 12/16/18.
//  Copyright © 2018 Waleed Saad. All rights reserved.
//

import Foundation

struct Movie {
    var id: Int?
    var vote_average: Double?
    var title: String?
    var poster_path: String?
    var backdrop_path: String?
    var overview: String?
    var release_date: String?
    var budget: Int?
    var homepage: String?
    var imdb_id: String?
    
    
    init(id: Int, vote_average: Double, title: String, poster_path: String, backdrop_path: String, overview: String, release_date: String, budget: Int, homepage: String, imdb_id: String) {
        self.id = id
        self.vote_average = vote_average
        self.title = title
        self.poster_path = poster_path
        self.backdrop_path = backdrop_path
        self.overview = overview
        self.release_date = release_date
        self.budget = budget
        self.homepage = homepage
        self.imdb_id = imdb_id
    }
    
    init() {
    }
    
}

