import UIKit
import Kingfisher

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"

    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var gradientView: UIView!

    weak var delegate: ImagesListCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
        cellImage.kf.cancelDownloadTask()
    }
    func setIsLiked(isLiked: Bool) {
        let likeImage = isLiked ? UIImage(named: "Active") : UIImage(named: "No Active")
       likeButton.setImage(likeImage, for: .normal)
        likeButton.accessibilityIdentifier = "likeButton"
    }
    
    @IBAction func likeButtonClicked(_ sender: Any) {
        delegate?.imageListCellDidTapLike(self)
    }
}
