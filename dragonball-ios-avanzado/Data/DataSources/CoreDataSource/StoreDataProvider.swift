import CoreData

enum TypePersistency {
    case disk
    case inMemory
}

class StoreDataProvider {
    
    static var shared: StoreDataProvider = .init()
    
    static var managedModel: NSManagedObjectModel = {
        let bundle = Bundle(for: StoreDataProvider.self)
        guard let url = bundle.url(forResource: "Model", withExtension: "momd"),
              let model = NSManagedObjectModel(contentsOf: url) else {
            fatalError("Error loading model")
        }
        return model
    }()
    
    private let persistentContainer: NSPersistentContainer
    private let persistency: TypePersistency
    
    private var context: NSManagedObjectContext {
        let viewContext = persistentContainer.viewContext
        viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        return viewContext
    }
    
    init(persistency: TypePersistency = .disk) {
        self.persistency = persistency
        self.persistentContainer = NSPersistentContainer(name: "Model", managedObjectModel: Self.managedModel)
        if self.persistency == .inMemory {
            let persistentStore = persistentContainer.persistentStoreDescriptions.first
            persistentStore?.url = URL(filePath: "/dev/null")
        }
        self.persistentContainer.loadPersistentStores { _, error in
            if let error {
                fatalError("Error loading BBDD \(error.localizedDescription)")
            }
        }
    }
    
    func perform<T: NSFetchRequestResult>(request: NSFetchRequest<T>) throws -> [T] {
        return try context.fetch(request)
    }
    
    func save() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                debugPrint("Errro saving context \(error.localizedDescription)")
            }
        }
    }
}

extension StoreDataProvider {
    func fetchHeroes(filter: NSPredicate?, sortAscending: Bool = true) -> [MOHero] {
        let request = MOHero.fetchRequest()
        request.predicate = filter
        let sortDescriptor = NSSortDescriptor(keyPath: \MOHero.name, ascending: sortAscending)
        request.sortDescriptors = [sortDescriptor]
        
        do {
            return try self.perform(request: request)
        } catch {
            debugPrint("Error loading heroes \(error.localizedDescription)")
            return []
        }
    }
    
    func add(heroes: [Hero], location: [Location] = []) {
        for hero in heroes {
            let newHero = MOHero(context: context)
            newHero.id = hero.id
            newHero.name = hero.name
            newHero.info = hero.info
            // newHero.favorite = hero.favorite ?? false
            newHero.photo = hero.photo
        }
        save()
    }
    
    func add(locations: [Location]) {
        for location in locations {
            let newLocation = MOLocation(context: context)
            newLocation.id = location.id
            newLocation.latitude = location.latitude
            newLocation.longitude = location.longitude
            newLocation.date = location.date

            save()
        }
    }
    
    func add(transformations: [Transformation]) {
        for transformation in transformations {
            let newTransformation = MOTransformation(context: context)
            newTransformation.id = transformation.id
            newTransformation.name = transformation.name
            newTransformation.info = transformation.info
            newTransformation.photo = transformation.photo
        }
    }
    
    func clearBBDD() {
        let batchDeleteHeroes = NSBatchDeleteRequest(fetchRequest: MOHero.fetchRequest())
        let batchDeleteLocations = NSBatchDeleteRequest(fetchRequest: MOLocation.fetchRequest())
        /*
        let batchDeleteTransformations = NSBatchDeleteRequest(fetchRequest: MOTransformation.fetchRequest())
        
        let deleteTasks = [batchDeleteHeroes, batchDeleteLocations, batchDeleteTransformations]
        */
        
        let deleteTasks = [batchDeleteHeroes, batchDeleteLocations]
        
        for task in deleteTasks {
            do {
                try context.execute(task)
                context.reset()
            } catch {
                debugPrint("Error clearing BBDD \(error.localizedDescription)")
            }
        }
        
    }
}
