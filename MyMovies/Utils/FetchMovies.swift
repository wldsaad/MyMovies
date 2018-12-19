//
//  FetchMovies.swift
//  MyMovies
//
//  Created by Waleed Saad on 12/16/18.
//  Copyright © 2018 Waleed Saad. All rights reserved.
//

import Foundation
import Alamofire

class FetchMovies {
    
    func getNowPlayingMovies(completion: @escaping ([Movie]) -> Void){
        let url: String = MyData.BASE_URL_NOW_PLAYING
        let requestURL = URL(string: url)
        Alamofire.request(requestURL!).responseJSON { (response) in
            if let response = response.result.value as? [String:Any] {
                if let movies = response["results"] as? [[String:Any]] {
                    if movies.count > 0 {
                        var moviesArray = [Movie]()
                        var movieObject = Movie()
                        for movie in movies {
                            if let id = movie["id"] as? Int {
                                movieObject.id = id
                            }
                            if let vote_average = movie["vote_average"] as? Double {
                                movieObject.vote_average = vote_average
                            }
                            if let title = movie["title"] as? String {
                                movieObject.title = title
                            }
                            if let backdrop_path = movie["backdrop_path"] as? String {
                                movieObject.backdrop_path = backdrop_path
                            }
                            moviesArray.append(movieObject)
                        }
                        completion(moviesArray)
                    } else {
                        completion([Movie]())
                    }
                }
            }
        }
    }
    
    func getMovie(id: Int, completion: @escaping (Movie) -> Void){
        let url = MyData().getMovieURL(id: id)
        Alamofire.request(url).responseJSON { (response) in
            if let movie = response.result.value as? [String:Any] {
                var movieObject = Movie()
                if let vote_average = movie["vote_average"] as? Double {
                    movieObject.vote_average = vote_average
                }
                if let title = movie["title"] as? String {
                    movieObject.title = title
                }
                if let poster_path = movie["poster_path"] as? String {
                    movieObject.poster_path = poster_path
                }
                if let overview = movie["overview"] as? String {
                    movieObject.overview = overview
                }
                if let release_date = movie["release_date"] as? String {
                    movieObject.release_date = release_date
                }
                if let budget = movie["budget"] as? Int {
                    movieObject.budget = budget
                }
                if let homepage = movie["homepage"] as? String {
                    movieObject.homepage = homepage
                }
                if let imdb_id = movie["imdb_id"] as? String {
                    movieObject.imdb_id = imdb_id
                }
                completion(movieObject)
            } else {
                completion(Movie())
            }
        }
    }
    
    func searchMovie(withText text: String, completion: @escaping ([Movie]) -> Void) {
        let urlString = MyData().getSearchMovieURL(withTextToSearch: text)
        if let url = URL(string: urlString) {
            Alamofire.request(url).responseJSON { (response) in
                if let response = response.result.value as? [String:Any] {
                    if let movies = response["results"] as? [[String:Any]] {
                        if movies.count > 0 {
                            var moviesArray = [Movie]()
                            var movieObject = Movie()
                            for movie in movies {
                                if let id = movie["id"] as? Int {
                                    movieObject.id = id
                                }
                                if let vote_average = movie["vote_average"] as? Double {
                                    movieObject.vote_average = vote_average
                                }
                                if let title = movie["title"] as? String {
                                    movieObject.title = title
                                }
                                if let backdrop_path = movie["backdrop_path"] as? String {
                                    movieObject.backdrop_path = backdrop_path
                                }
                                moviesArray.append(movieObject)
                            }
                            completion(moviesArray)
                        } else {
                            completion([Movie]())
                        }
                    }
                }
            }
        }
        
    }
    
    func getTopRatedMovies(completion: @escaping ([Movie]) -> Void ){
        if let url = URL(string: MyData.TOP_RATED_URL_MOVIES) {
            Alamofire.request(url).responseJSON { (response) in
                if let response = response.result.value as? [String:Any] {
                    if let movies = response["results"] as? [[String:Any]] {
                        if movies.count > 0 {
                            var moviesArray = [Movie]()
                            var movieObject = Movie()
                            for movie in movies {
                                if let id = movie["id"] as? Int {
                                    movieObject.id = id
                                }
                                if let title = movie["title"] as? String {
                                    movieObject.title = title
                                }
                                if let vote_average = movie["vote_average"] as? Double {
                                    movieObject.vote_average = vote_average
                                }
                                if let image = movie["backdrop_path"] as? String {
                                    movieObject.backdrop_path = image
                                }
                                moviesArray.append(movieObject)
                            }
                            completion(moviesArray)
                        } else {
                            completion([Movie]())
                        }
                    }
                }
            }
        }
    }
}
