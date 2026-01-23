import SwiftUI

struct PaymentResponse: Decodable {
    let status: String
    let message: String
}

struct Product: Decodable, Identifiable {
    let id = UUID()
    let product: String
    let amount: Double
}

struct ContentView: View {
    @State private var blik = ""
    @State private var amount = ""
    @State private var productName = ""

    @State private var statusMessage = ""
    @State private var isSuccess = false
    @State private var isLoading = false

    @State private var products: [Product] = []

    var body: some View {
        NavigationView {
            VStack(spacing: 16) {

                Form {
                    Section(header: Text("Płatność")) {
                        TextField("Produkt", text: $productName)
                        TextField("Numer BLIK", text: $blik)
                            .keyboardType(.numberPad)
                        TextField("Kwota", text: $amount)
                            .keyboardType(.decimalPad)

                        Button("Zapłać") {
                            sendPayment()
                        }
                        .disabled(isLoading)
                    }

                    if !statusMessage.isEmpty {
                        Text(statusMessage)
                            .foregroundColor(isSuccess ? .green : .red)
                            .bold()
                    }

                    Section(header: Text("Zakupione produkty")) {
                        if products.isEmpty {
                            Text("Brak zakupów")
                                .foregroundColor(.secondary)
                        } else {
                            ForEach(products) { product in
                                HStack {
                                    Text(product.product)
                                    Spacer()
                                    Text(String(format: "%.2f zł", product.amount))
                                        .bold()
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("BLIK Shop")
            .onAppear {
                fetchProducts()
            }
        }
    }

    func sendPayment() {
        guard let amountValue = Double(amount) else {
            statusMessage = "Nieprawidłowa kwota"
            isSuccess = false
            return
        }

        let url = URL(string: "http://127.0.0.1:5000/payment")!
        let payload: [String: Any] = [
            "blik": blik,
            "kwota": amountValue,
            "product": productName
        ]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: payload)

        isLoading = true

        URLSession.shared.dataTask(with: request) { data, _, error in
            DispatchQueue.main.async {
                isLoading = false
            }

            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    statusMessage = "Błąd połączenia"
                    isSuccess = false
                }
                return
            }

            if let response = try? JSONDecoder().decode(PaymentResponse.self, from: data) {
                DispatchQueue.main.async {
                    statusMessage = response.message
                    isSuccess = response.status == "success"

                    if isSuccess {
                        fetchProducts()
                        clearForm()
                    }
                }
            }
        }.resume()
    }

    func fetchProducts() {
        let url = URL(string: "http://127.0.0.1:5000/products")!

        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { return }

            if let decoded = try? JSONDecoder().decode([Product].self, from: data) {
                DispatchQueue.main.async {
                    products = decoded
                }
            }
        }.resume()
    }

    func clearForm() {
        blik = ""
        amount = ""
        productName = ""
    }
}

