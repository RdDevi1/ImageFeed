import Foundation
import SwiftKeychainWrapper
import WebKit

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
                keychainWrapper.removeObject(forKey: Keys.bearerToken.rawValue)
                keychainWrapper.set(bearerToken, forKey: Keys.bearerToken.rawValue)
            }
        }
    }
    
    func clean() {
        keychainWrapper.removeObject(forKey: Keys.bearerToken.rawValue)
        // Очищаем все куки из хранилища.
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        // Запрашиваем все данные из локального хранилища.
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            // Массив полученных записей удаляем из хранилища.
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
}

