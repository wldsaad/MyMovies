//
//  NowPlayingVC.swift
//  MyMovies
//
//  Created by Waleed Saad on 12/16/18.
//  Copyright © 2018 Waleed Saad. All rights reserved.
//

import UIKit

class NowPlayingVC: UIViewController {

    //OUTLETS
    @IBOutlet weak var tableView: UITableView!
    
    //VARIABLES
    private var searchDidOpen = false
    private var searchBar: UISearchBar?
    private var moviesArray = [Movie]()
    private var errorAlert: UIAlertController?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        addCloseKeyboradTapToMainView()
        if Reachability.isConnectedToNetwork(){
            fetchNowPlaying()
        } else {
            showAlertError(withTitle: "No Internet Connection", withMessageToShow: "Please turn on Wifi and retry")
        }
        
    }
    
    //GET CURRENT MOVIES ON CINEMAS
    private func fetchNowPlaying(){
        let fetch = FetchMovies()
        fetch.getNowPlayingMovies { (movies) in
            if movies.count > 0 {
                DispatchQueue.main.async {
                    self.moviesArray = movies
                    self.tableView.reloadData()
                    self.navigationItem.title = "Now Playing..."
                }
            }
        }
    }
    
    //OPEN SEARCH BAR
    @IBAction func openSearch(_ sender: Any) {
        if !searchDidOpen {
            searchBar = UISearchBar()
            searchBar?.delegate = self
            searchBar?.sizeToFit()
            searchBar?.placeholder = "Movie search..."
            self.navigationController?.navigationBar.topItem?.titleView = searchBar
            searchBar?.becomeFirstResponder()
            searchDidOpen = true
        } else {
            dismissSearchBar()
        }
    }
    
    //DISSMISS SEARCH BAR
    private func addCloseKeyboradTapToMainView(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissSearchBar))
        self.navigationController?.navigationBar.addGestureRecognizer(tapGesture)
    }

    @objc private func dismissSearchBar(){
        self.navigationController?.navigationBar.topItem?.titleView = nil
        searchBar?.endEditing(true)
        searchDidOpen = false
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
            fetchNowPlaying()
        } else {
            errorAlert?.dismiss(animated: true, completion: nil)
            showAlertError(withTitle: "No Internet Connection", withMessageToShow: "Please turn on Wifi and retry")
        }
    }
    
}

//EXTNESIONS
//TABLEVIEW DATASOURCE
extension NowPlayingVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "nowPlayingCell", for: indexPath) as? NowPlayingCell {
            let movie = moviesArray[indexPath.row]
            cell.updateMovie(movie: movie)
            cell.selectionStyle = .none
            return cell
        }
        return NowPlayingCell()
    }
}

//TABLEVIEW DELEGATE
extension NowPlayingVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if Reachability.isConnectedToNetwork(){
            errorAlert?.dismiss(animated: true, completion: nil)
            if moviesArray.count > 0 {
                let selectedMovie = moviesArray[indexPath.row]
                if selectedMovie.title != nil {
                    performSegue(withIdentifier: "movieSequeFromNowPlaying", sender: selectedMovie)
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

//SEARCH BAR DELEGATE
extension NowPlayingVC: UISearchBarDelegate {
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        dismissSearchBar()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        dismissSearchBar()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchedText = searchBar.text {
            if searchedText.count > 0 {
                dismissSearchBar()
                if Reachability.isConnectedToNetwork(){
                    errorAlert?.dismiss(animated: true, completion: nil)
                    searchMovie(text: searchedText)
                    self.addReturnNowPlayingButton()
                } else {
                    errorAlert?.dismiss(animated: true, completion: nil)
                    showAlertError(withTitle: "No Internet Connection", withMessageToShow: "Please turn on Wifi and retry")
                }
                
            }
        }
    }
    
    //GET SEARCHED MOVIE
    private func searchMovie(text: String) {
        FetchMovies().searchMovie(withText: text) { (moviesArray) in
            if moviesArray.count > 0 {
                DispatchQueue.main.async {
                    self.moviesArray = moviesArray
                    self.tableView.reloadData()
                    self.navigationItem.title = "Serach Results for \(text)"
                }
            }
        }
    }
    
    //ADD RETURN TO CURRENT MOVIES ON CINEMAS BUTTON
    private func addReturnNowPlayingButton(){
        let returnButton = UIBarButtonItem()
        returnButton.title = "Show Now Playing Movies"
        returnButton.style = .done
        returnButton.action = #selector(reloadNowPlaying)
        returnButton.target = self
        self.navigationItem.leftBarButtonItem = returnButton
        
    }
    
    @objc private func reloadNowPlaying() {
        if Reachability.isConnectedToNetwork(){
            errorAlert?.dismiss(animated: true, completion: nil)
            fetchNowPlaying()
            self.navigationItem.leftBarButtonItem = nil
        } else {
            errorAlert?.dismiss(animated: true, completion: nil)
            showAlertError(withTitle: "No Internet Connection", withMessageToShow: "Please turn on Wifi and retry")
        }
    }

}
