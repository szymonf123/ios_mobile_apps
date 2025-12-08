//
//  Persistence.swift
//  zad3
//
//  Created by user279406 on 12/4/25.
//

import CoreData
import Foundation

struct PersistenceController {
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false){
        let container = NSPersistentContainer(name: "zad3")

        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unresolved error: \(error)")
            }
            
            let context = container.viewContext
            if !UserDefaults.standard.bool(forKey: "didLoadFixtures") {
                Self.loadFixtures(context: context)
            }
        }

        self.container = container
        container.viewContext.automaticallyMergesChangesFromParent = true
    }

    
    static func loadFixtures(context: NSManagedObjectContext){
        let fruits = Category(context: context)
        fruits.name = "Owoce"
        
        let vegetables = Category(context: context)
        vegetables.name = "Warzywa"
        
        let dairy = Category(context: context)
        dairy.name = "Nabial"
        
        let apple = Product(context: context)
        apple.name = "Jablko"
        apple.price = 4.99
        apple.descr = "Swieze, polskie jablka prosto z Lacka"
        apple.category = fruits
        
        let banana = Product(context: context)
        banana.name = "Banan"
        banana.price = 6.99
        banana.descr = "Najsmaczniejsze banany tylko u nas"
        banana.category = fruits
        
        let potato = Product(context: context)
        potato.name = "Ziemniak"
        potato.price = 1.99
        potato.descr = "Ziemniaki polskie z ekologicznych upraw"
        potato.category = vegetables
        
        let milk = Product(context: context)
        milk.name = "Mleko"
        milk.price = 6.99
        milk.descr = "Odtluszczone mleko bez laktozy"
        milk.category = dairy
        
        let yogurt = Product(context: context)
        yogurt.name = "Jogurt"
        yogurt.price = 6.99
        yogurt.descr = "Pyszne jogurty w rozmaitych smakach"
        yogurt.category = dairy
        
        do {
            try context.save()
            UserDefaults.standard.set(true, forKey: "didLoadFixtures")
            print("Loaded")
        }
        catch {
            print("Error loading")
        }
    }
}
