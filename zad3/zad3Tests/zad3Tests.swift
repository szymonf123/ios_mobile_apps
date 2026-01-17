import XCTest
import SwiftUI
import CoreData
@testable import zad3

final class ContentViewTests: XCTestCase {
    
    var persistenceController: NSPersistentContainer!
    var context: NSManagedObjectContext!
    var host: UIHostingController<AnyView>!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        persistenceController = NSPersistentContainer(name: "zad3")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        persistenceController.persistentStoreDescriptions = [description]
        
        persistenceController.loadPersistentStores { storeDescription, error in
            if let error = error {
                fatalError("Failed to load store: \(error)")
            }
        }
        
        context = persistenceController.viewContext
        
        let fruits = Category(context: context)
        fruits.name = "Owoce"
        
        let vegetables = Category(context: context)
        vegetables.name = "Warzywa"
        
        let dairy = Category(context: context)
        dairy.name = "Nabial"
        
        let product1 = Product(context: context)
        product1.name = "Banan"
        product1.price = 6.99
        product1.category = fruits
        
        let product2 = Product(context: context)
        product2.name = "Jablko"
        product2.price = 4.99
        product2.category = fruits
        
        let product3 = Product(context: context)
        product3.name = "Jogurt"
        product3.price = 6.99
        product3.category = dairy
        
        let product4 = Product(context: context)
        product4.name = "Mleko"
        product4.price = 6.99
        product4.category = dairy
        
        let product5 = Product(context: context)
        product5.name = "Ziemniak"
        product5.price = 1.99
        product5.category = vegetables
        
        try context.save()
        
        host = UIHostingController(rootView: AnyView(ContentView().environment(\.managedObjectContext, context)))
        _ = host.view

    }
    
    override func tearDownWithError() throws {
        host = nil
        context = nil
        persistenceController = nil
        try super.tearDownWithError()
    }
    
    func testProductsLoadedFromFixtures() throws {
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        let fetchedProducts = try context.fetch(fetchRequest)
        
        XCTAssertEqual(fetchedProducts.count, 5, "5 products should be loaded")
        
        XCTAssertTrue(fetchedProducts.contains(where: { $0.name == "Jablko"  && $0.price == 4.99 }))
        XCTAssertTrue(fetchedProducts.contains(where: { $0.name == "Ziemniak" && $0.price == 1.99 }))
        XCTAssertTrue(fetchedProducts.contains(where: { $0.name == "Mleko" && $0.price == 6.99 }))
        XCTAssertTrue(fetchedProducts.contains(where: { $0.name == "Jogurt" && $0.price == 6.99 }))
        XCTAssertTrue(fetchedProducts.contains(where: { $0.name == "Banan" && $0.price == 6.99 }))
        
    }
    
    func testAddingProductToCart() throws {
        let cartManager = CartManager()
        
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        let products = try context.fetch(fetchRequest)
        guard let firstProduct = products.first else {
            XCTFail("No products available")
            return
        }
        
        cartManager.addToCart(firstProduct)
        
        XCTAssertEqual(cartManager.cart.count, 1)
        XCTAssertEqual(cartManager.cart.first?.name, firstProduct.name)
    }
    
    func testAddingMoreProductsToCart() throws {
        let cartManager = CartManager()
        
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        let products = try context.fetch(fetchRequest)
        guard let firstProduct = products.first else {
            XCTFail("No products available")
            return
        }
        let thirdProduct = products[2]
        
        cartManager.addToCart(firstProduct)
        
        XCTAssertEqual(cartManager.cart.count, 1)
        XCTAssertEqual(cartManager.cart.first?.name, firstProduct.name)
        
        cartManager.addToCart(thirdProduct)
        
        XCTAssertEqual(cartManager.cart.count, 2)
        XCTAssertEqual(cartManager.cart[1].name, thirdProduct.name)
        
        cartManager.addToCart(firstProduct)
        
        XCTAssertEqual(cartManager.cart.count, 3)
        XCTAssertEqual(cartManager.cart[2].name, firstProduct.name)
    }
    
    func testProductViewInitialization() throws {
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        let products = try context.fetch(fetchRequest)
        
        guard let firstProduct = products.first else {
            XCTFail("No products available")
            return
        }
        
        var productView = ProductView(product: firstProduct)
        
        XCTAssertEqual(productView.product.name, firstProduct.name)
        XCTAssertEqual(productView.product.price, firstProduct.price)
        XCTAssertEqual(productView.product.category?.name, firstProduct.category?.name)
        
        let fourthProduct = products[3]
        productView = ProductView(product: fourthProduct)
        
        XCTAssertEqual(productView.product.name, fourthProduct.name)
        XCTAssertEqual(productView.product.price, fourthProduct.price)
        XCTAssertEqual(productView.product.category?.name, fourthProduct.category?.name)
    }


}

