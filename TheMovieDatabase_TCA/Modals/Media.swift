//
//  Movie.swift
//  TheMovieDatabase_TCA
//
//  Created by Koushik Dutta on 04/04/24.
//

import Foundation
import ComposableArchitecture

// MARK: - ResponseData
struct ResponseData: Decodable {
    let results: IdentifiedArrayOf<Media>
}

// MARK: - Movie
struct Media: Codable, Hashable, Identifiable {
    let adult: Bool
    let backdropPath: String?
    let id: Int
    let overview: String
    let popularity: Double
    let posterPath: String?
    let releaseDate: String?
    let firstAirDate: String?
    let title: String?
    let name: String?
    let voteAverage: Double
    let voteCount: Int
    let tagline: String?
    
    var titleText: String? {
        title ?? name
    }
    
    var dateText: String? {
        releaseDate ?? firstAirDate
    }
    
    var posterFullPath: URL? {
        guard let posterPath else { return nil }
        return URL(string: Routes.completeImageURLString(posterPath).path)
    }
    
    var backdropFullPath: URL? {
        guard let backdropPath else { return nil }
        return URL(string: Routes.completeImageURLString(backdropPath).path)
    }
    
    var votingPercentage: String {
        return String(Int(voteAverage * 10)) + "%"
    }
    
    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case id
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case firstAirDate = "first_air_date"
        case title
        case name
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case tagline
    }
}

extension Media {
    static let mock = Self(adult: true, backdropPath: "/kXfqcdQKsToO0OUXHcrrNCHDBzO.jpg", id: 278, overview: "Framed in the 1940s for the double murder of his wife and her lover, upstanding banker Andy Dufresne begins a new life at the Shawshank prison, where he puts his accounting skills to work for an amoral warden. During his long stretch in prison, Dufresne comes to be admired by the other inmates -- including an older prisoner named Red -- for his integrity and unquenchable sense of hope.", popularity: 155.042, posterPath: "/q6y0Go1tsGEsmtFryDOJo3dEmqu.jpg", releaseDate: "1994-09-23", firstAirDate: nil, title: "The Shawshank Redemption", name: nil, voteAverage: 8.704, voteCount: 25610, tagline: "The Shawshank Redemption")
}
