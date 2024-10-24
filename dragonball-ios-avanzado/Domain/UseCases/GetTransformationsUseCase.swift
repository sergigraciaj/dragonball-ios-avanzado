import Foundation

protocol GetTransformationsUseCaseContract {
    func execute(id: String, completion: @escaping (Result<[Transformation], Error>) -> Void)
}

final class GetTransformationsUseCase: GetTransformationsUseCaseContract {
    private var storeDataProvider: StoreDataProvider
    
    init(storeDataProvider: StoreDataProvider = .shared) {
        self.storeDataProvider = storeDataProvider
    }
    
    func execute(id: String, completion: @escaping (Result<[Transformation], any Error>) -> Void) {
        guard let hero = self.getHeroWith(id: id) else {
            completion(.failure(APIErrorResponse.heroNotFound(id)))
            return
        }
        
        let bdTransformations = hero.transformations ?? []
        if bdTransformations.isEmpty {
            print("empty tranformations")
            GetTransformationsAPIRequest(id: id)
                .perform { [weak self] result in
                    switch result {
                    case .success:
                        DispatchQueue.main.async {
                            do {
                                let apiTransformations = try result.get()
                                self?.storeDataProvider.add(transformations: apiTransformations)
                                completion(.success(apiTransformations))
                            } catch {
                                completion(.failure(error))
                            }
                        }
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
        } else {
            print("not empty transformation")
            let domainTransformations = bdTransformations.map({Transformation(moTransformation: $0)})
            completion(.success(domainTransformations))
        }
    }
    
    private func getHeroWith(id: String) -> MOHero? {
        let predicate = NSPredicate(format: "id == %@", id)
        let heroes = storeDataProvider.fetchHeroes(filter: predicate)
        return heroes.first
    }
}
