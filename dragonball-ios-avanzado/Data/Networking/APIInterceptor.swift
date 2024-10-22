import Foundation

protocol APIInterceptor { }

protocol APIRequestInterceptor: APIInterceptor {
    func intercept(request: inout URLRequest)
}

final class AuthenticationRequestInterceptor: APIRequestInterceptor {
    func intercept(request: inout URLRequest) {
         guard let token = SecureDataStore.shared.getToken() else {
            return
        }
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    }
}
