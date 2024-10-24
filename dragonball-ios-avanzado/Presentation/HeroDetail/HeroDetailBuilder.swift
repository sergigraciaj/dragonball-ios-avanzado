import UIKit

final class HeroDetailBuilder {
    private let hero: Hero
    
    init (hero: Hero) {
        self.hero = hero
    }
    
    func build() -> UIViewController {
        let locationsUseCase = GetLocationsUseCase()
        let transformationsUseCase = GetTransformationsUseCase()
        let viewModel = HeroDetailViewModel(hero: hero, locationsUseCase: locationsUseCase, transformationsUseCase: transformationsUseCase)
        let viewController = HeroDetailViewController(viewModel: viewModel)
        viewController.modalPresentationStyle = .fullScreen
        return viewController
    }
}
