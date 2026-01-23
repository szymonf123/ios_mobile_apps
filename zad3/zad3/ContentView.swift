//
//  ContentView.swift
//  zad3
//
//  Created by user279406 on 12/4/25.
//

import SwiftUI
import CoreData

let screenHeight = UIScreen.main.bounds.height

protocol CategoryRepresentable {
    var name_: String { get }
}

protocol ProductRepresentable {
    var name_: String { get }
    var price_: Double { get }
    var descr_: String? { get }
    var category_: CategoryRepresentable? { get }
}

extension Category: CategoryRepresentable {
    var name_: String {
        self.name ?? "-"
    }
}

extension Product: ProductRepresentable {

    var name_: String {
        self.name ?? ""
    }

    var price_: Double {
        Double(self.price)
    }

    var descr_: String? {
        self.descr
    }

    var category_: CategoryRepresentable? {
        self.category
    }
}



class CartManager: ObservableObject {
    @Published var cart: [Product] = []
    
    func addToCart(_ product: Product) {
        cart.append(product)
    }
    
    func cartLength() -> Int {
        return cart.count
    }
}

struct ContentView: View {
    @Environment(\.managedObjectContext) private var context
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Product.name, ascending: true)]
        ) private var products: FetchedResults<Product>
    
    @StateObject var cartManager = CartManager()
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Sklep")
                List {
                    ForEach(products){ product in
                        NavigationLink(destination: ProductView(product: product)){
                            VStack(alignment: .leading){
                                HStack {
                                    Text(product.name ?? "-")
                                    Spacer()
                                    Text(String(format: "%.2f PLN", product.price)).foregroundStyle(.blue)
                                }
                                Text(product.category?.name ?? "-").foregroundStyle(.gray)
                                Button("Dodaj do koszyka") {
                                    cartManager.addToCart(product)
                                }
                                .buttonStyle(.borderless)
                            }
                        }
                    }
                }
                if (cartManager.cartLength() > 0){
                    Text("Koszyk")
                    List {
                        ForEach(Array(cartManager.cart)){ item in
                            Text(item.name ?? "-")
                        }
                    }
                    .frame(height: screenHeight * 0.25)
                }
                //.frame(height: screenHeight * 0.25 / CGFloat(max(cart.count, 1)))
            }
        }
    }
}
