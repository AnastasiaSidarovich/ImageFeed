import Foundation

final class OAuth2Service {
    let configuration: AuthConfiguration

    init(configuration: AuthConfiguration = .standard) {
        self.configuration = configuration
    }
    // MARK: - Private Properties
    
    private let urlSession = URLSession.shared
    private let tokenStorage = OAuth2TokenStorage.shared
    private var task: URLSessionTask?
    private var lastCode: String?
    
    private (set) var authToken: String? {
        get {
            return tokenStorage.token
        }
        set {
            tokenStorage.token = newValue
        }
    }

    // MARK: - Methods
    
    func fetchOAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        if lastCode == code { return }
        task?.cancel()
        lastCode = code
        
        guard let request = authTokenRequest(code: code) else {
            assertionFailure("Невозможно сформировать запрос!")
            return
        }

        let task = urlSession.objectTask(for: request) {
            [weak self] (result: Result<OAuth2TokenResponseBody, Error>) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let body):
                    let authToken = body.accessToken
                    self.authToken = authToken
                    completion(.success(authToken))
                case .failure(let error):
                    completion(.failure(error))
                }
                self.task = nil
            }
        }
        self.task = task
        task.resume()
    }
}

extension OAuth2Service {
    func authTokenRequest(code: String) -> URLRequest? {
        let queryItems = [
            URLQueryItem(name: "client_id", value: configuration.accessKey),
            URLQueryItem(name: "client_secret", value: configuration.secretKey),
            URLQueryItem(name: "redirect_uri", value: configuration.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        
        return URLRequest.makeHTTPRequest(
            path: "/oauth/token",
            httpMethod: "POST",
            baseURL: configuration.baseURL,
            queryItems: queryItems
        )
    }
}
