//
//  Movie.swift
//  movie3
//
//  Created by Obuka on 5.4.23..
//


import Foundation

struct Movie: Identifiable, Decodable, Encodable, Hashable {
    let adult: Bool
    let id: Int
    let poster_path: String?
    let title: String
    let overview: String
    let vote_average: Float
    let backdrop_path: String?
    let release_date: String
    var runtime: Int?
    let genre_ids: [Int]? // Array of Genre objects
    var genres: [Genre]?
    var bookmarkDate: Date?
    
    
    enum CodingKeys: String, CodingKey {
        case adult
        case id
        case poster_path
        case title
        case overview
        case vote_average
        case backdrop_path
        case release_date
        case runtime
        case genre_ids
        case genres
        case bookmarkDate
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func ==(lhs: Movie, rhs: Movie) -> Bool {
        lhs.id == rhs.id
    }
    
    struct Genre: Identifiable, Decodable, Encodable {
        let id: Int
        let name: String
        
        enum CodingKeys: String, CodingKey {
            case id
            case name
        }
    }
    
    var backdropURL: URL? {
        let baseURL = URL(string: "https://image.tmdb.org/t/p/w500")
        return baseURL?.appending(path: backdrop_path ?? "")
    }
    
    var posterThumbnail: URL? {
        let baseURL = URL(string: "https://image.tmdb.org/t/p/w100")
        return baseURL?.appending(path: poster_path ?? "")
    }
    
    var poster: URL? {
        let baseURL = URL(string: "https://image.tmdb.org/t/p/w500")
        return baseURL?.appending(path: poster_path ?? "")
    }
    
    static var preview: Movie {
        return Movie(adult: false,
                     id: 23834,
                     poster_path: "https://image.tmdb.org/t/p/w300/9n2tJBplPbgR2ca05hS5CKXwP2c.jpg",
                     title: "Free Guy",
                     overview: "some demo text here",
                     vote_average: 5.5,
                     backdrop_path: "https://image.tmdb.org/t/p/w300/9n2tJBplPbgR2ca05hS5CKXwP2c.jpg",
                     release_date: "2012",
                     runtime: 100,
                     genre_ids: [1,2,3])
    }
}
