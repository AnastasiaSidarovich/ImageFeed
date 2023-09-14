import Foundation

final class ImagesListService {
    static let shared = ImagesListService()
    private init() { }
    
    static let DidChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    private (set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    private var isFetching: Bool = false
    private var task: URLSessionTask?
    private let urlSession = URLSession.shared
    
    func fetchPhotosNextPage(token: String) {
        assert(Thread.isMainThread)
        guard !isFetching else { return }
        task?.cancel()
        
        let nextPage = lastLoadedPage == nil ? 1 : lastLoadedPage! + 1
        let request = imagesListRequest(page: nextPage, token: token)
        
        guard let request = request else {
            assertionFailure("Невозможно сформировать запрос!")
            return
        }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let photoResults):
                    let newPhotos = photoResults.map { photoResult in
                        return Photo(photoResult: photoResult)
                    }
                    self.photos.append(contentsOf: newPhotos)
                    self.lastLoadedPage = nextPage
                    NotificationCenter.default.post(name: ImagesListService.DidChangeNotification, object: self)
                case .failure(let error):
                    print("Error fetching photos: \(error)")
                }
                self.isFetching = false
            }
        }
        task.resume()
        self.task = task
    }
}

extension ImagesListService {
    func imagesListRequest(page: Int, token: String) -> URLRequest? {
        let queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "order_by", value: "popular"),
        ]
        
        return URLRequest.makeHTTPRequest(
            path: "/photos",
            httpMethod: "GET",
            baseURL: Constants.baseURL,
            queryItems: queryItems,
            token: token
        )
    }
}
