import UIKit
import WebKit

protocol ImagesListViewControllerProtocol {
    var presenter: ImagesListCellProtocol? { get set }
    var imagesListService: ImagesListService { get }
    var tableView: UITableView! { get }
    func imageListCellDidTapLike(_ cell: ImagesListCellProtocol)
    func updateTableViewAnimated()
}

final class ImagesListViewController: UIViewController, ImagesListCellDelegate & ImagesListViewControllerProtocol {
    var presenter: ImagesListCellProtocol?
    let imagesListService = ImagesListService.shared
    
    // MARK: - IBOutlet
    
    @IBOutlet var tableView: UITableView!
    
    // MARK: - Private Properties
    
    private let showSingleImageSegueIdentifier = "showSingleImage"
    private var photos: [Photo] = []
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
    
    // MARK: - Override Methods

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            if let viewController = segue.destination as? SingleImageViewController,
               let indexPath = sender as? IndexPath,
               let photo = photos[indexPath.row].largeImageURL,
               let largeImageURL = URL(string: photo) {
                viewController.fullImageURL = largeImageURL
            }
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        NotificationCenter.default
            .addObserver(forName: ImagesListService.didChangeNotification,
                        object: imagesListService,
                        queue: .main) { [weak self] _ in
                guard let self = self else { return }
                self.updateTableViewAnimated()
            }
    }
    
    func updateTableViewAnimated() {
        guard view != nil else { return }
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        photos = imagesListService.photos
        if oldCount != newCount {
            tableView.performBatchUpdates {
                let indexPaths = (oldCount..<newCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                tableView.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in }
        }
    }
    
    func imageListCellDidTapLike(_ cell: ImagesListCellProtocol) {
        guard let indexPath = tableView.indexPath(for: cell as! UITableViewCell) else { return }
        let photo = photos[indexPath.row]
        UIBlockingProgressHUD.show()
        imagesListService.changeLike(photoId: photo.id, isLike: photo.isLiked) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.photos = self.imagesListService.photos
                    cell.setIsLiked(self.photos[indexPath.row].isLiked)
                    UIBlockingProgressHUD.dismiss()
                case .failure:
                    UIBlockingProgressHUD.dismiss()
                }
            }
        }
    }
}

// MARK: - UITableViewDataSource

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("Configuring cell for row \(indexPath.row)")
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath) as? ImagesListCell
        else { return UITableViewCell() }
        cell.delegate = self
        let photo = photos[indexPath.row]
        configCell(photo: photo, for: cell, with: indexPath)
        return cell
    }
}

extension ImagesListViewController {
    func configCell(photo: Photo, for cell: ImagesListCell, with indexPath: IndexPath) {
        
        guard let image = photo.regularImageURL else { return }
        let imageURL = URL(string: image)
        cell.cellImage.kf.indicatorType = .activity
        cell.cellImage.kf.setImage(
            with: imageURL,
            placeholder: UIImage(named: "stub"),
            options: [.transition(.fade(1))]
        ) { [weak self] result in
            DispatchQueue.main.async { [self] in
                guard let self = self else { return }
                switch result {
                case .success:
                    cell.cellImage.contentMode = .scaleToFill
                    cell.setIsLiked(self.photos[indexPath.row].isLiked)
                    
                    if let date = self.photos[indexPath.row].createdAt {
                        cell.dateLabel.text = self.dateFormatter.string(from: date)
                    } else {
                        cell.dateLabel.text = ""
                    }
                case .failure(let error):
                    assertionFailure("\(error)")
                }
            }
        }
        
        cell.addGradient()
    }
}

// MARK: - UITableViewDelegate

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let image = photos[indexPath.row]
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = image.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
        
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == imagesListService.photos.count {
            imagesListService.fetchPhotosNextPage()
        }
    }
}
