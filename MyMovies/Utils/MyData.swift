//
//  MyData.swift
//  MyMovies
//
//  Created by Waleed Saad on 12/16/18.
//  Copyright © 2018 Waleed Saad. All rights reserved.
//

import Foundation

class MyData {
    
    public static let API_KEY = "0dc10071306ea9f2cc725427fb124f8a"
    public static let BASE_URL_NOW_PLAYING = "https://api.themoviedb.org/3/movie/now_playing?api_key=\(API_KEY)&language=en-US"
    
    func getMovieURL(id: Int) -> String {
        let movieURL = "https://api.themoviedb.org/3/movie/\(String(id))?api_key=\(MyData.API_KEY)&language=en-US"
        return movieURL
    }
    
    func getSearchMovieURL(withTextToSearch text: String) -> String {
        let searchURL = "https://api.themoviedb.org/3/search/movie?api_key=\(MyData.API_KEY)&language=en-US&query=\(text.replacingOccurrences(of: " ", with: "%20"))&page=1&include_adult=false"
        return searchURL
    }
    
    public static let TOP_RATED_URL_MOVIES = "https://api.themoviedb.org/3/movie/top_rated?api_key=\(MyData.API_KEY)&language=en-US&page=1"
    
    
}
