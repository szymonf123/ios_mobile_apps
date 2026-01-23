import SwiftUI

struct PaymentResponse: Decodable {
    let status: String
    let message: String
}

struct ContentView: View {
    @State private var blik: String = ""
    @State private var amount: String = ""
    @State private var statusMessage: String = ""
    @State private var isSuccess: Bool = false
    @State private var isLoading: Bool = false

    var body: some View {
        VStack(spacing: 20) {
            Text("Płatność BLIK")
                .font(.largeTitle)
                .bold()

            TextField("Numer BLIK (6 cyfr)", text: $blik)
                .keyboardType(.numberPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            TextField("Kwota", text: $amount)
                .keyboardType(.decimalPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Button {
                sendPayment()
            } label: {
                if isLoading {
                    ProgressView()
                } else {
                    Text("Zapłać")
                        .frame(maxWidth: .infinity)
                }
            }
            .buttonStyle(.borderedProminent)
            .disabled(isLoading)

            if !statusMessage.isEmpty {
                Text(statusMessage)
                    .foregroundColor(isSuccess ? .green : .red)
                    .bold()
            }

            Spacer()
        }
        .padding()
    }

    func sendPayment() {
        guard let amountValue = Double(amount) else {
            statusMessage = "Nieprawidłowa kwota"
            isSuccess = false
            return
        }

        guard let url = URL(string: "http://127.0.0.1:5000/payment") else {
            return
        }

        let payload: [String: Any] = [
            "blik": blik,
            "kwota": amountValue
        ]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: payload)

        isLoading = true

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                isLoading = false
            }

            if let error = error {
                DispatchQueue.main.async {
                    statusMessage = "Błąd sieci: \(error.localizedDescription)"
                    isSuccess = false
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    statusMessage = "Brak danych z serwera"
                    isSuccess = false
                }
                return
            }

            if let decoded = try? JSONDecoder().decode(PaymentResponse.self, from: data) {
                DispatchQueue.main.async {
                    statusMessage = decoded.message
                    isSuccess = decoded.status == "success"
                }
            } else {
                DispatchQueue.main.async {
                    statusMessage = "Nieprawidłowa odpowiedź serwera"
                    isSuccess = false
                }
            }
        }.resume()
    }
}

