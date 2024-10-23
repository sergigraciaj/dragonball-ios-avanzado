import Foundation

enum LocationDetailState: Equatable {
    case loading
    case error(reason: String)
    case success
}

final class HeroDetailViewModel {
    let onStateChanged = Binding<LocationDetailState>()
    private(set) var location: [Location] = []
    private let useCase: GetLocationsUseCaseContract

    init(useCase: GetLocationsUseCaseContract) {
        self.useCase = useCase
    }
    
    func load(id: String) {
        onStateChanged.update(newValue: .loading)
        useCase.execute(id: id) { [weak self] result in
            do {
                self?.location = try result.get()
                self?.onStateChanged.update(newValue: .success)
            } catch {
                self?.onStateChanged.update(newValue: .error(reason: error.localizedDescription))
            }
        }
    }
}
