//
//  Endpoint.swift
//  e-marketing-ios
//
//  Created by Betül Tarhan on 19.09.2026.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

struct AnyEncodable: Encodable {
    private let encodeFunc: (Encoder) throws -> Void

    init(_ wrapped: some Encodable) {
        self.encodeFunc = wrapped.encode(to:)
    }

    func encode(to encoder: Encoder) throws {
        try encodeFunc(encoder)
    }
}

struct Endpoint {
    let path: String
    let method: HTTPMethod
    let headers: [String: String]
    let queryItems: [URLQueryItem]
    let body: AnyEncodable?

    init(path: String,
         method: HTTPMethod = .get,
         headers: [String: String] = [:],
         queryItems: [URLQueryItem] = []) {
        self.path = path
        self.method = method
        self.headers = headers
        self.queryItems = queryItems
        self.body = nil
    }

    init(path: String,
         method: HTTPMethod,
         headers: [String: String] = [:],
         queryItems: [URLQueryItem] = [],
         body: some Encodable) {
        self.path = path
        self.method = method
        self.headers = headers
        self.queryItems = queryItems
        self.body = AnyEncodable(body)
    }
}
