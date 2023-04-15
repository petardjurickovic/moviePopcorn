//
//  MovieDetailsViewModel.swift
//  movie3
//
//  Created by Obuka on 5.4.23..
//

import Foundation
import SwiftUI

@MainActor
class MovieDetailsViewModel: ObservableObject {

    @Published var credits: MovieCredits?
    @Published var cast: [MovieCredits.Cast] = []
    @Published var castProfiles: [CastProfile] = []
    
    @Published var reviews: [MovieReview] = []
    


    
    func loadReviews(for movieID: Int) async {
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(movieID)/reviews?api_key=\(MovieDiscoverViewModel.apiKey)&language=en-US")!
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let reviews = try JSONDecoder().decode(MovieReviews.self, from: data)
            print(url)
            self.reviews = reviews.results
        } catch {
            print(error.localizedDescription)
        }
    }



    func movieCredits(for movieID: Int) async {
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(movieID)/credits?api_key=\(MovieDiscoverViewModel.apiKey)&language=en-US")!
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let credits = try JSONDecoder().decode(MovieCredits.self, from: data)
            self.credits = credits
            self.cast = credits.cast.sorted(by: { $0.order < $1.order })
        } catch {
            print(error.localizedDescription)
        }
    }
    



    func loadCastProfiles() async {
        do {
            for member in cast {
                let url = URL(string: "https://api.themoviedb.org/3/person/\(member.id)?api_key=\(MovieDiscoverViewModel.apiKey)&language=en-US")!
                let (data, _) = try await URLSession.shared.data(from: url)
                let profile = try JSONDecoder().decode(CastProfile.self, from: data)
                castProfiles.append(profile)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct CastProfile: Decodable, Identifiable, Hashable {

    let birthday: String?
    let id: Int
    let name: String
    let profile_path: String?

    var photoUrl: URL? {
        let baseURL = URL(string: "https://image.tmdb.org/t/p/w200")
        return baseURL?.appending(path: profile_path ?? "")
    }
}


struct MovieCredits: Decodable {

    let id: Int
    let cast: [Cast]

    struct Cast: Decodable, Identifiable {
        let name: String
        let id: Int
        let character: String
        let order: Int
    }
}

struct MovieReview: Decodable, Identifiable {
    let id: String
    let author: String
    let content: String
    let url: URL
    let author_details: AuthorDetails
    let author_rating: Double?

    struct AuthorDetails: Decodable {
        let name: String
        let username: String?
        let avatar_path: String?
        let rating: Double?
        
    
    }

    var reviewerPhotoURL: URL? {
        guard let path = author_details.avatar_path else { return nil }
        let baseURL = URL(string: "https://image.tmdb.org/t/p/w200")
        return baseURL?.appendingPathComponent(path)
    }

    var reviewerRating: Double? {
        return author_details.rating ?? author_rating
    }
}

struct MovieReviews: Decodable {
    let results: [MovieReview]
}
