//
//  ProductView.swift
//  zad3
//
//  Created by user279406 on 12/8/25.
//

import SwiftUI
import CoreData

struct ProductView: View {
    let product: ProductRepresentable
    var body: some View {
        Text("Produkt")
        VStack(alignment: .leading) {
            Text("Nazwa produktu: ").foregroundStyle(.gray)
            Text(String(product.name_))
            
            Text("Cena ").foregroundStyle(.gray)
            Text(String(format: "%.2f PLN", product.price_))
            
            Text("Kategoria: ").foregroundStyle(.gray)
            Text(String(product.category_?.name_ ?? "-"))
            
            Text("Opis: ").foregroundStyle(.gray)
            Text(String(product.descr_ ?? "-"))
        }
    }
}
