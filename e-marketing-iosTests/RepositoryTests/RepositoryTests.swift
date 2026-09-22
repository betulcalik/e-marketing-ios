//
//  RepositoryTests.swift
//  e-marketing-ios
//
//  Created by Betül Tarhan on 22.09.2026.
//

import Testing
import Foundation
@testable import e_marketing_ios

@MainActor
@Suite("Repository Tests", .serialized)
struct RepositoryTests {

    // MARK: - Login
    @Test("[Login] Success test")
    func login_success_returnsSession() async throws {
        MockURLProtocol.requestHandler = { request in
            (makeHttpResponse(request, statusCode: 200), Self.loginBody)
        }

        let session = try await makeLoginRepository().login(username: "emilys", password: "emilyspass")

        #expect(session.accessToken == "access-token")
        #expect(session.user?.firstName == "Emily")
    }

    @Test("[Login] AppError unauthorized test")
    func login_unauthorized_throwsClientError401() async throws {
        MockURLProtocol.requestHandler = { request in
            (makeHttpResponse(request, statusCode: 401), Data())
        }

        await #expect(throws: AppError.clientError(statusCode: 401)) {
            try await makeLoginRepository().login(username: "emilys", password: "wrong")
        }
    }

    @Test("[Login] AppError timeout test")
    func login_timeout_throwsTimeout() async throws {
        MockURLProtocol.requestHandler = { _ in
            throw URLError(.timedOut)
        }

        await #expect(throws: AppError.timeout) {
            try await makeLoginRepository().login(username: "emilys", password: "emilyspass")
        }
    }

    @Test("[Login] AppError decoding test")
    func login_malformedResponse_throwsDecodingError() async throws {
        MockURLProtocol.requestHandler = { request in
            (makeHttpResponse(request, statusCode: 200), Data("<html>not json</html>".utf8))
        }

        await #expect(throws: AppError.decodingError) {
            try await makeLoginRepository().login(username: "emilys", password: "emilyspass")
        }
    }

    @Test("[Login] App Error statuses test")
    func login_errorStatuses_mapToAppError() async throws {
        let cases: [(statusCode: Int, error: AppError)] = [
            (403, .clientError(statusCode: 403)),
            (404, .clientError(statusCode: 404)),
            (429, .clientError(statusCode: 429)),
            (500, .serverError(statusCode: 500)),
        ]

        for testCase in cases {
            MockURLProtocol.requestHandler = { request in
                (makeHttpResponse(request, statusCode: testCase.statusCode), Data())
            }

            await #expect(throws: testCase.error) {
                try await makeLoginRepository().login(username: "emilys", password: "emilyspass")
            }
        }
    }

    // MARK: - Products
    @Test("[Products] Pagination test")
    func products_success_sendsPagination_andMapsPage() async throws {
        var capturedURL: URL?
        MockURLProtocol.requestHandler = { request in
            capturedURL = request.url
            return (makeHttpResponse(request, statusCode: 200), Self.pageBody)
        }

        let page = try await makeProductRepository().products(limit: 10, skip: 20)

        let query = URLComponents(url: capturedURL!, resolvingAgainstBaseURL: false)?.queryItems ?? []
        #expect(query.contains(URLQueryItem(name: "limit", value: "10")))
        #expect(query.contains(URLQueryItem(name: "skip", value: "20")))
        #expect(page.total == 30)
        #expect(page.items.first?.id == 1)
    }

    @Test("[Products] Category endpoint test")
    func products_withCategory_routesToCategoryPath() async throws {
        var capturedURL: URL?
        MockURLProtocol.requestHandler = { request in
            capturedURL = request.url
            return (makeHttpResponse(request, statusCode: 200), Self.pageBody)
        }

        _ = try await makeProductRepository().products(category: "beauty", limit: 10, skip: 0)

        #expect(capturedURL?.path == "/auth/products/category/beauty")
    }
}

private extension RepositoryTests {

    static let loginBody = Data("""
    {"accessToken":"access-token","refreshToken":"refresh-token","id":1,
     "username":"emilys","email":"emilys@emilys.com",
     "firstName":"Emily","lastName":"Johnson","image":null}
    """.utf8)

    static let pageBody = Data("""
    {"products":[{"id":1,"title":"iPhone 16","thumbnail":null,"price":42999,
     "discountPercentage":10,"rating":4.8,"category":"smartphones"}],
     "total":30,"skip":20,"limit":10}
    """.utf8)

    func makeLoginRepository() -> LoginRepositoryImpl {
        LoginRepositoryImpl(client: HTTPClient.mock())
    }

    func makeProductRepository() -> ProductRepositoryImpl {
        ProductRepositoryImpl(client: HTTPClient.mock())
    }
}
