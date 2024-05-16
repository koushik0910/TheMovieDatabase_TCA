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
    var fetchCastDetails: (Int) async -> [Cast]?
    var fetchReviews: (Int) async -> [Review]?
}

extension APIClient: DependencyKey {
  static let liveValue = Self (
    fetchMovies: { urlString in
        let response: ResponseData = try await NetworkUtility.shared.request(urlString: urlString)
        return response.results
    },
    searchMovies: { query in
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let urlString = "https://api.themoviedb.org/3/search/movie?api_key=909594533c98883408adef5d56143539&query=\(query)"
        let response: ResponseData = try await NetworkUtility.shared.request(urlString: urlString)
        return response.results
    },
    fetchCastDetails: { movieId in
        do{
            let urlString = "https://api.themoviedb.org/3/movie/\(movieId)/credits?api_key=909594533c98883408adef5d56143539"
            let response: CastResponse = try await NetworkUtility.shared.request(urlString: urlString)
            return response.cast
        }catch{
            print(error.localizedDescription)
            return nil
        }
    },
    fetchReviews: { movieId in
        do{
            let urlString = "https://api.themoviedb.org/3/movie/\(movieId)/reviews?api_key=909594533c98883408adef5d56143539"
            let response: ReviewResponse = try await NetworkUtility.shared.request(urlString: urlString)
            return response.results
        }catch{
            print(error.localizedDescription)
            return nil
        }
    }
  )
}


extension APIClient: TestDependencyKey {
    static let testValue = Self (
        fetchMovies: { urlString in
            let response: ResponseData = try await NetworkUtility.shared.request(urlString: urlString)
            return response.results
        },
        searchMovies: { query in
            let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            let urlString = "https://api.themoviedb.org/3/search/movie?api_key=909594533c98883408adef5d56143539&query=\(query)"
            let response: ResponseData = try await NetworkUtility.shared.request(urlString: urlString)
            return response.results
        },
        fetchCastDetails: { movieId in
            do{
                let urlString = "https://api.themoviedb.org/3/movie/\(movieId)/credits?api_key=909594533c98883408adef5d56143539"
                let response: CastResponse = try await NetworkUtility.shared.request(urlString: urlString)
                return response.cast
            }catch{
                print(error.localizedDescription)
                return nil
            }
        },
        fetchReviews: { movieId in
            do{
                let urlString = "https://api.themoviedb.org/3/movie/\(movieId)/reviews?api_key=909594533c98883408adef5d56143539"
                let response: ReviewResponse = try await NetworkUtility.shared.request(urlString: urlString)
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

