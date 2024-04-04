//
//  APIClient.swift
//  TheMovieDatabase_TCA
//
//  Created by Koushik Dutta on 04/04/24.
//

import Foundation
import ComposableArchitecture

struct APIClient {
    var fetchMovies: (String) async throws -> [Movie]
}
    
extension APIClient: DependencyKey {
  static let liveValue = Self (
    fetchMovies: { urlString in
        let response: ResponseData = try await NetworkUtility.shared.request(urlString: urlString)
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
