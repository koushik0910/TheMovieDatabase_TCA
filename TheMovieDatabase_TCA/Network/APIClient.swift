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
    var searchMovies: (String) async throws -> [Movie]
    var fetchCastDetails: (Int) async  -> [Cast]?
    var fetchReviews: (Int) async -> [Review]?
}

extension APIClient: DependencyKey {
  static let liveValue = Self (
    fetchMovies: { path in
        let params = [
            Constants.ParamKeys.apiKey : Constants.ParamValues.apiKey
        ]
        let url = EndPoint.createURL(urlPath: path, params: params).url
        let response: ResponseData = try await NetworkUtility.shared.request(url: url)
        return response.results
    },
    searchMovies: { query in
        let params = [
            Constants.ParamKeys.apiKey : Constants.ParamValues.apiKey,
            Constants.ParamKeys.query : query
        ]
        let url = EndPoint.createURL(urlPath: "/3/search/movie", params: params).url
        let response: ResponseData = try await NetworkUtility.shared.request(url: url)
        return response.results
    },
    fetchCastDetails: { movieId in
        do{
            let params = [
                Constants.ParamKeys.apiKey : Constants.ParamValues.apiKey
            ]
            let url = EndPoint.createURL(urlPath: "/3/movie/\(movieId)/credits", params: params).url
            let response: CastResponse = try await NetworkUtility.shared.request(url: url)
            return response.cast
        }catch{
            print(error.localizedDescription)
            return nil
        }
    },
    fetchReviews: { movieId in
        do{
            let params = [
                Constants.ParamKeys.apiKey : Constants.ParamValues.apiKey
            ]
            let url = EndPoint.createURL(urlPath: "/3/movie/\(movieId)/reviews", params: params).url
            let response: ReviewResponse = try await NetworkUtility.shared.request(url: url)
            return response.results
        }catch{
            print(error.localizedDescription)
            return nil
        }
    }
  )
}

extension DependencyValues {
  var apiClient: APIClient {
    get { self[APIClient.self] }
    set { self[APIClient.self] = newValue }
  }
}

