import Foundation

extension URLRequest {
    static func makeHTTPRequest(
        path: String,
        httpMethod: String,
        baseURL: URL? = AuthConfiguration.standard.defaultBaseURL,
        queryItems: [URLQueryItem]? = nil
    ) -> URLRequest? {
        var request: URLRequest
        
        if let baseURL = baseURL,
           var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true) {
            
            urlComponents.path = path
            urlComponents.queryItems = queryItems
            
            guard let url = urlComponents.url else {
                assertionFailure("Invalid URL components")
                return nil
            }
            
            request = URLRequest(url: url)
        } else {
            assertionFailure("Invalid baseURL or path")
            return nil
        }
        
        request.httpMethod = httpMethod
        return request
    }
}
