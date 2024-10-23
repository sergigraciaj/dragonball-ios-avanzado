import Foundation

protocol GetLocationsUseCaseContract {
    func execute(id: String, completion: @escaping (Result<[Location], Error>) -> Void)
}

final class GetLocationsUseCase: GetLocationsUseCaseContract {
    private var storeDataProvider: StoreDataProvider
    
    init(storeDataProvider: StoreDataProvider = .shared) {
        self.storeDataProvider = storeDataProvider
    }
    
    func execute(id: String, completion: @escaping (Result<[Location], any Error>) -> Void) {
        guard let hero = self.getHeroWith(id: id) else {
            completion(.failure(APIErrorResponse.heroNotFound(id)))
            return
        }
        
        let bdLocations = hero.locations ?? []
        if bdLocations.isEmpty {
            GetLocationsAPIRequest(id: id)
                .perform { [weak self] result in
                    switch result {
                    case .success:
                        print("success use case")
                        DispatchQueue.main.async {
                            do {
                                let locations = try result.get()
                                self?.storeDataProvider.add(locations: locations)
                                let bdLocations = hero.locations ?? []
                                let domainLocations = bdLocations.map({Location(moLocation: $0)})
                                completion(.success(domainLocations))
                            } catch {
                                completion(.failure(error))
                            }
                        }
                    case .failure(let error):
                        print(error)
                        completion(.failure(error))
                    }
                }
        }
    }
    
    private func getHeroWith(id: String) -> MOHero? {
        let predicate = NSPredicate(format: "id == %@", id)
        let heroes = storeDataProvider.fetchHeroes(filter: predicate)
        return heroes.first
    }
}
