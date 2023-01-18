import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    
    private enum Keys: String {
        case bearerToken
    }
    
    private let keychainWrapper = KeychainWrapper.standard
    
    var bearerToken: String? {
        get {
            keychainWrapper.string(forKey: Keys.bearerToken.rawValue)
        }
        set {
            if let bearerToken = newValue {
                keychainWrapper.set(bearerToken, forKey: Keys.bearerToken.rawValue )
            }
        }
    }
}
