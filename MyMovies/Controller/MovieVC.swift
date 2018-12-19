//
//  MovieVC.swift
//  MyMovies
//
//  Created by Waleed Saad on 12/17/18.
//  Copyright © 2018 Waleed Saad. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class MovieVC: UIViewController {

    
    //OUTLETS
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewTextView: UITextView!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var budgetLabel: UILabel!
    @IBOutlet weak var progBarView: UIProgressView!
    @IBOutlet weak var voteScoreLabel: UILabel!
    
    //VARIABLES
    private var id: Int?
    private var imageURL: String?
    private var IMDBLink: String?
    private var movie = Movie()
    private var barTitle: String?
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = barTitle
    }
    
    //UPDTATE THE MOVIE FROM PREVIOUS VIEW
    func updateID(movie: Movie){
        if let fetchedID = movie.id {
            self.id = fetchedID
            updateBarTitle(movie: movie)
            fetchMovie(withID: fetchedID)
        }
    }
    
    //CHANGE THE NAV BAR TITLE
    private func updateBarTitle(movie: Movie) {
        barTitle = movie.title
    }
    
    //GET MOVIE BY ID
    private func fetchMovie(withID id: Int){
        FetchMovies().getMovie(id: id) { (fetchedMovie) in
            DispatchQueue.main.async {
                self.movie = fetchedMovie
                self.updateView(movie: self.movie)
            }
        }
    }
    
    //UPDATE THE VIEWS
    private func updateView(movie: Movie){
        if let title = movie.title {
            titleLabel.text = title
        }
        if let overviewText = movie.overview {
            overviewTextView.text = overviewText
        }
        if let releaseDate = movie.release_date {
            releaseDateLabel.text = releaseDate
        }
        if let budget = movie.budget {
            budgetLabel.text = "$\(budget)M"
        }
        if let vote = movie.vote_average {
            progBarView.progress = Float((vote) / 10)
            voteScoreLabel.text = String(format: "%.1f", vote)
        }
        if let imgURL = movie.poster_path {
            imageURL = "https://image.tmdb.org/t/p/w500\(imgURL)"
            updateImage(imageURL: imageURL!)
        }
        if let imdbLink = movie.imdb_id {
            updateIMDBLink(imdb: imdbLink)
        }
    }
    
    //UPDATE THE POSTER
    private func updateImage(imageURL: String) {
        Alamofire.request(imageURL, method: .get).validate().responseData(completionHandler: { (responseData) in
            if let imageData = responseData.data {
                self.posterView.image = UIImage(data: imageData)
            }
        })
    }
    
    //UPDATE IMDB LINK
    private func updateIMDBLink(imdb: String){
        IMDBLink = "https://www.imdb.com/title/\(imdb)"
    }
    
    //IMDB OPEN WEB ACTION
    @IBAction func imdbAction(_ sender: UIButton) {
        if let url = IMDBLink {
            let movieURL = URL(string: url)
            UIApplication.shared.open(movieURL!, options: [:], completionHandler: nil)
        }
        
    }
    
}
