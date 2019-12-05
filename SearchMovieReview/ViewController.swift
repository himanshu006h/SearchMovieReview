//
//  ViewController.swift
//  SearchMovieReview
//
//  Created by Himanshu Saraswat on 05/12/19.
//  Copyright © 2019 Himanshu Saraswat. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
   
    //MARK:- Constants
    struct Constants {
        static let cellIdentifier = "MovieTableViewCell"
        static let cancel = "Cancel"
        static let blank = ""
    }
    
    //MARK:- Properties
    @IBOutlet weak var textFieldSearch: UITextField!
    @IBOutlet weak var movieTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var movieInformation: [Search]?
    
    //refresh Table logic
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)),
                                 for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.black
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerMovieCell()
        self.addrefreshControl()
        self.loadMovieDetails()
    }
    
    // drag table to refresh contact
    func addrefreshControl() {
        self.movieTableView.addSubview(self.refreshControl)
    }
    
    private func loadMovieDetails(pullToRefresh: Bool = false) {
        if !pullToRefresh {
            startLoadingIndicator()
        }
        // get Data from service
        let movieVModel = MovieViewModel(movieInfo: nil, movieDelegate: self)
        movieVModel.fetchMovieDetails(searchText: self.textFieldSearch.text == "" ? "home" : self.textFieldSearch.text ?? "home", pageNumber: 10)
    }
    
    func startLoadingIndicator() {
        // start activity spinner
        view.bringSubviewToFront(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    @objc func refresh(_ refreshControl: UIRefreshControl) {
        loadMovieDetails(pullToRefresh: true)
    }
    
    func updateTableView() {
        self.refreshControl.endRefreshing()
        self.activityIndicator.stopAnimating()
        self.movieTableView.isHidden = false
        self.movieTableView.reloadData()
    }
    
    func registerMovieCell() {
        self.movieTableView.register(UINib(nibName: Constants.cellIdentifier, bundle: nil), forCellReuseIdentifier: Constants.cellIdentifier)
    }
    @IBAction func onTapSearch(_ sender: Any) {
        self.loadMovieDetails()
    }
}


// MARK: Handel data from service
extension ViewController: MovieInformation {
    
    func updateMovieDetails(movieDetails: Any?, error: Error?) {
        
        if error == nil {
            guard let response = movieDetails as? MovieDetails,
                let movies = response.search else {
                    return
            }
            
            self.movieInformation = movies
            DispatchQueue.main.async{
                self.updateTableView()
            }
        } else if let erorrDiscription = error {
            DispatchQueue.main.async {
                self.updateTableView()
                let alertViewController = UIAlertController(title: Constants.blank, message: erorrDiscription.localizedDescription, preferredStyle: .alert)
                alertViewController.addAction(UIAlertAction(title: Constants.cancel, style: UIAlertAction.Style.cancel, handler: nil))
                self.present(alertViewController, animated: true, completion: nil)
            }
        }
    }
}


extension ViewController: UITableViewDataSource {
    //MARK: Table Datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movieInformation?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath) as? MovieTableViewCell,
            let details = self.movieInformation else {
                return UITableViewCell()
        }
        
        cell.configure(movieDetail: details[indexPath.row])
        return cell
    }
}

//MARK: Table Delegate
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        guard let details = self.movieInformation else {
//            return
//        }
    }
}

