import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)],
        animation: .default)
    private var categories: FetchedResults<CategoryEntity>

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)],
        animation: .default)
    private var products: FetchedResults<ProductEntity>

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(key: "id", ascending: true)],
        animation: .default)
    private var cart: FetchedResults<CartEntity>
    
    @State var new_product_name: String = ""
    @State var new_product_price: String = ""
    @State var selected_category: CategoryEntity?

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Kategorie")) {
                    ForEach(categories) { category in
                        Text(category.name ?? "-")
                            .font(.headline)
                    }
                }
                Section(header: Text("Produkty")) {
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
                Section(header: Text("Dodaj produkt")){
                    Text("Nazwa:")
                    TextField("Nazwa", text: $new_product_name)
                        .foregroundStyle(.gray)
                    Text("Cena:")
                    TextField("Cena", text: $new_product_price)
                        .foregroundStyle(.gray)
                        .keyboardType(.decimalPad)
                    Text("Kategoria:")
                    Picker("Kategoria", selection: $selected_category){
                        Text("Wybierz kategorie")
                            .tag(nil as CategoryEntity?)
                        ForEach(categories) { category in
                            Text(category.name ?? "-")
                                .tag(category as CategoryEntity?)
                        }
                        .pickerStyle(.menu)
                    }
                    Button("Dodaj"){
                        post_d
                    }
                }
                Section(header: Text("Zamówienia")) {
                    ForEach(cart) { item in
                        VStack(alignment: .leading) {
                            HStack {
                                Text(item.product?.name ?? "-")
                                    .font(.headline)
                                Spacer()
                                Text("\(item.quantity) szt.")
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
            .navigationTitle("Sklep")
        }
    }
}
