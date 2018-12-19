//
//  ComingSoonCell.swift
//  MyMovies
//
//  Created by Waleed Saad on 12/18/18.
//  Copyright © 2018 Waleed Saad. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class TopRatedCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var voteProgBar: UIProgressView!
    @IBOutlet weak var voteLabel: UILabel!
    
    func updateMovie(movie: Movie) {
        
        if let title = movie.title {
            titleLabel.text = title
        }
        if let vote = movie.vote_average {
            voteProgBar.progress = Float(vote / 10)
            voteLabel.text = String(format: "%.1f", vote)
        }
        if let imgURL = movie.backdrop_path {
            if let imageURL = URL(string: "https://image.tmdb.org/t/p/w500\(imgURL)"){
                Alamofire.request(imageURL, method: .get)
                    .validate()
                .responseData(completionHandler: { (responseData) in
                    if let imageData = responseData.data {
                        self.movieImageView.image = UIImage(data: imageData)
                    }
                    
                })
            }
        }
    }
}
