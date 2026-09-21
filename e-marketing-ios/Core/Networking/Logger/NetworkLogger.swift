//
//  NetworkLogger.swift
//  e-marketing-ios
//
//  Created by Betül Tarhan on 21.09.2026.
//

import Foundation

final class NetworkLogger {

    func request(_ request: URLRequest, body: Data?) {
        let path = request.url?.path ?? ""
        let method = request.httpMethod ?? ""
        let url = request.url?.absoluteString ?? ""
        log("→ [\(path)] \(method) • \(url) • body: \(redactedBodyString(of: body))")
    }

    func response(path: String, statusCode: Int, data: Data?) {
        log("← [\(path)] \(statusCode) • \(redactedBodyString(of: data))")
    }

    func failure(path: String, error: Error) {
        log("✗ [\(path)] \(error)")
    }

    // MARK: - Output
    private func log(_ line: String) {
        #if DEBUG
        debugPrint("🌐 [HTTP] \(line)")
        #endif
    }

    // MARK: - Redaction
    private let sensitiveKeys: Set<String> = ["accessToken", "refreshToken", "token", "password"]

    private func redactedBodyString(of data: Data?) -> String {
        guard let data,
              let json = try? JSONSerialization.jsonObject(with: data) else {
            return "-"
        }
        return String(describing: redact(json))
    }

    private func redact(_ value: Any) -> Any {
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
}
