//
//  MoviePhotosViewController.swift
//  RobertoPanora-Lab4
//
//  Created by Roberto Panora on 10/27/23.
//
import Foundation
import UIKit

let apiKey = "5c8d089dcc90365f25374f1ec637c4ee"

final class MoviePhotoViewController:
    UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
//    @IBOutlet weak var load_spin: ActivityIndicator!
    
    @IBOutlet var movieDisplay: UICollectionView!
    
    private let reuseIdentifier = "movieCell"
    
    private let movies = MovieSearcher()
    
    private let sectionInsets = UIEdgeInsets(
      top: 50.0,
      left: 20.0,
      bottom: 50.0,
      right: 20.0)
    
    private let itemsPerRow: CGFloat = 3
    
    private var searchData: [MovieSearchResults] = []
    
//    var imageCache: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        print("here")
        movieDisplay.delegate = self
        movieDisplay.dataSource = self
        movieDisplay.allowsMultipleSelection = true
//        movieDisplay.reloadData()
        movieDisplay.isUserInteractionEnabled = true
        getPopularMovies()
    }
    
    
    func getPopularMovies() {
        let loadIcon = UIActivityIndicatorView(style: .medium)
        self.view.addSubview(loadIcon)
        loadIcon.frame = self.view.bounds
        loadIcon.startAnimating()
        movies.getPopularMovies { searchResults in
          DispatchQueue.main.async {
            loadIcon.removeFromSuperview()
             
            switch searchResults {
            case .failure(let error) :
              // 2
              print("Error Searching: \(error)")
            case .success(let results):
              // 3
//              print("""
//                Found \(results.searchResults.count) \
//                matching \(results.searchTerm)
//                """)
              self.searchData.insert(results, at: 0)
              // 4
              self.movieDisplay.reloadData()
            }
          }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           view.bringSubviewToFront(movieDisplay)
       }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}



private extension MoviePhotoViewController {
    func photo(for indexPath: IndexPath) -> Movie {
      return searchData[indexPath.section].searchResults[indexPath.row]
    }
}


extension MoviePhotoViewController: UITextFieldDelegate, UICollectionViewDelegateFlowLayout {
    
    // Define a loading indicator property
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        imageCache = []
        // Show the loading indicator
        guard let text = textField.text, !text.isEmpty else {
            // Hide the loading indicator and return if the text is empty
            return true
        }
        
        let loadIcon = UIActivityIndicatorView(style: .medium)
        textField.addSubview(loadIcon)
        loadIcon.frame = textField.bounds
        loadIcon.startAnimating()
        
        
        let encodedText: String = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        movies.searchMovie(for: encodedText) { searchResults in
          DispatchQueue.main.async {
            loadIcon.removeFromSuperview()
             
            switch searchResults {
            case .failure(let error) :
              // 2
              print("Error Searching: \(error)")
            case .success(let results):
              // 3
//              print("""
//                Found \(results.searchResults.count) \
//                matching \(results.searchTerm)
//                """)
              self.searchData.insert(results, at: 0)
              // 4
              self.movieDisplay.reloadData()
            }
          }
        }
        
        textField.text = nil
        textField.resignFirstResponder()
        
        return true
    }
    
    
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return searchData.isEmpty ? 0 : 1
     }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movieInfoVC = MovieInfoViewController()
//        print("HERE BITCHES")
        // Get selected movie
        let selectedMovie = searchData.first?.searchResults[indexPath.row]
        
        // Get Release Year
        let release: String = (selectedMovie?.release_date) ?? "????-??-??"
        var releaseY: String
//        print(release)
        if release != "" {
            let index = release.index(release.startIndex, offsetBy: 4)
            releaseY = String((release.prefix(upTo: index)))
        }
        else {
            releaseY = "????"
        }
        movieInfoVC.releaseYear = releaseY
      
        
//        Get Additional Details
        let loadIcon = UIActivityIndicatorView(style: .medium)
        collectionView.addSubview(loadIcon)
        loadIcon.frame = collectionView.bounds
        loadIcon.startAnimating()
