import Foundation


extension Array {
    func withReplaced(itemAt: Index, newValue: Photo) -> [Photo] {
        var item = ImagesListService.shared.photos
        item.replaceSubrange(itemAt...itemAt, with: [newValue])
        return item
    }
}
