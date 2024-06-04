//
//  Cast.swift
//  TheMovieDatabase_TCA
//
//  Created by Koushik Dutta on 05/04/24.
//

import Foundation
import ComposableArchitecture

// MARK: - CastResponse
struct CastResponse: Decodable {
    let cast: IdentifiedArrayOf<Cast>
}

// MARK: - Cast
struct Cast: Decodable, Equatable, Identifiable {
    let id: Int
    let name: String
    let character: String?
    let profilePath: String?
    
    var fullProfilePath: URL? {
        guard let profilePath else { return nil }
        return URL(string: Routes.completeImageURLString(profilePath).path)
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case character
        case profilePath = "profile_path"
    }
}

extension Cast {
    static let mock = Self(id: 2613589, name: "Sophie McIntosh", character: "Ava", profilePath: "/A1yhe60nSCzLS0wuy7MwgcL4uIl.jpg")
}

