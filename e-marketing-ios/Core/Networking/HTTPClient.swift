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

    init(session: URLSession = .shared) {
        self.session = session
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

        do {
            let (data, response) = try await session.data(for: request)
            guard let http = response as? HTTPURLResponse else {
                throw AppError.invalidResponse
            }

            debugLog("Response: status code: \(http.statusCode) • body: \(bodyString(of: data))")   // TODO: Remove token

            try validate(statusCode: http.statusCode)
            return data
        } catch let error as URLError {
            debugLog("❌ Error: \(error)")
            throw appError(from: error)
        }
    }

    private func makeRequest(for endpoint: Endpoint) throws -> URLRequest {
        guard let url = URL(string: APIConstants.baseURL)?
            .appending(path: endpoint.path) else {
            throw AppError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.headers
        if let body = endpoint.body {
            request.httpBody = try JSONEncoder().encode(body)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }

        debugLog("Request: \(request.httpMethod ?? "") \(url.absoluteString) • body: \(maskedBody(of: request))")
        return request
    }

    // MARK: - Debug Logging
    private func debugLog(_ message: String) {
        debugPrint("🌐 [HTTP] \(message)")
    }

    private func maskedBody(of request: URLRequest) -> String {
        guard let body = request.httpBody,
              let json = try? JSONSerialization.jsonObject(with: body),
              var dict = json as? [String: Any] else { return "-" }

        if dict["password"] != nil {
            dict["password"] = "••••••"
        }
        return String(describing: dict)
    }

    private func bodyString(of data: Data) -> String {
        String(data: data, encoding: .utf8) ?? "-"
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
