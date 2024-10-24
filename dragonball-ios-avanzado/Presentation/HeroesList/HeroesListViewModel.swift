import Foundation

enum HeroesListState: Equatable {
    case loading
    case error(reason: String)
    case success
}

final class HeroesListViewModel {
    let onStateChanged = Binding<HeroesListState>()
    private(set) var heroes: [Hero] = []
    private let useCase: GetAllHeroesUseCaseContract
    private var storeDataProvider: StoreDataProvider
    private let secureStorage: SecureDataStoreProtocol
    
    init(useCase: GetAllHeroesUseCaseContract,
         storeDataProvider: StoreDataProvider = .shared,
         secureStorage: SecureDataStoreProtocol = SecureDataStore.shared
    ) {
        self.useCase = useCase
        self.storeDataProvider = storeDataProvider
        self.secureStorage = secureStorage
    }
    
    func load() {
        onStateChanged.update(newValue: .loading)
        useCase.execute(filter: nil) { [weak self] result in
            do {
                self?.heroes = try result.get()
                self?.onStateChanged.update(newValue: .success)
            } catch {
                self?.onStateChanged.update(newValue: .error(reason: error.localizedDescription))
            }
        }
    }
    
    func logout() {
        self.storeDataProvider.clearBBDD()
        self.secureStorage.deleteToken()
    }
}
