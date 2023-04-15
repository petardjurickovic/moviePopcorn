//
//  TrendingResults.swift
//  movie3
//
//  Created by Obuka on 5.4.23..
//

import Foundation
struct Results: Decodable {
    let page: Int
    let results: [Movie]
    let total_pages: Int
    let total_results: Int
}
