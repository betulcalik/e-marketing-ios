//
//  HTTPClient.swift
//  e-marketing-ios
//
//  Created by Betül Tarhan on 19.09.2026.
//

import Foundation

@MainActor
protocol HTTPClientProtocol {
    func send<T: Decodable>(_ endpoint: Endpoint, as type: T.Type) async throws -> T
}

final class HTTPClient: HTTPClientProtocol {

    private let session: URLSession
    private let logger: NetworkLogger
    private let interceptors: [any RequestInterceptor]
    
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()

    init(session: URLSession = .shared,
         logger: NetworkLogger,
         interceptors: [any RequestInterceptor]) {
        self.session = session
        self.logger = logger
        self.interceptors = interceptors
    }

    // MARK: - Send
    func send<T: Decodable>(_ endpoint: Endpoint, as type: T.Type) async throws -> T {
        let data = try await performRequest(for: endpoint)

        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            logger.failure(path: endpoint.path, error: error)
            throw AppError.decodingError
        }
    }

    // MARK: - Private
    private func performRequest(for endpoint: Endpoint) async throws -> Data {
        let request = try makeRequest(for: endpoint)
        logger.request(request, body: request.httpBody)

        do {
            let (data, response) = try await session.data(for: request)
            guard let http = response as? HTTPURLResponse else {
                throw AppError.invalidResponse
            }

            logger.response(path: endpoint.path, statusCode: http.statusCode, data: data)

            try validate(statusCode: http.statusCode)
            return data
        } catch let error as URLError {
            if error.code == .cancelled {
                throw CancellationError()
            }

            logger.failure(path: endpoint.path, error: error)
            throw appError(from: error)
        }
    }

    private func makeRequest(for endpoint: Endpoint) throws -> URLRequest {
        guard let base = URL(string: APIConstants.baseURL)?.appending(path: endpoint.path) else {
            throw AppError.invalidURL
        }

        var components = URLComponents(url: base, resolvingAgainstBaseURL: false)
        if !endpoint.queryItems.isEmpty {
            components?.queryItems = endpoint.queryItems
        }

        guard let url = components?.url else {
            throw AppError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.headers
        
        if let body = endpoint.body {
            request.httpBody = try encoder.encode(body)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }

        /// Add interceptors
        for interceptor in interceptors {
            interceptor.intercept(&request)
        }

        return request
    }

    private func validate(statusCode: Int) throws {
        switch statusCode {
        case 200...299:
            return
        case 500...:
            throw AppError.serverError(statusCode: statusCode)
        default:
            throw AppError.clientError(statusCode: statusCode)
        }
    }

    private func appError(from error: URLError) -> AppError {
        switch error.code {
        case .timedOut:
            return .timeout
        case .notConnectedToInternet, .networkConnectionLost,
             .cannotFindHost, .cannotConnectToHost, .dnsLookupFailed:
            return .offline
        default:
            return .unknown
        }
    }
}
