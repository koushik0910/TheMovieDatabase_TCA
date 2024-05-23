//
//  NetworkUtility.swift
//  TheMovieDatabase_TCA
//
//  Created by Koushik Dutta on 04/04/24.
//

import Foundation

class NetworkUtility{
    static func request<T: Decodable>(url: URL) async throws -> T {
        let urlRequest = URLRequest(url: url)
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        let responseData = try JSONDecoder().decode(T.self, from: data)
        return responseData
    }
}
