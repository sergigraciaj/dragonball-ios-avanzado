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
            print("empty locations")
            GetLocationsAPIRequest(id: id)
                .perform { [weak self] result in
                    switch result {
                    case .success:
                        DispatchQueue.main.async {
                            do {
                                let apiLocations = try result.get()
                                self?.storeDataProvider.add(locations: apiLocations)
                                completion(.success(apiLocations))
                            } catch {
                                completion(.failure(error))
                            }
                        }
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
        } else {
            print("not empty locations")
            let domainLocations = bdLocations.map({Location(moLocation: $0)})
            completion(.success(domainLocations))
        }
    }
    
    private func getHeroWith(id: String) -> MOHero? {
        let predicate = NSPredicate(format: "id == %@", id)
        let heroes = storeDataProvider.fetchHeroes(filter: predicate)
        return heroes.first
    }
}
