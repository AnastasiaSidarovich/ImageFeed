import UIKit

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    weak var delegate: ImagesListCellDelegate?
    
    private let gradient = CAGradientLayer()
    private let imagesListService = ImagesListService.shared
   
    // MARK: - IBOutlet
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var cellImage: UIImageView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        cellImage.backgroundColor = .ypWhiteWithAlpha
        gradient.frame = cellImage.bounds
    }
    
    override func prepareForReuse(){
        super.prepareForReuse()
        cellImage.kf.cancelDownloadTask()
    }
    
    @IBAction func likeAction() {
        delegate?.imageListCellDidTapLike(self)
    }
}

extension ImagesListCell {
    func addGradient() {
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.withAlphaComponent(0.8).cgColor]
        gradient.locations = [0.7, 1.0]
        gradient.frame = cellImage.bounds
                
        gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
                
        cellImage.layer.sublayers?.filter { $0 is CAGradientLayer }.forEach { $0.removeFromSuperlayer() }
                
        cellImage.layer.addSublayer(gradient)
    }
    
    func setIsLiked(_ isLiked: Bool) {
        let likeImage = isLiked ? UIImage(named: "like_button_on") : UIImage(named: "like_button_off")
        likeButton.setImage(likeImage, for: .normal)
    }
}
