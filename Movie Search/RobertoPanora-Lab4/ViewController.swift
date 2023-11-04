//
//  ViewController.swift
//  RobertoPanora-Lab4
//
//  Created by Roberto Panora on 10/24/23.
//

import UIKit
import Network

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var favoriteMovies: UITableView!
    private var reuseableIdentifier = "favoriteCell"
    private var isOnline = false
    override func viewDidLoad() {
        super.viewDidLoad()
        favoriteMovies.allowsMultipleSelectionDuringEditing = false
        favoriteMovies.setEditing(false, animated: false)


        favoriteMovies.delegate = self
        favoriteMovies.dataSource = self
        
    }

   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        favoriteMovies.reloadData()
        
        checkNetworkConnectivity()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let movieDB = MovieDatabase.shared
        let movieTitles = movieDB.getMovieTitlesFromSQLite()
        return movieTitles.count // Replace with the actual count from SQLite
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Not connected to the internet
        let movieDB = MovieDatabase.shared
        let movieTitles = movieDB.getMovieTitlesFromSQLite()
        let currentTitle = movieTitles[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseableIdentifier, for: indexPath) as! FavoriteMovieCell
        cell.movieTitle.text = currentTitle
        cell.isUserInteractionEnabled = true

        return cell
        
    }

    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let movieDB = MovieDatabase.shared
            tableView.beginUpdates()
            movieDB.deleteMovieAtIndex(indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movieDB = MovieDatabase.shared
        let movieInfoVC = FavoriteMovieInfoViewController()
        let selectedMovie = movieDB.getMovieAtIndex(indexPath.row)
        if let base64String = selectedMovie?["posterPath"] as? String {
            if let imageData = Data(base64Encoded: base64String, options: .ignoreUnknownCharacters) {
                let image = UIImage(data: imageData)
                movieInfoVC.image = image
            }
        }

       
        movieInfoVC.revenue = CGFloat((selectedMovie!["revenue"] as? Double)!)
        movieInfoVC.budget = CGFloat((selectedMovie!["budget"] as? Double)!)
        movieInfoVC.runtime = selectedMovie!["runtime"] as? Int
        movieInfoVC.releaseYear = (selectedMovie!["releaseYear"] as! String)

        navigationController?.pushViewController(movieInfoVC, animated: true)
    }
    
    func checkNetworkConnectivity() {
        let monitor = NWPathMonitor()
        let queue = DispatchQueue(label: "NetworkMonitor")

        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                self.isOnline = false
            } else {
                self.isOnline = false
            }
            DispatchQueue.main.async {
                self.favoriteMovies.reloadData()
            }
        }

        monitor.start(queue: queue)
    }

}
