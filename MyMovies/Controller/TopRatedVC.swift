//
//  ComingSoonVC.swift
//  MyMovies
//
//  Created by Waleed Saad on 12/18/18.
//  Copyright © 2018 Waleed Saad. All rights reserved.
//

import UIKit

class TopRatedVC: UIViewController {

    //OUTLETS
    @IBOutlet weak var tableView: UITableView!
    
    //VARIABLES
    private var moviesArray = [Movie]()
    private var errorAlert: UIAlertController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if Reachability.isConnectedToNetwork(){
            fetchTopRatedMovies()
        } else {
            showAlertError(withTitle: "No Internet Connection", withMessageToShow: "Please turn on Wifi and retry")
        }
        
    }
    
    //FETCH TOP RATED MOVIES
    private func fetchTopRatedMovies(){
        FetchMovies().getTopRatedMovies { (movies) in
            if movies.count > 0 {
                DispatchQueue.main.async {
                    self.moviesArray = movies
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    //Alert error dialog
    private func showAlertError(withTitle title: String, withMessageToShow message: String){
        errorAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let retryAction = UIAlertAction(title: "RETRY", style: .default) { (UIAlertAction) in
            self.errorAlertBackgroundTapped()
        }
        errorAlert?.addAction(retryAction)
//        present(errorAlert, animated: true, completion: nil)
        present(errorAlert!, animated: true) {
            // Enabling Interaction for Transperent Full Screen Overlay
            self.errorAlert?.view.superview?.subviews.first?.isUserInteractionEnabled = true

            // Adding Tap Gesture to Overlay
            self.errorAlert?.view.superview?.subviews.first?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.errorAlertBackgroundTapped)))
        }
    }
    
    @objc func errorAlertBackgroundTapped() {
        if Reachability.isConnectedToNetwork() {
            errorAlert?.dismiss(animated: true, completion: nil)
            fetchTopRatedMovies()
        } else {
            errorAlert?.dismiss(animated: true, completion: nil)
            showAlertError(withTitle: "No Internet Connection", withMessageToShow: "Please turn on Wifi and retry")
        }
    }
    

}

//EXTENSIONS
//TABLE VIEW DATASOURCE
extension TopRatedVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "topRatedcell", for: indexPath) as? TopRatedCell {
            let currentMovie = moviesArray[indexPath.row]
            cell.updateMovie(movie: currentMovie)
            cell.selectionStyle = .none
            return cell
        }
        return TopRatedCell()
    }
}

//TABLE VIEW DELEGATE
extension TopRatedVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if Reachability.isConnectedToNetwork(){
            errorAlert?.dismiss(animated: true, completion: nil)
            if moviesArray.count > 0 {
                let selectedMovie = moviesArray[indexPath.row]
                if selectedMovie.title != nil {
                    performSegue(withIdentifier: "movieSequeFromTopRated", sender: selectedMovie)
                }
            }
        } else {
            errorAlert?.dismiss(animated: true, completion: nil)
            showAlertError(withTitle: "No Internet Connection", withMessageToShow: "Please turn on Wifi and retry")
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let movieVC = segue.destination as? MovieVC {
            movieVC.updateID(movie: sender as! Movie)
        }
    }
}
