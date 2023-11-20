import Foundation

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let regularImageURL: String?
    let largeImageURL: String?
    var isLiked: Bool
    
    private static let dateFormatter = ISO8601DateFormatter()
    
    init(photoResult: PhotoResult) {
        self.id = photoResult.id
        self.size = CGSize(width: photoResult.width, height: photoResult.height)
        self.createdAt = Self.dateFormatter.date(from: photoResult.createdAt)
        self.welcomeDescription = photoResult.description
        self.regularImageURL = photoResult.urls?.small
        self.largeImageURL = photoResult.urls?.full
        self.isLiked = photoResult.likedByUser
    }
}
