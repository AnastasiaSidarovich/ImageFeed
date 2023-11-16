import Foundation

struct PhotoResult: Decodable {
    let id: String
    let width: Int
    let height: Int
    let createdAt: String
    let likedByUser: Bool
    let description: String?
    let urls: UrlsResult?
}

struct UrlsResult: Decodable {
    let raw: String?
    let full: String?
    let regular: String?
    let small: String?
    let thumb: String?
}

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let regularImageURL: String?
    let largeImageURL: String?
    var isLiked: Bool
    
    let dateFormatter: DateFormatter = {
        let date = DateFormatter()
        date.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return date
    }()
    
    init(photoResult: PhotoResult) {
        self.id = photoResult.id
        self.size = CGSize(width: photoResult.width, height: photoResult.height)
        self.createdAt = dateFormatter.date(from: photoResult.createdAt)
        self.welcomeDescription = photoResult.description
        self.regularImageURL = photoResult.urls?.small
        self.largeImageURL = photoResult.urls?.full
        self.isLiked = photoResult.likedByUser
    }
}

struct LikeResult: Decodable {
    let photo: PhotoResult?
}
