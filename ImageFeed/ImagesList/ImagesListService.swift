import Foundation

final class ImagesListService {
    static let shared = ImagesListService()
    private init() { }
    
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    // MARK: - Private Properties
    
    private (set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    private var isFetching = false
    private var isProcessingRequest = false
    private var task: URLSessionTask?
    private let urlSession = URLSession.shared
    private let tokenStorage = OAuth2TokenStorage.shared
    
    // MARK: - Methods
    
    func fetchPhotosNextPage() {
        assert(Thread.isMainThread)
        
        guard !isFetching else { return }
        isFetching = true
        
        var nextPage: Int
        if let lastLoadedPage = lastLoadedPage {
            nextPage = lastLoadedPage + 1
        } else {
            nextPage = 1
        }
        
        var request: URLRequest? = imagesListRequest(page: nextPage)
        
        guard let token = tokenStorage.token else { return }
        request?.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
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
                    NotificationCenter.default.post(name: Self.didChangeNotification, object: self)
                    self.isFetching = false
                case .failure(let error):
                    assertionFailure("\(error)")
                }
                self.isFetching = false
            }
        }
        task.resume()
        self.task = task
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        assert(Thread.isMainThread)
        guard !isProcessingRequest else { return }
        isProcessingRequest = true

        var request: URLRequest? = URLRequest.makeHTTPRequest(
            path: "/photos/\(photoId)/like",
            httpMethod: isLike ? "POST" : "DELETE",
            baseURL: Constants.defaultBaseURL
        )
        
        guard let token = tokenStorage.token else { return }
        request?.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        guard let request = request else {
            assertionFailure("Невозможно сформировать запрос!")
            return
        }

        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<LikeResult, Error>) in
            guard let self = self else { return }
            
            defer {
                self.isProcessingRequest = false
            }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let body):
                    if let index = self.photos.firstIndex(where: { $0.id == photoId }) {
                        var photo = self.photos[index]
                        
                        guard let photoRequest = body.photo else { return }
                        var newPhoto = Photo(photoResult: photoRequest)
                        newPhoto.isLiked = !photoRequest.likedByUser
                        self.photos = self.photos.withReplaced(itemAt: index, newValue: newPhoto)
                    }
                    completion(.success(()))
                case .failure(let error):
                    print("Ошибка при запросе: \(error)")
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
}

extension ImagesListService {
    func imagesListRequest(page: Int) -> URLRequest? {
        let queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "order_by", value: "latest"),
        ]
        
        return URLRequest.makeHTTPRequest(
            path: "/photos",
            httpMethod: "GET",
            baseURL: Constants.defaultBaseURL,
            queryItems: queryItems
        )
    }
}
