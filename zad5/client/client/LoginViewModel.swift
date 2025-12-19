import Foundation

@MainActor
class LoginViewModel: ObservableObject {
    @Published var username = ""
    @Published var password = ""
    @Published var isLoggedIn = false
    @Published var errorMessage: String?
    @Published var infoMessage: String?
    @Published var isRegistering = false

    private let baseURL = "http://127.0.0.1:8000"

    func login() async {
        await sendRequest(endpoint: "/login")
    }

    func register() async {
        await sendRequest(endpoint: "/register", isRegister: true)
    }

    private func sendRequest(endpoint: String, isRegister: Bool = false) async {
        errorMessage = nil
        infoMessage = nil

        guard let url = URL(string: baseURL + endpoint) else { return }

        let body = RegisterRequest(username: username, password: password)

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(body)

        do {
            let (_, response) = try await URLSession.shared.data(for: request)

            guard let http = response as? HTTPURLResponse else { return }

            if http.statusCode == 200 {
                if isRegister {
                    infoMessage = "Rejestracja udana. Możesz się zalogować."
                    isRegistering = false
                } else {
                    isLoggedIn = true
                }
            } else {
                errorMessage = "Błąd danych do logowania"
            }
        } catch {
            errorMessage = "Błąd połączenia z serwerem"
        }
    }
}
