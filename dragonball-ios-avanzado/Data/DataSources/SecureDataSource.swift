import KeychainSwift

protocol SecureDataStoreProtocol {
    
    func set(token: String)
    func getToken() -> String?
    func deleteToken()
}

class SecureDataStore: SecureDataStoreProtocol {
    
    private let Ktoken = "Ktoken"
    private let keychain  = KeychainSwift()
    
    static let shared: SecureDataStore = .init()
    
    func set(token: String) {
        keychain.set(token, forKey: Ktoken)
    }
    
    func getToken() -> String? {
        keychain.get(Ktoken)
    }
    
    func deleteToken() {
        keychain.delete(Ktoken)
    }
    
}
