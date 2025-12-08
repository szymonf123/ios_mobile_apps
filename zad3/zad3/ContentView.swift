//
//  ContentView.swift
//  zad3
//
//  Created by user279406 on 12/4/25.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var context
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Product.name, ascending: true)]
        ) private var products: FetchedResults<Product>
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
                            }
                        }
                    }
                }
            }
        }
    }
}
