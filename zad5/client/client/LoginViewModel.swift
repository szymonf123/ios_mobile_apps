import Foundation

@MainActor
class LoginViewModel: ObservableObject {
    @Published var username = ""
    @Published var password = ""
    @Published var isLoggedIn = false
    @Published var errorMessage: String?

    private let loginURL = URL(string: "http://127.0.0.1:8000/login")!

    func login() async {
        errorMessage = nil

        let requestBody = LoginRequest(username: username, password: password)

        var request = URLRequest(url: loginURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(requestBody)

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                errorMessage = "Nieprawidłowe dane logowania"
                return
            }

            let decoded = try JSONDecoder().decode(LoginResponse.self, from: data)

            UserDefaults.standard.set(decoded.access_token, forKey: "jwt")

            isLoggedIn = true
        } catch {
            errorMessage = "Błąd połączenia z serwerem"
        }
    }
}

