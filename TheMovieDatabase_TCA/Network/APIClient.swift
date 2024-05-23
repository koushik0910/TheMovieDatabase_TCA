//
//  APIClient.swift
//  TheMovieDatabase_TCA
//
//  Created by Koushik Dutta on 04/04/24.
//

import Foundation
import ComposableArchitecture

struct APIClient {
    var fetchMediaDetails: (String) async throws -> IdentifiedArrayOf<Media>
    var searchMovies: (String) async throws -> IdentifiedArrayOf<Media>
    var fetchCastDetails: (Int) async throws -> [Cast]?
    var fetchReviews: (Int) async throws -> [Review]?
}

extension APIClient: DependencyKey {
  static let liveValue = Self (
    fetchMediaDetails: { path in
        let url = try EndPoint.createURL(urlPath: path).url
        let response: ResponseData = try await NetworkUtility.request(url: url)
        return response.results
    },
    searchMovies: { query in
        let params = [Constants.ParamKeys.query : query]
        let url = try EndPoint.createURL(urlPath: Routes.search.path, params: params).url
        let response: ResponseData = try await NetworkUtility.request(url: url)
        return response.results
    },
    fetchCastDetails: { mediaId in
        let url = try EndPoint.createURL(urlPath: Routes.cast(mediaId).path).url
        let response: CastResponse = try await NetworkUtility.request(url: url)
        return response.cast
    },
    fetchReviews: { mediaId in
        let url = try EndPoint.createURL(urlPath: Routes.reviews(mediaId).path).url
        let response: ReviewResponse = try await NetworkUtility.request(url: url)
        return response.results
    }
  )
}

extension DependencyValues {
  var apiClient: APIClient {
    get { self[APIClient.self] }
    set { self[APIClient.self] = newValue }
  }
}

