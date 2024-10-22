import UIKit

final class LoginBuilder {
    func build() -> UIViewController {
        let loginUseCase = LoginUseCase()
        let viewModel = LoginViewModel(useCase: loginUseCase)
        let viewController = LoginViewController(viewModel: viewModel)
        viewController.modalPresentationStyle = .fullScreen
        return viewController
    }
}
