//
//  NetworkUtility.swift
//  TheMovieDatabase_TCA
//
//  Created by Koushik Dutta on 04/04/24.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
    case network(Error?)
}

class NetworkUtility{
    static let shared = NetworkUtility()
    private init() { }
    
    func request<T: Decodable>(urlString: String) async throws -> T {
        guard let url = URL(string: urlString) else { throw NetworkError.invalidURL }
        let urlRequest = URLRequest(url: url)
        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, (200...299).contains(statusCode) else {
                throw NetworkError.invalidResponse
            }
            guard let response = try? JSONDecoder().decode(T.self, from: data) else { throw NetworkError.invalidData }
            return response
        } catch {
            throw NetworkError.network(error)
        }
    }
}
