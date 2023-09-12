import Foundation

extension URLRequest {
    static func makeHTTPRequest(
        path: String,
        httpMethod: String,
        baseURL: URL? = Constants.defaultBaseURL,
        queryItems: [URLQueryItem]? = nil
    ) -> URLRequest {
        var request: URLRequest
        
        if let baseURL = baseURL,
           var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true) {
            
            urlComponents.path = path
            urlComponents.queryItems = queryItems
            
            guard let url = urlComponents.url else {
                fatalError("Invalid URL components")
            }
            
            request = URLRequest(url: url)
        } else {
            fatalError("Invalid baseURL or path")
        }
        
        request.httpMethod = httpMethod
        return request
    }
}
