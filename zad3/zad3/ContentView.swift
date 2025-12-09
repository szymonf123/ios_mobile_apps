//
//  ContentView.swift
//  zad3
//
//  Created by user279406 on 12/4/25.
//

import SwiftUI
import CoreData

let screenHeight = UIScreen.main.bounds.height

struct ContentView: View {
    @Environment(\.managedObjectContext) private var context
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Product.name, ascending: true)]
        ) private var products: FetchedResults<Product>
    
    @State private var cart = [Product]()
    
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
                                    cart.append(product)
                                }
                                .buttonStyle(.borderless)
                            }
                        }
                    }
                }
                if (cart.count > 0){
                    Text("Koszyk")
                    List {
                        ForEach(Array(cart)){ item in
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
