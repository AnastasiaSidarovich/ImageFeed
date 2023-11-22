@testable import ImageFeed
import XCTest

class ImagesListCellMock: ImagesListCell {
    var isLiked: Bool = false

    override func setIsLiked(_ isLiked: Bool) {
        self.isLiked = isLiked
    }
}

class ImagesListViewControllerMock: ImagesListViewController {
    var likeCompletionResult: Result<Void, Error>?
    var isUpdateTableViewAnimatedCalled = false
    
    override func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let cellMock = cell as? ImagesListCellMock else { return }
        cellMock.isLiked.toggle()
        
        if let result = likeCompletionResult {
            switch result {
            case .success:
                cell.setIsLiked(cellMock.isLiked)
            case .failure: break
            }
        }
    }
    
    override func updateTableViewAnimated() {
        isUpdateTableViewAnimatedCalled = true
    }
}

final class ImagesListViewControllerTests: XCTestCase {
    func testImagesListCellDidTapLike() {
        // Given
        let presenter = ImagesListViewControllerMock()
        let tableView = UITableView()
        let cell = ImagesListCellMock()
        cell.delegate = presenter
                
        tableView.register(ImagesListCell.self, forCellReuseIdentifier: "ImagesListCell")
        tableView.dataSource = presenter
        presenter.tableView = tableView

        // When
        presenter.imageListCellDidTapLike(cell)

        // Then
        XCTAssertTrue(cell.isLiked)
    }
    
    func testUpdateTableViewAnimated() {
        // Given
        let presenter = ImagesListViewControllerMock()
        let tableView = UITableView()
        
        tableView.register(ImagesListCell.self, forCellReuseIdentifier: "ImagesListCell")
        tableView.dataSource = presenter
        presenter.tableView = tableView

        // When
        presenter.updateTableViewAnimated()

        // Then
        XCTAssertTrue(presenter.isUpdateTableViewAnimatedCalled)
    }
}
