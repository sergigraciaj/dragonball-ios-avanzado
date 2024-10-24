import Foundation

enum LocationDetailState: Equatable {
    case loading
    case error(reason: String)
    case success
}

final class HeroDetailViewModel {
    let onStateChanged = Binding<LocationDetailState>()
    let hero: Hero
    private(set) var location: [Location] = []
    private let useCase: GetLocationsUseCaseContract
    var annotations: [HeroAnnotation] = []
    
    init(hero: Hero, useCase: GetLocationsUseCaseContract) {
        self.hero = hero
        self.useCase = useCase
    }
    
    func load(id: String) {
        onStateChanged.update(newValue: .loading)
        useCase.execute(id: id) { [weak self] result in
            do {
                self?.location = try result.get()
                self?.createAnnotations()
                self?.onStateChanged.update(newValue: .success)
            } catch {
                self?.onStateChanged.update(newValue: .error(reason: error.localizedDescription))
            }
        }
    }
    
    private func createAnnotations() {
        self.annotations = []
        location.forEach { [weak self]  location in
            guard let coordinate = location.coordinate else {
                return
            }
            let annotation = HeroAnnotation(title: self?.hero.name, coordinate: coordinate)
            self?.annotations.append(annotation)
        }
        self.onStateChanged.update(newValue: .success)
    }
}
