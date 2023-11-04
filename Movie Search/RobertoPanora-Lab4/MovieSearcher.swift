////
////  MovieSearcher.swift
////  RobertoPanora-Lab4
////
////  Created by Roberto Panora on 10/27/23.
////
//
import UIKit
import SQLite3

var imageCache: [UIImage] = []

let movieDB = MovieDatabase.shared

class MovieSearcher {
        enum Error: Swift.Error {
            case unknownAPIResponse
            case generic
        }
    
        func searchMovie(for searchTerm: String, completion: @escaping (Result<MovieSearchResults, Swift.Error>) -> Void) {
            guard let searchURL = moviesSearchURL(for: searchTerm) else {
                completion(.failure(Error.unknownAPIResponse))
                return
            }
            URLSession.shared.dataTask(with: URLRequest(url: searchURL)) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard
                    (response as? HTTPURLResponse) != nil,
                    let data = data
                else {
                    completion(.failure(Error.unknownAPIResponse))
                    return
                }
                do {
                    guard
                        let resultsDictionary = try? JSONDecoder().decode(APIResults.self, from: data)
                        
                    else {
                        completion(.failure(Error.unknownAPIResponse))
                        return
                    }
                    
                    guard
                        let movies = resultsDictionary.results as [Movie]?
                            
                    else {
                        completion(.failure(Error.unknownAPIResponse))
                        return
                    }
                    
                    let moviePosters = self.getPhotos(photoData: movies)
                    let searchResults = MovieSearchResults(searchTerm: searchTerm, searchResults: moviePosters!)
                    completion(.success(searchResults))
                }
            }
            .resume()
        }
    
        private func getPhotos(photoData: [Movie]) -> [Movie]? {
            imageCache = []
            var validMovies: [Movie] = []
            var id: Int!
            var poster_path: String?
            var title: String
            var release_date: String?
            var vote_average: Double
            var overview: String
            var vote_count: Int?
            for photoObject in photoData {
                id = photoObject.id
                poster_path = photoObject.poster_path ?? "/zslEgrYEg6EDzOYrr8EfDoQK8j1.jpg"
                title = photoObject.title
                release_date = photoObject.release_date ?? "????-??-??"
                vote_average = photoObject.vote_average
                overview = photoObject.overview
                vote_count = photoObject.vote_count ?? 0
              
                
                let moviePoster = Movie(id: id, poster_path: poster_path, title: title, release_date: release_date, vote_average: vote_average, overview: overview, vote_count: vote_count)
    
                if let url = moviePoster.movieImageURL(),
                   let imageData = try? Data(contentsOf: url as URL),
                   let image = UIImage(data: imageData) {
                    imageCache.append(image)
                    validMovies.append(moviePoster)
                }
            }
    
            return validMovies
        }
    
        
    
   
    func getAdditionalMovieInfo(for movieID: Int, movie:Movie, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        guard let searchURL = additionalMovieDetails(for: movieID) else {
            completion(.failure(Error.unknownAPIResponse))
            return
        }
        
        URLSession.shared.dataTask(with: URLRequest(url: searchURL)) { data, response, error in
            if let error = error {
                completion(.failure(error as! MovieSearcher.Error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, let data = data else {
                completion(.failure(Error.unknownAPIResponse))
                return
            }
            
            do {
                if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    // Assuming the API response is a dictionary with flexible structure
                    var movieDetails: [String: Any] = [:]
//                    var insertFavorites: [String: Any] = [:]
                    var budget: CGFloat!
                    var revenue: CGFloat!
                    var runtime: Int!
//                    var posterPath: String?
                    let movieInfo = jsonObject
                    budget = movieInfo["budget"] as? CGFloat ?? -1.0
                    revenue = movieInfo["revenue"] as? CGFloat ?? -1
                    runtime = movieInfo["runtime"] as? Int ?? -1
                    
                    
                    

//                    if posterPath == nil {
//                        posterPath = "/zslEgrYEg6EDzOYrr8EfDoQK8j1.jpg"
//                    }
                    movieDetails["budget"] = budget
                    movieDetails["revenue"] = revenue
                    movieDetails["runtime"] = runtime
                   
                    
                    
                    
//                    Get Movie Image bigger
                    if let url = movie.movieImageURL("w342"),
                        let imageData = try? Data(contentsOf: url as URL),
                        let image = UIImage(data: imageData) {
                        movieDetails["displayImage"] = image
                    }
                    completion(.success(movieDetails))

                } else {
                    completion(.failure(Error.unknownAPIResponse))
                }
            } catch {
                completion(.failure(error as! MovieSearcher.Error))
            }
        }
        .resume()
    }


        private func moviesSearchURL(for searchTerm: String) -> URL? {
            let urlString = "https://api.themoviedb.org/3/search/movie?api_key=\(apiKey)&query=\(searchTerm)&language=en-US"
            return URL(string: urlString)
        }
    
    
    private func additionalMovieDetails(for movieID: Int) -> URL? {

        let urlString = "https://api.themoviedb.org/3/movie/\(movieID)?api_key=\(apiKey)&language=en-US"
        return URL(string: urlString)
    }
    
    
    func getPopularMovies(completion: @escaping (Result<MovieSearchResults, Swift.Error>) -> Void) {
        guard let searchURL = popularMoviesURL() else {
            completion(.failure(Error.unknownAPIResponse))
            return
        }
        URLSession.shared.dataTask(with: URLRequest(url: searchURL)) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard
                (response as? HTTPURLResponse) != nil,
                let data = data
            else {
                completion(.failure(Error.unknownAPIResponse))
                return
            }
            do {
                guard
                    let resultsDictionary = try? JSONDecoder().decode(APIResults.self, from: data)
                    
                else {
                    completion(.failure(Error.unknownAPIResponse))
                    return
                }
                
                guard
                    let movies = resultsDictionary.results as [Movie]?
                        
                else {
                    completion(.failure(Error.unknownAPIResponse))
                    return
                }
                
                let moviePosters = self.getPhotos(photoData: movies)
                let searchResults = MovieSearchResults(searchTerm: "popular", searchResults: moviePosters!)
                completion(.success(searchResults))
            }
        }
        .resume()
    }
    
    
    private func popularMoviesURL() -> URL? {
        let urlString = "https://api.themoviedb.org/3/movie/popular?api_key=\(apiKey)&language=en-US&page=1"
        return URL(string: urlString)
    }
}

