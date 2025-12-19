import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)],
        animation: .default)
    private var products: FetchedResults<ProductEntity>
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(key: "id", ascending: true)],
        animation: .default)
    private var cart: FetchedResults<CartEntity>
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(products) { product in
                        VStack(alignment: .leading) {
                            HStack {
                                Text(product.name ?? "-")
                                    .font(.headline)
                                Spacer()
                                Text(String(format: "%.2f PLN", product.price))
                                    .foregroundStyle(.blue)
                            }
                            Text(product.category?.name ?? "-")
                                .foregroundStyle(.gray)
                                .font(.subheadline)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("Produkty")
        }
        NavigationView {
            VStack {
                List {
                    ForEach(cart) { item in
                        VStack(alignment: .leading) {
                            HStack {
                                Text(item.product?.name ?? "-")
                                    .font(.headline)
                                Spacer()
                                Text(String(format: "%d szt.", item.quantity))
                                    .foregroundStyle(.blue)
                            }
                            Text("\(item.phone_number ?? "-") | \(item.address ?? "-")")
                                .foregroundStyle(.gray)
                                .font(.subheadline)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("Zamowienia")
        }
    }
}

#Preview {
    ContentView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}

