import Foundation

let AccessKey = "yiTvrZxo7JEqIsUSqpFLEGJ1E241cxayOXcmByF1v_s"
let SecretKey = "t7uyFsbpcGZhH9PQbnz_bmPvz6KZSztK0hbVw6Q9QcU"
let RedirectURI = "urn:ietf:wg:oauth:2.0:oob"
let AccessScope = "public+read_user+write_likes"
let DefaultBaseURL: URL? = URL(string: "https://api.unsplash.com")
let BaseURL: URL? = URL(string: "https://unsplash.com")
let UnsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL
    let authURLString: String
    let baseURL: URL

    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, authURLString: String, defaultBaseURL: URL, baseURL: URL) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.authURLString = authURLString
        self.baseURL = baseURL
    }

    static var standard: AuthConfiguration {
        return AuthConfiguration(accessKey: AccessKey,
                                 secretKey: SecretKey,
                                 redirectURI: RedirectURI,
                                 accessScope: AccessScope,
                                 authURLString: UnsplashAuthorizeURLString,
                                 defaultBaseURL: DefaultBaseURL ?? URL(string: "https://api.unsplash.com")!,
                                 baseURL: BaseURL ?? URL(string: "https://unsplash.com")!)
    }
}
