//
//  SQLite.swift
//  RobertoPanora-Lab4
//
//  Created by Roberto Panora on 10/30/23.
//

import SQLite
import UIKit

// Define a model for movie information
//struct Movie {
//    var id: Int64?
//    var title: String
//    var director: String
//    var releaseYear: Int
//}

class MovieDatabase {
    static let shared = MovieDatabase()
    private var db: Connection?

    private init() {
        do {
            // Set up SQLite connection
            let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            let databasePath = "\(documentsPath)/favorites.sqlite3"
            db = try Connection(databasePath)
        } catch {
            print("Error initializing database: \(error)")
        }
    }

    func tableExists(tableName: String) -> Bool {
        guard let db = db else {
            return false
        }

        let query = "SELECT name FROM sqlite_master WHERE type='table' AND name = ?"

        do {
            let statement = try db.run(query, tableName)

            return statement.makeIterator().next() != nil
        } catch {
            print("Error checking if the table exists: \(error)")
        }

        return false
    }


    func createFavoritesTable() {
        guard let db = db else {
            return
        }
        let tableName = "movies"
        if !tableExists(tableName: tableName) {
            let movies = Table(tableName)
            let id = Expression<Int64>("id")
            let title = Expression<String>("title")
            let budget = Expression<Double>("budget")
            let revenue = Expression<Double>("revenue")
            let runtime = Expression<Int>("runtime")
            let releaseYear = Expression<String>("releaseYear")
            let posterPath = Expression<String>("posterPath")

            do {
                try db.run(movies.create { table in
                    table.column(id)
                    table.column(title)
                    table.column(budget)
                    table.column(revenue)
                    table.column(runtime)
                    table.column(releaseYear)
                    table.column(posterPath)
                })
            } catch {
                print("Error creating table: \(error)")
            }
        }
        
    }

    func insertFavorites(movie: [String: Any]) {
        guard let db = db else {
            return
        }
        
        print("insert")
        
        let movieTitle = movie["title"] as! String
        let movieID = movie["id"] as! Int
        let movieReleaseYear = movie["releaseYear"] as! String
        let movieBudget = Double(movie["budget"] as! CGFloat)
        let movieRevenue = Double(movie["revenue"] as! CGFloat)
        let moviePosterPath = movie["posterPath"] as! String?
        let movieRuntime = movie["runtime"] as! Int
//        print(type(of:movieReleaseYear))
        let movies = Table("movies")
        let budget = Expression<Double>("budget")
        let revenue = Expression<Double>("revenue")
        let runtime = Expression<Int>("runtime")
        let title = Expression<String>("title")
        let id = Expression<Int>("id")
        let releaseYear = Expression<String>("releaseYear")
        let posterPath = Expression<String?>("posterPath")
      
        

        do {
            let insert = movies.insert(title <- movieTitle, id <- movieID, releaseYear <- movieReleaseYear, budget <- movieBudget, revenue <- movieRevenue, posterPath <- moviePosterPath, runtime <- movieRuntime)
            let rowId = try db.run(insert)
            print("Inserted movie with ID: \(rowId)")
        } catch {
            print("Insertion failed: \(error)")
        }
    }
    func isMovieInFavorites(movieID: Int) -> Bool {
        print("isFav")
        guard let db = db else {
            return false // Handle the case where the database is not available
        }

        let movies = Table("movies")
        let id = Expression<Int>("id")

        do {
            // Query the "favorites" table to find a row with the specified movie ID
            let matchingRows = try db.prepare(movies.filter(id == movieID))
            
            // Check if there are any matching rows
            for _ in matchingRows {
                return true // Movie is in favorites
            }
            return false // Movie is not in favorites
        } catch {
            print("Query failed: \(error)")
            return false // Handle the error as needed
        }
    }

    func getMovieTitlesFromSQLite() -> [String] {
        var movieTitles: [String] = []

        // Replace with your SQLite code to fetch data
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let databasePath = "\(documentsPath)/favorites.sqlite3"
        if let db = try? Connection(databasePath) {
            let movies = Table("movies")
            let title = Expression<String>("title")

            do {
                for movie in try db.prepare(movies) {
                    movieTitles.append(movie[title])
                }
            } catch {
                print("Error fetching data from SQLite: \(error)")
            }
        }

        return movieTitles
    }
    
    func fetchAllMovies() -> [Row] {
        let movies = Table("movies")
        do {
            // Use the Array initializer to convert the AnySequence to an array
            return Array(try db!.prepare(movies))
        } catch {
            print("Error fetching movies: \(error)")
            return []
        }
    }

    func deleteMovieAtIndex(_ indexToDelete: Int) {
        let allMovies = fetchAllMovies()
        if indexToDelete >= 0 && indexToDelete < allMovies.count {
            let movieID = allMovies[indexToDelete][Expression<Int64>("id")]
            let movies = Table("movies")
            let movieIDExpr = Expression<Int64>("id")

            do {
                try db?.run(movies.filter(movieIDExpr == movieID).delete())
                print("Row with ID \(movieID) deleted successfully")
            } catch {
                print("Error deleting row: \(error)")
            }
        }
    }

    func getMovieAtIndex(_ index: Int) -> [String: Any]? {
        let allMovies = fetchAllMovies()
        
        // Check if the index is within the valid range
        if index >= 0 && index < allMovies.count {
            let movieRow = allMovies[index]
            let id = movieRow[Expression<Int64>("id")]
            let title = movieRow[Expression<String>("title")]
            let releaseYear = movieRow[Expression<String>("releaseYear")]
            let budget = movieRow[Expression<Double>("budget")]
            let revenue = movieRow[Expression<Double>("revenue")]
            let runtime = movieRow[Expression<Int>("runtime")]
//            let releaseYear = movieRow[Expression<String>("releaseYear")]
            let posterPath = movieRow[Expression<String>("posterPath")]
            
            // Create a dictionary representing the movie
            let movie: [String: Any] = [
                "id": Int(id),
                "title": title,
                "budget": budget,
                "revenue": revenue,
                "runtime": runtime,
                "releaseYear": releaseYear,
                "posterPath": posterPath
            ]
            
            return movie
        }
        
        // Return nil if the index is out of range
        return nil
    }



}
