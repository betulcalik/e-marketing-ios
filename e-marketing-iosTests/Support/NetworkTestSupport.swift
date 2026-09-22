//
//  NetworkTestSupport.swift
//  e-marketing-ios
//
//  Created by Betül Tarhan on 22.09.2026.
//

import Foundation
@testable import e_marketing_ios

extension HTTPClient {
    static func mock() -> HTTPClient {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]

        return HTTPClient(
            session: URLSession(configuration: configuration),
            logger: NetworkLogger(),
            interceptors: []
        )
    }
}

func makeHttpResponse(_ request: URLRequest, statusCode: Int) -> HTTPURLResponse {
    HTTPURLResponse(
        url: request.url!,
        statusCode: statusCode,
        httpVersion: nil,
        headerFields: ["Content-Type": "application/json"]
    )!
}
