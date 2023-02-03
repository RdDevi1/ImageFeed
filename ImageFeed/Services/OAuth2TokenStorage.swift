import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    
    static let shared = OAuth2TokenStorage()
    private init() {}
    
    private enum Keys: String {
        case bearerToken
    }
    
    private let keychainWrapper = KeychainWrapper.standard
    
    var bearerToken: String? {
        get {
            return keychainWrapper.string(forKey: Keys.bearerToken.rawValue)
        }
        set {
            if let bearerToken = newValue {
                keychainWrapper.set(bearerToken, forKey: Keys.bearerToken.rawValue)
            }
        }
    }
}

