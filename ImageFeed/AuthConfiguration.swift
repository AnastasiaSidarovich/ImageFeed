import Foundation

enum ConfigConstants {
    static let accessKey = "yiTvrZxo7JEqIsUSqpFLEGJ1E241cxayOXcmByF1v_s"
    static let secretKey = "t7uyFsbpcGZhH9PQbnz_bmPvz6KZSztK0hbVw6Q9QcU"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let defaultBaseURL: URL? = URL(string: "https://api.unsplash.com")
    static let baseURL: URL? = URL(string: "https://unsplash.com")
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
}

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL
    let authURLString: String
    let baseURL: URL

    init(
        accessKey: String,
        secretKey: String,
        redirectURI: String,
        accessScope: String,
        authURLString: String,
        defaultBaseURL: URL,
        baseURL: URL
    ) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.authURLString = authURLString
        self.baseURL = baseURL
    }

    static var standard: AuthConfiguration {
        return AuthConfiguration(accessKey: ConfigConstants.accessKey,
                                 secretKey: ConfigConstants.secretKey,
                                 redirectURI: ConfigConstants.redirectURI,
                                 accessScope: ConfigConstants.accessScope,
                                 authURLString: ConfigConstants.unsplashAuthorizeURLString,
                                 defaultBaseURL: ConfigConstants.defaultBaseURL ?? URL(string: "https://api.unsplash.com")!,
                                 baseURL: ConfigConstants.baseURL ?? URL(string: "https://unsplash.com")!)
    }
}
