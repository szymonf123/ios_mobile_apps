//
//  ProductView.swift
//  zad3
//
//  Created by user279406 on 12/8/25.
//

import SwiftUI
import CoreData

struct ProductView: View {
    let product: Product
    var body: some View {
        Text("Produkt")
        VStack(alignment: .leading) {
            Text("Nazwa produktu: ").foregroundStyle(.gray)
            Text(String(product.name ?? "-"))
            
            Text("Cena ").foregroundStyle(.gray)
            Text(String(format: "%.2f PLN", product.price))
            
            Text("Kategoria: ").foregroundStyle(.gray)
            Text(String(product.category?.name ?? "-"))
            
            Text("Opis: ").foregroundStyle(.gray)
            Text(String(product.descr ?? "-"))
        }
    }
}
