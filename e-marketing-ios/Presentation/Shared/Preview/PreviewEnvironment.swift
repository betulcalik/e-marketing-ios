//
//  PreviewEnvironment.swift
//  e-marketing-ios
//

import SwiftUI

#if DEBUG
extension View {
    func previewAppEnvironment(session: AppSessionStore? = nil,
                               language: LanguageStore? = nil) -> some View {
        let session = session ?? AppSessionStore(keychainTokenStore: KeychainTokenStore())
        let router = AppRouter()
        let language = language ?? LanguageStore(storage: UserDefaultsStore())

        return self
            .environment(\.locale, language.locale)
            .environment(language)
            .environment(session)
            .environment(router)
    }
}

extension HTTPClient {
    static var preview: HTTPClient {
        HTTPClient(logger: NetworkLogger(),
                   interceptors: [AuthInterceptor(tokenStore: KeychainTokenStore())])
    }
}
#endif
