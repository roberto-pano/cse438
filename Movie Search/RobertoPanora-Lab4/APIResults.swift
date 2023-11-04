//
//  APIResults.swift
//  RobertoPanora-Lab4
//
//  Created by Roberto Panora on 10/26/23.
//

import Foundation

struct APIResults: Decodable {
    let page: Int
    let total_results: Int
    let total_pages: Int
    let results: [Movie]?
}
