//
//  HTTPMethod.swift
//  Fetch-Recipe
//
//  Created by Abhishek Dogra on 12/03/25.
//

import Foundation

enum HTTPMethod: String {
    case GET
    case PUT
    case POST
    case DELETE
}

enum HTTPError: Error {
    case invalidURL
    case requestFailed(statusCode: Int)
    case invalidResponse
    case decodingError
    case unknownError
}

protocol NetworkManagerProtocol: Sendable {
    func makeAPICall<T: Codable>(urlString: APIEndPoints, method: HTTPMethod, params: [String: Any]?) async throws -> T
}

extension NetworkManagerProtocol {
    func makeAPICall<T: Codable>(urlString: APIEndPoints, method: HTTPMethod, params: [String: Any]? = nil) async throws -> T {
        try await makeAPICall(urlString: urlString, method: method, params: params)
    }
}

final class NetworkManager: NetworkManagerProtocol, Sendable {
    static let shared = NetworkManager()
    private let baseURL = "https://d3jbb8n5wk0qxi.cloudfront.net/"
    private init() {}
    
    func makeAPICall<T: Codable>(urlString: APIEndPoints, method: HTTPMethod, params: [String: Any]? = nil) async throws(HTTPError) -> T {
        guard let url = URL(string: baseURL + urlString.rawValue) else { throw HTTPError.invalidURL }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if method != .GET, let params {
            request.httpBody = try? JSONSerialization.data(withJSONObject: params)
        }
        
        do {
            let (data, httpResponse) = try await URLSession.shared.data(for: request)
            guard let response = httpResponse as? HTTPURLResponse else {
                throw HTTPError.invalidResponse
            }
            
            if (200...299).contains(response.statusCode) {
                do {
                    return try JSONDecoder().decode(T.self, from: data)
                } catch {
                    print(error.localizedDescription)
                    throw HTTPError.invalidResponse
                }
                
            } else {
                throw HTTPError.requestFailed(statusCode: response.statusCode)
            }
        } catch {
            throw HTTPError.unknownError
        }
    }
}
