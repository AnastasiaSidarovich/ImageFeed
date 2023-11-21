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
