//
//  FavoriteMovieInfoViewController.swift
//  RobertoPanora-Lab4
//
//  Created by Roberto Panora on 10/30/23.
//

import UIKit


class FavoriteMovieInfoViewController: UIViewController {
    
    var image: UIImage!
    var releaseYear: String!
    var runtime: Int!
    var revenue: CGFloat!
    var budget: CGFloat!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.gray
        
        
        
        let theImageFrame = CGRect(x: view.frame.midX - image.size.width/2, y: 120, width: image.size.width, height: image.size.height)
        let imageView = UIImageView(frame:theImageFrame)
        imageView.image = image
        view.addSubview(imageView)
        
        let releaseFrame = CGRect(x: 0, y: image.size.height + 120, width: view.frame.width, height: 30)
        let releaseView = UILabel(frame: releaseFrame)
        let releaseYear = "Released: " + (releaseYear ?? "????")
        releaseView.text = releaseYear
        releaseView.textAlignment = .center
        
        view.addSubview(releaseView)
        
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
        
    }
}

