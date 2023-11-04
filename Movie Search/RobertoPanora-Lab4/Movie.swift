//
//  Movie.swift
//  RobertoPanora-Lab4
//
//  Created by Roberto Panora on 10/26/23.
//

import Foundation
import UIKit

struct Movie: Decodable {
    let id: Int?
    let poster_path: String?
    let title: String
    let release_date: String?
    let vote_average: Double
    let overview: String
    let vote_count: Int?
    
    
    
    


    init (id: Int!, poster_path: String?, title: String, release_date: String?, vote_average: Double, overview: String, vote_count: Int!) {
        self.id = id
        self.poster_path = poster_path
        self.title = title
        self.release_date = release_date
        self.vote_average = vote_average
        self.overview = overview
        self.vote_count = vote_count
        
    }

    func movieImageURL(_ size: String = "w92") -> URL? {
        if let posterPath = poster_path, let imageURL = URL(string: "https://image.tmdb.org/t/p/\(size)/\(posterPath)") {
            return imageURL;
        }
        else{
            let imageURL = URL(string: "https://image.tmdb.org/t/p/\(size)/zslEgrYEg6EDzOYrr8EfDoQK8j1.jpg")
            return imageURL
        }
//      return nil
    }

    enum Error: Swift.Error {
      case invalidURL
      case noData
    }

//    mutating func loadLargeImage(_ completion: @escaping (Result<Movie, Swift.Error>) -> Void) {
//      guard let loadURL = movieImageURL("w185") else {
//        DispatchQueue.main.async {
//          completion(.failure(Error.invalidURL))
//        }
//        return
//      }
//
//      let loadRequest = URLRequest(url: loadURL)
//
//        URLSession.shared.dataTask(with: loadRequest) { data, _, error in
//          DispatchQueue.main.async {
//            if let error = error {
//              completion(.failure(error))
//              return
//            }
//
//            guard let data = data else {
//              completion(.failure(Error.noData))
//              return
//            }
//
//            let returnedImage = UIImage(data: data)
//            self.clicked_image = returnedImage
//            completion(.success(self))
//          }
//        }
//        .resume()
//
//    }

//    func sizeToFillWidth(of size: CGSize) -> CGSize {
//      guard let thumbnail = thumbnail else {
//        return size
//      }
//
//      let imageSize = thumbnail.size
//      var returnSize = size
//
//      let aspectRatio = imageSize.width / imageSize.height
//
//      returnSize.height = returnSize.width / aspectRatio
//
//      if returnSize.height > size.height {
//        returnSize.height = size.height
//        returnSize.width = size.height * aspectRatio
//      }
//
//      return returnSize
//    }

    static func == (lhs: Movie, rhs: Movie) -> Bool {
      return lhs.id == rhs.id
    }
}
