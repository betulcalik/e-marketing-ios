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
    private let keychainTokenStore: KeychainTokenStoring

    init(session: URLSession = .shared, keychainTokenStore: KeychainTokenStoring) {
        self.session = session
        self.keychainTokenStore = keychainTokenStore
    }

    func send<T: Decodable>(_ endpoint: Endpoint, as type: T.Type) async throws -> T {
        let data = try await performRequest(for: endpoint)

        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            debugLog("❌ Decode failed: \(error)")
            throw AppError.decodingError
        }
    }

    // MARK: - Private
    private func performRequest(for endpoint: Endpoint) async throws -> Data {
        let request = try makeRequest(for: endpoint)
        
        debugLog("→ [\(endpoint.path)] \(request.httpMethod ?? "") • \(request.url?.absoluteString ?? "") • body: \(redactedBodyString(of: request.httpBody))")

        do {
            let (data, response) = try await session.data(for: request)
            guard let http = response as? HTTPURLResponse else {
                throw AppError.invalidResponse
            }

            debugLog("← [\(endpoint.path)] \(http.statusCode) • \(redactedBodyString(of: data))")

            try validate(statusCode: http.statusCode)
            return data
        } catch let error as URLError {
            if error.code == .cancelled {
                throw CancellationError()
            }
            
            debugLog("❌ Error: \(error)")
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
            request.httpBody = try JSONEncoder().encode(body)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }

        if let tokenPair = keychainTokenStore.read() {
            request.setValue("Bearer \(tokenPair.accessToken)", forHTTPHeaderField: "Authorization")
        }
        
        return request
    }

    // MARK: - Debug Logging
    private func debugLog(_ message: String) {
        #if DEBUG
        debugPrint("🌐 [HTTP] \(message)")
        #endif
    }

    private func redactedBodyString(of data: Data?) -> String {
        guard let data,
              let json = try? JSONSerialization.jsonObject(with: data) else {
            return "-"
        }
        return String(describing: redact(json))
    }
    
    private func redact(_ value: Any) -> Any {
        let sensitiveKeys: Set<String> = ["accessToken", "refreshToken", "token", "password"]
        
        if var dict = value as? [String: Any] {
            for (key, val) in dict {
                dict[key] = sensitiveKeys.contains(key) ? "•••" : redact(val)
            }
            return dict
        }
        if let array = value as? [Any] {
            return array.map(redact)
        }
        return value
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
