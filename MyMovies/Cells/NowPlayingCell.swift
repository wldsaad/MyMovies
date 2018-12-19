//
//  NowPlayingCell.swift
//  MyMovies
//
//  Created by Waleed Saad on 12/16/18.
//  Copyright © 2018 Waleed Saad. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class NowPlayingCell: UITableViewCell {

    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieLabel: UILabel!
    @IBOutlet weak var movieProgBar: UIProgressView!
    @IBOutlet weak var voteLabel: UILabel!
    
    func updateMovie(movie: Movie){
        if let title = movie.title {
            movieLabel.text = title
        }
        if let vote = movie.vote_average {
            movieProgBar.progress = Float(vote / 10)
            voteLabel.text = String(format: "%.1f", vote)
        }
        if let imgURL = movie.backdrop_path {
            let imageURL = "https://image.tmdb.org/t/p/w500\(imgURL)"
            Alamofire.request(imageURL, method: .get)
                .validate()
                .responseData(completionHandler: { (responseData) in
                    if let image = responseData.data {
                        self.movieImage.image = UIImage(data: image)
                    }
                })
        }

    }
    
}
