import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        // Create new user for preview
        let previewUser = User(context: viewContext)
        previewUser.email = "preview@example.com"
        previewUser.password = "password"
        // Create new shopping items for preview for preview and associate them with the user
        for _ in 0..<10 {
            let newItem = ShoppingItem(context: viewContext)
            newItem.name = "Sample Item"
            newItem.isChecked = false
            newItem.category = "sample category"
//            newItem.user = previewUser
        }
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Shopping_List")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        } else {
            let storeDescription = NSPersistentStoreDescription()
            
            // Enable Lightweight Migration
            storeDescription.shouldMigrateStoreAutomatically = true
            storeDescription.shouldInferMappingModelAutomatically = true
            
            container.persistentStoreDescriptions = [storeDescription]
        }

        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Handle the error appropriately in a shipping application
//                fatalError("Unresolved error \(error), \(error.userInfo)")
                print("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
}
