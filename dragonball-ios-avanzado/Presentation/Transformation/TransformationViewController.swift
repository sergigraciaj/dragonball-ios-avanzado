import UIKit

class TransformationViewController: UIViewController {
    @IBOutlet private weak var photo: AsyncImageView!
    @IBOutlet private weak var name: UILabel!
    @IBOutlet private weak var info: UILabel!
    
    private let viewModel: TransformationViewModel
    
    init(viewModel: TransformationViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "TransformationViewController", bundle: Bundle(for: type(of: self)))
        
        self.navigationItem.title = viewModel.transformation.name
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photo.setDetailImage(viewModel.transformation.photo)
        name.text = viewModel.transformation.name
        info.text = viewModel.transformation.info
    }
}
