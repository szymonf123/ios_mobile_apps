import SwiftUI
import CoreData
import Foundation

struct Category: Codable {
    let id: Int
    let name: String
}

struct Product: Codable {
    let id: Int
    let name: String
    let category_id: Int
    let price: Double
}

func fetch<T: Decodable>(url: String, type: T.Type) async throws -> T {
    let url = URL(string: url)!
    let (data, _) = try await URLSession.shared.data(from: url)
    return try JSONDecoder().decode(T.self, from: data)
}

@main
struct appApp: App {
    
    func clearCoreData() {
        let productRequest: NSFetchRequest<NSFetchRequestResult> = ProductEntity.fetchRequest()
        let productDelete = NSBatchDeleteRequest(fetchRequest: productRequest)
        
        let categoryRequest: NSFetchRequest<NSFetchRequestResult> = CategoryEntity.fetchRequest()
        let categoryDelete = NSBatchDeleteRequest(fetchRequest: categoryRequest)
        
        do {
            try context.execute(productDelete)
            try context.execute(categoryDelete)
            try context.save()
            print("Core Data wyczyszczone")
        } catch {
            print("Błąd czyszczenia Core Data:", error)
        }
    }

    let persistenceController = PersistenceController.shared
    let context: NSManagedObjectContext
    
    init() {
        context = persistenceController.container.viewContext
    }
    
    func saveCategories(_ categories: [Category], context: NSManagedObjectContext) {
        
        
        do {
            try context.save()
        } catch {
            print("Błąd:", error)
        }
    }

    func saveProducts(_ products: [Product], context: NSManagedObjectContext) {
        
        
        do {
            try context.save()
        } catch {
            print("Błąd:", error)
        }
    }
    
    func fetchAndSaveData() async {
        do {
            if (try context.count(for: ProductEntity.fetchRequest()) > 0){
                return
            }
            let categories: [Category] = try await fetch(
                url: "http://127.0.0.1:5000/categories",
                type: [Category].self
            )
            
            var categoryMap: [Int64: CategoryEntity] = [:]
            for c in categories {
                let entity = CategoryEntity(context: context)
                entity.id = Int64(c.id)
                entity.name = c.name
                categoryMap[Int64(c.id)] = entity
            }
            
            let products: [Product] = try await fetch(
                url: "http://127.0.0.1:5000/products",
                type: [Product].self
            )
            
            for p in products {
                let entity = ProductEntity(context: context)
                entity.id = Int64(p.id)
                entity.name = p.name
                entity.price = p.price
                if let categoryEntity = categoryMap[Int64(p.category_id)] {
                    entity.category = categoryEntity
                }
            }
            
        } catch {
            print("Błąd fetch:", error)
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, context)
                .task {
                    //clearCoreData()
                    await fetchAndSaveData()
                }
        }
    }
}

