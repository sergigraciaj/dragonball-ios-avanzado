import UIKit

final class TransformationBuilder {
    private let transformation: Transformation
    
    init (transformation: Transformation) {
        self.transformation = transformation
    }
    
    func build() -> UIViewController {
        let viewModel = TransformationViewModel(transformation: transformation)
        let viewController = TransformationViewController(viewModel: viewModel)
        return viewController
    }
}
