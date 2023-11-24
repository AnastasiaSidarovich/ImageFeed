import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    static let shared = OAuth2TokenStorage()
    private init() { }
    
    private enum Keys: String {
        case token
    }

    var token: String? {
        get {
            return KeychainWrapper.standard.string(forKey: Keys.token.rawValue)
        }
        set {
            guard let newValue = newValue else {
                KeychainWrapper.standard.removeObject(forKey: Keys.token.rawValue)
                return
            }
            KeychainWrapper.standard.set(newValue, forKey: Keys.token.rawValue)
        }
    }
}
