//
//  MovieInfoViewController.swift
//  RobertoPanora-Lab4
//
//  Created by Roberto Panora on 10/29/23.
//

import UIKit


class MovieInfoViewController: UIViewController {
    
    var image: UIImage!
    var releaseYear: String!
    var runtime: Int!
    var revenue: CGFloat!
    var budget: CGFloat!
    var favoriteButton: UIButton!
    var movie: Movie!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.gray
        
        
        
        let theImageFrame = CGRect(x: view.frame.midX - image.size.width/2, y: 120, width: image.size.width, height: image.size.height)
        let imageView = UIImageView(frame:theImageFrame)
        imageView.image = image
        view.addSubview(imageView)
        
        let releaseFrame = CGRect(x: 0, y: image.size.height + 120, width: view.frame.width, height: 30)
        let releaseView = UILabel(frame: releaseFrame)
        let releaseYear = "Released: " + releaseYear
        releaseView.text = releaseYear
        releaseView.textAlignment = .center
        
        view.addSubview(releaseView)
        print(image.size.height)
        let budgetFrame = CGRect(x: 0, y: image.size.height + 150, width: view.frame.width, height: 30)
        let budgetView = UILabel(frame: budgetFrame)
        let b = "Budget: $\(budget ?? -1)"
        budgetView.text = b
        budgetView.textAlignment = .center
        view.addSubview(budgetView)
        
        let revenueFrame = CGRect(x: 0, y: image.size.height + 180, width: view.frame.width, height: 30)
        let revenueView = UILabel(frame: revenueFrame)
        let r = "Revenue: $\(revenue ?? -1)"
        revenueView.text = r
        revenueView.textAlignment = .center
        view.addSubview(revenueView)
        
        let runtimeFrame = CGRect(x: 0, y: image.size.height + 210, width: view.frame.width, height: 30)
        let runtimeView = UILabel(frame: runtimeFrame)
        let rt = "Runtime: " + String(runtime) + " minutes"
        runtimeView.text = rt
        runtimeView.textAlignment = .center
        view.addSubview(runtimeView)
        
        
        let favoriteFrame = CGRect(x: imageView.bounds.midX - 45, y: image.size.height + 240, width: 150, height: 20)
        favoriteButton = UIButton(frame: favoriteFrame)
        favoriteButton.setTitle("Add to favorites", for: .normal)
        favoriteButton.setTitleColor(UIColor.black, for: .normal)
        favoriteButton.titleLabel!.textAlignment = .center
        favoriteButton.backgroundColor = UIColor.systemPink
        favoriteButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        view.addSubview(favoriteButton)
    }
    @objc func buttonPressed(){
        // Store favorites locally for SQLite
        let movieDB = MovieDatabase.shared
        var favorites:[String: Any] = [:]
        
        if !movieDB.isMovieInFavorites(movieID: movie.id!) {
            let imageData = image.pngData()
            let strBase64 = imageData!.base64EncodedString()
            favorites["budget"] = budget
            favorites["revenue"] = revenue
            favorites["runtime"] = runtime
            favorites["posterPath"] = strBase64
            favorites["id"] = movie.id
            favorites["title"] = movie.title
            favorites["releaseYear"] = releaseYear ?? "????"
            movieDB.insertFavorites(movie: favorites)
        }
        
    }
}
