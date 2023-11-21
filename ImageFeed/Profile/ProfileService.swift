import Foundation
import WebKit

final class ProfileService {
    static let shared = ProfileService()
    private init() { }
    
    private(set) var profile: Profile?
    private var task: URLSessionTask?
    private let urlSession = URLSession.shared
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        guard profile == nil else { return }
        task?.cancel()
        
        var request: URLRequest? = profileRequest
        request?.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        guard let request = request else {
            assertionFailure("Невозможно сформировать запрос!")
            return
        }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let profileResult):
                    let profile = Profile(profileResult: profileResult)
                    self.profile = profile
                    completion(.success(profile))
                case .failure(let error):
                    completion(.failure(error))
                    self.profile = nil
                }
            }
        }
        
        self.task = task
        task.resume()
    }
    
    func clearProfile() {
        profile = nil
    }
}

extension ProfileService {
    var profileRequest: URLRequest? {
        URLRequest.makeHTTPRequest(
            path: "/me",
            httpMethod: "GET"
        )
    }
}
