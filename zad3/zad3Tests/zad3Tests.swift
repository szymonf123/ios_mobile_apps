import XCTest
import SwiftUI
import CoreData
@testable import zad3

struct CategoryMock: CategoryRepresentable {
    let name_: String
}


class ProductMock: ProductRepresentable {
    let name_: String
    let price_: Double
    let descr_: String?
    let category_: CategoryRepresentable?

    init(
        name_: String,
        price_: Double,
        descr_: String?,
        category_: CategoryRepresentable?
    ) {
        self.name_ = name_
        self.price_ = price_
        self.descr_ = descr_
        self.category_ = category_
    }
}


class CartManager {
    var cart: [ProductMock] = []
    func addToCart(_ product: ProductMock) {
        cart.append(product)
    }
}

struct Fixtures {
    static let categoryFruit = CategoryMock(name_: "Owoce")
    static let categoryDairy = CategoryMock(name_: "Nabiał")

    static let productsFixture: [ProductMock] = [
        ProductMock(name_: "Banan", price_: 6.99, descr_: "Świeże banany", category_: categoryFruit),
        ProductMock(name_: "Jabłko", price_: 4.99, descr_: "Czerwone jabłko", category_: categoryFruit),
        ProductMock(name_: "Mleko", price_: 6.50, descr_: "Mleko od krowy", category_: categoryDairy),
        ProductMock(name_: "Jogurt", price_: 3.99, descr_: "Jogurt naturalny", category_: categoryDairy)
    ]
}

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
    
    func testAddingProductToCart() throws {
        let cartManager = CartManager()
            
        for product in Fixtures.productsFixture {
            cartManager.addToCart(product)
        }
            
        XCTAssertEqual(cartManager.cart.count, Fixtures.productsFixture.count)
        for i in 0..<Fixtures.productsFixture.count{
            XCTAssertEqual(cartManager.cart[i].name_, Fixtures.productsFixture[i].name_)
            XCTAssertEqual(cartManager.cart[i].price_, Fixtures.productsFixture[i].price_)
            XCTAssertEqual(cartManager.cart[i].category_?.name_, Fixtures.productsFixture[i].category_?.name_)
        }
        
    }
    
    func testProductViewInitialization() throws {
        for i in 0..<2 {
            let product = Fixtures.productsFixture[i]
            let productView = ProductView(product: product)
            
            XCTAssertEqual(productView.product.name_, Fixtures.productsFixture[i].name_)
            XCTAssertEqual(productView.product.price_, Fixtures.productsFixture[i].price_)
            XCTAssertEqual(productView.product.descr_, Fixtures.productsFixture[i].descr_)
            XCTAssertEqual(productView.product.category_?.name_, Fixtures.productsFixture[i].category_?.name_)
        }
    }



}

