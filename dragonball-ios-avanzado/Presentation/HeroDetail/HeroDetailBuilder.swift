import UIKit

final class HeroDetailBuilder {
    private let hero: Hero
    
    init (hero: Hero) {
        self.hero = hero
    }
    
    func build() -> UIViewController {
        let useCase = GetLocationsUseCase()
        let viewModel = HeroDetailViewModel(hero: hero, useCase: useCase)
        let viewController = HeroDetailViewController(viewModel: viewModel)
        viewController.modalPresentationStyle = .fullScreen
        return viewController
    }
}
