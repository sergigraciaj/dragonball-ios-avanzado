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
    private(set) var transformations: [Transformation] = []
    private let locationsUseCase: GetLocationsUseCaseContract
    private let transformationsUseCase: GetTransformationsUseCaseContract
    var annotations: [HeroAnnotation] = []
    
    init(hero: Hero, locationsUseCase: GetLocationsUseCaseContract, transformationsUseCase: GetTransformationsUseCaseContract) {
        self.hero = hero
        self.locationsUseCase = locationsUseCase
        self.transformationsUseCase = transformationsUseCase
    }
    
    func load(id: String) {
        onStateChanged.update(newValue: .loading)
        locationsUseCase.execute(id: id) { [weak self] result in
            do {
                self?.location = try result.get()
                self?.createAnnotations()
                self?.onStateChanged.update(newValue: .success)
            } catch {
                self?.onStateChanged.update(newValue: .error(reason: error.localizedDescription))
            }
        }
        transformationsUseCase.execute(id: id) { [weak self] result in
            do {
                self?.transformations = try result.get()
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
