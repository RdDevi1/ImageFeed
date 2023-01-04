import Foundation

final class OAuth2TokenStorage {
    
    private let userDefaults = UserDefaults.standard
    
    private enum Keys: String {
        case bearerToken
    }
    
    var bearerToken: String? {
        get {
            userDefaults.string(forKey: Keys.bearerToken.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.bearerToken.rawValue)
        }
    }
}
