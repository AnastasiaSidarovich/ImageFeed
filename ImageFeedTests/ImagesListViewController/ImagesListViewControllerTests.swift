@testable import ImageFeed
import XCTest

final class ImagesListCellMock: ImagesListCellProtocol {
    var delegate: ImageFeed.ImagesListCellDelegate?
    var isLiked: Bool = false

    func setIsLiked(_ isLiked: Bool) {
        self.isLiked = isLiked
    }
}

final class ImagesListViewControllerMock: ImagesListViewControllerProtocol {
    var imagesListService = ImageFeed.ImagesListService.shared
    var tableView: UITableView!
    var presenter: ImageFeed.ImagesListCellProtocol?
    var likeCompletionResult: Result<Void, Error>?
    var isUpdateTableViewAnimatedCalled = false
    
    func imageListCellDidTapLike(_ cell: ImagesListCellProtocol) {
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
    
    func updateTableViewAnimated() {
        isUpdateTableViewAnimatedCalled = true
    }
}

final class ImagesListViewControllerTests: XCTestCase {
    func testImagesListCellDidTapLike() {
        // Given
        let presenter = ImagesListViewControllerMock()
        let tableView = UITableView()
        let cell = ImagesListCellMock()
        cell.delegate = presenter as? any ImagesListCellDelegate
                
        tableView.register(ImagesListCell.self, forCellReuseIdentifier: "ImagesListCell")
        tableView.dataSource = presenter as? any UITableViewDataSource
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
        tableView.dataSource = presenter as? any UITableViewDataSource
        presenter.tableView = tableView

        // When
        presenter.updateTableViewAnimated()

        // Then
        XCTAssertTrue(presenter.isUpdateTableViewAnimatedCalled)
    }
}
