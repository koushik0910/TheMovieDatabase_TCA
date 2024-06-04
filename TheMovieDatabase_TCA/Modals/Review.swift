//
//  Review.swift
//  TheMovieDatabase_TCA
//
//  Created by Koushik Dutta on 06/04/24.
//

import Foundation
import ComposableArchitecture

// MARK: - ReviewResponse
struct ReviewResponse: Decodable {
    let results: IdentifiedArrayOf<Review>
}

// MARK: - Result
struct Review: Decodable, Equatable, Identifiable {
    let id: String
    let author: String
    let authorDetails: AuthorDetails
    let content: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case author
        case authorDetails = "author_details"
        case content
    }
    
}

// MARK: - AuthorDetails
struct AuthorDetails: Decodable, Equatable {
    let name: String
    let username: String
    let avatarPath: String?
    let rating: Double?
    
    var ratingText: String {
        rating?.description ?? "NA"
    }
    
    var fullAvatarPath: URL? {
        guard let avatarPath else { return nil }
        return URL(string: Routes.completeImageURLString(avatarPath).path)
    }

    enum CodingKeys: String, CodingKey {
        case name
        case username
        case avatarPath = "avatar_path"
        case rating
    }
}


extension Review {
    static let mock = Self(id: "65e6d212097c49", author: "Chandler Danier", authorDetails: AuthorDetails(name: "Chandler Danier", username: "chandlerdanier", avatarPath: nil, rating: 9.0), content: "reat but a little long. Sexier than LotR and no hair. Yell acting. Jabba bathes in black goo and kills women horribly. Walken is hilarious. Zendaya still an addict. Bridges is a bit self-serious. Amazing visuals. Really enjoyed...was glad and a bit bored by the end. Shorter Dunes please.")
}
