import UIKit

final class TransformationViewCell: UICollectionViewCell {
    static let reuseIdentifier = "TransformationViewCell"
    static var nib: UINib { UINib(nibName: "TransformationViewCell", bundle: Bundle(for: TransformationViewCell.self)) }
    
    @IBOutlet private weak var transformationName: UILabel!
    @IBOutlet private weak var photo: AsyncImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photo.cancel()
    }
    
    func setPhoto(_ photo: String) {
        self.photo.setImage(photo)
    }
    
    func setTransformationName(_ transformationName: String) {
        self.transformationName.text = transformationName
    }
}
