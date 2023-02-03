import UIKit
import Kingfisher

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}

final class ImagesListCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBAction private func likeButtonClicked() {
        delegate?.imageListCellDidTapLike(self)
    }

    weak var delegate: ImagesListCellDelegate?
    static let reuseIdentifier = "ImagesListCell"
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImage.kf.cancelDownloadTask()
    }
    
    func configCell(for cell: ImagesListCell, from photos: [Photo], with indexPath: IndexPath) {
        let imageUrl = photos[indexPath.row].thumbImageURL
        let url = URL(string: imageUrl)
        
        cell.cellImage.kf.indicatorType = .activity
        cell.cellImage.kf.setImage(
            with: url,
            placeholder: UIImage(named: "placeholderImageList")
        )
       
        if photos[indexPath.row].createdAt != nil {
            let createdAt = photos[indexPath.row].createdAt
            cell.dateLabel.text = createdAt?.dateTimeString
        } else {
            cell.dateLabel.text = ""
        }
        setIsLiked(isLiked: photos[indexPath.row].isLiked)
    }
    
    
    func setIsLiked(isLiked: Bool) {
        let likeImage = isLiked ? UIImage(named: "Like_on") : UIImage(named: "Like_off")
        likeButton.setImage(likeImage, for: .normal)
    }
}