//
        movies.getAdditionalMovieInfo(for: (selectedMovie?.id)!, movie: selectedMovie!){ searchResults in
          DispatchQueue.main.async {
            loadIcon.removeFromSuperview()
            switch searchResults {
            case .failure(let error) :
              // 2
              print("Error Searching: \(error)")
            case .success(let results):
              // 3
//              print("""
//                Found \(results.count) \
//                matching \(results.keys)
//                """)
              // 4
//               print("here")

                movieInfoVC.image = results["displayImage"] as? UIImage
                movieInfoVC.revenue = (results["revenue"] as? CGFloat)!
                movieInfoVC.budget = (results["budget"] as? CGFloat)!
                movieInfoVC.runtime = results["runtime"] as? Int
                movieInfoVC.movie = selectedMovie
                self.navigationController?.pushViewController(movieInfoVC, animated: true)
//
            }
          }
        }

        
    }
    
   
    func collectionView(
       _ collectionView: UICollectionView,
       numberOfItemsInSection section: Int
     ) -> Int {

         return searchData.first?.searchResults.count ?? 0
     }
    
    func collectionView(
      _ collectionView: UICollectionView,
      cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
      // 1
      let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: reuseIdentifier,
        for: indexPath
      ) as! MoviePhotoCellCollectionViewCell
      // 2
        if (searchData.first?.searchResults[indexPath.row].poster_path) != nil && imageCache.count > 0{
//            print("New Cell: \(indexPath)")
//            print(imageCache.count)
       
            let image = imageCache[indexPath.row]
            let title = searchData.first?.searchResults[indexPath.row].title
          

        
            cell.backgroundColor = .white
            cell.imageView.image = image
            
          // 3
            let newHeight: CGFloat = 40.0

            // Remove any existing height constraint
            cell.movieTitle.removeConstraints(cell.movieTitle.constraints.filter { $0.firstAttribute == .height })

            // Add a new height constraint
            let newHeightConstraint = NSLayoutConstraint(item: cell.movieTitle!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: newHeight)
            cell.movieTitle.addConstraint(newHeightConstraint)
            
            // Assuming you have a reference to the `movieTitle` view
            let newWidth: CGFloat = cell.bounds.width - 12

            // Remove any existing width constraint
            cell.movieTitle.removeConstraints(cell.movieTitle.constraints.filter { $0.firstAttribute == .width })

            // Add a new width constraint
            let newWidthConstraint = NSLayoutConstraint(item: cell.movieTitle!, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: newWidth)
            cell.movieTitle.addConstraint(newWidthConstraint)
          

            cell.movieTitle.text = title
            cell.movieTitle.textColor = .white
            cell.movieTitle.backgroundColor = .lightGray
            cell.movieTitle.alpha = 0.90
            cell.movieTitle.numberOfLines = 2 // Allow multiple lines
            cell.movieTitle.font = UIFont.systemFont(ofSize: 10)
            cell.movieTitle.lineBreakMode = .byTruncatingTail
            cell.movieTitle.textAlignment = .center
        
        }
        
        
      return cell
    }
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let favorite = UIAction(title: "Favorite",
                    image: UIImage(systemName: "star"),
                    identifier: nil,
                    discoverabilityTitle: nil,
                                state: .off){ [weak self] _ in
                let movie = self!.searchData.first?.searchResults[indexPaths[0].row]
                let loadIcon = UIActivityIndicatorView(style: .medium)
                collectionView.addSubview(loadIcon)
                loadIcon.frame = collectionView.bounds
                loadIcon.startAnimating()
        //
                self!.movies.getAdditionalMovieInfo(for: (movie?.id)!, movie: movie!){ searchResults in
                  DispatchQueue.main.async {
                    loadIcon.removeFromSuperview()
                    switch searchResults {
                    case .failure(let error) :
                      // 2
                      print("Error Searching: \(error)")
                    case .success(let results):
                      // 3
        //              print("""
        //                Found \(results.count) \
        //                matching \(results.keys)
        //                """)
                      // 4
        //
                    var favorites:[String: Any] = [:]
                        if !movieDB.isMovieInFavorites(movieID: (movie?.id!)!) {
                            let imageData = (results["displayImage"] as! UIImage).pngData()
                        let strBase64 = imageData!.base64EncodedString()
                        favorites["budget"] = results["budget"]
                        favorites["revenue"] = results["revenue"]
                        favorites["runtime"] = results["runtime"]
                        favorites["posterPath"] = strBase64
                            favorites["id"] = movie?.id
                            favorites["title"] = movie?.title
                        favorites["releaseYear"] = movie?.release_date
                        movieDB.insertFavorites(movie: favorites)
                    }
                        
                       
        //
                    }
                  }
                }
            }
            return UIMenu(
                title: "Actions",
                image: nil,
            identifier: nil,
                options: UIMenu.Options.displayInline,
                children: [favorite])
        }
        return config
    }
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
      ) -> CGSize {
        // 2
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
      }
      
      // 3
      func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
      ) -> UIEdgeInsets {
        return sectionInsets
      }
      
      // 4
      func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
      ) -> CGFloat {
        return sectionInsets.left
      }
}

