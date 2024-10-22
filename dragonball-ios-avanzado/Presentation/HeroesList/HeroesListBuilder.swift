import UIKit

final class HeroesListBuilder {
    func build() -> UIViewController {
        let useCase = GetAllHeroesUseCase()
        let viewModel = HeroesListViewModel(useCase: useCase)
        let viewController = HeroesListViewController(viewModel: viewModel)
        viewController.modalPresentationStyle = .fullScreen
        return viewController
    }
}
