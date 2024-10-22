import Foundation

protocol GetAllHeroesUseCaseContract {
    func execute(filter: NSPredicate?, completion: @escaping (Result<[Hero], Error>) -> Void)
}

final class GetAllHeroesUseCase: GetAllHeroesUseCaseContract {
    private var storeDataProvider: StoreDataProvider
    
    init(storeDataProvider: StoreDataProvider = .shared) {
        self.storeDataProvider = storeDataProvider
    }
    
    func execute(filter: NSPredicate?, completion: @escaping (Result<[Hero], any Error>) -> Void) {
        let localHeroes = storeDataProvider.fetchHeroes(filter: filter)
        
        if localHeroes.isEmpty {
            print("call api")
            GetHeroesAPIRequest(name: "")
                .perform { [weak self] result in
                    switch result {
                        case .success:
                            DispatchQueue.main.async {
                                do {
                                    let apiHeros = try result.get()
                                    self?.storeDataProvider.add(heroes: apiHeros)
                                    let bdHeroes = self?.storeDataProvider.fetchHeroes(filter: filter) ?? []
                                    let heroes = bdHeroes.map({Hero(moHero: $0)})
                                    completion(.success(heroes))
                                } catch {
                                    completion(.failure(error))
                                }
                            }
                        case .failure(let error):
                            completion(.failure(error))
                    }
                }
        }   else {
            print("call core data")
            let heroes = localHeroes.map({Hero(moHero: $0)})
            completion(.success(heroes))
        }
    }
}
