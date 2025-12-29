import SwiftUI
import GoogleSignIn
import Foundation

struct LoginView: View {
    @ObservedObject var vm: LoginViewModel
    
    func getGoogleClientID() -> String? {
        guard let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
              let dict = NSDictionary(contentsOfFile: path) as? [String: Any],
              let clientID = dict["GOOGLE_CLIENT_ID"] as? String else {
            print("Brak GOOGLE_CLIENT_ID w Config.plist")
            return nil
        }
        return clientID
    }
    
    func sendGoogleTokenToServer(idToken: String) async throws -> String {
        guard let url = URL(string: "http://localhost:8000/auth/google") else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = ["id_token": idToken]
        request.httpBody = try JSONSerialization.data(withJSONObject: body)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode) else {
            let respText = String(data: data, encoding: .utf8) ?? "Brak odpowiedzi"
            throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: respText])
        }

        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        if let accessToken = json?["access_token"] as? String {
            return accessToken
        } else if let detail = json?["detail"] {
            throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "\(detail)"])
        } else {
            throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Nieoczekiwany format odpowiedzi"])
        }
    }


    
    private func signIn() {
        guard let clientID = getGoogleClientID() else { return }

        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        guard let rootVC = UIApplication.shared
            .connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first?
            .windows
            .first?
            .rootViewController else {
                return
            }

        GIDSignIn.sharedInstance.signIn(
            withPresenting: rootVC
        ) { result, error in

            if let error = error {
                print("Google Sign-In error:", error)
                return
            }

            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString else {
                return
            }

            print("Google ID Token:")
            print(idToken)

            Task {
                do {
                    let token = try await sendGoogleTokenToServer(idToken: idToken)
                    DispatchQueue.main.async {
                        vm.username = token
                        vm.isLoggedIn = true
                    }
                } catch {
                    print("Błąd logowania do serwera:", error.localizedDescription)
                }
            }
        }
    }



    var body: some View {
        VStack(spacing: 20) {
            Text(vm.isRegistering ? "Rejestracja" : "Logowanie")
                .font(.largeTitle)
                .bold()

            TextField("Login", text: $vm.username)
                .textFieldStyle(.roundedBorder)
                .autocapitalization(.none)

            SecureField("Hasło", text: $vm.password)
                .textFieldStyle(.roundedBorder)

            if let error = vm.errorMessage {
                Text(error).foregroundColor(.red)
            }

            if let info = vm.infoMessage {
                Text(info).foregroundColor(.green)
            }

            Button(vm.isRegistering ? "Zarejestruj się" : "Zaloguj się") {
                Task {
                    if vm.isRegistering {
                        await vm.register()
                    } else {
                        await vm.login()
                    }
                }
            }
            .buttonStyle(.borderedProminent)

            Button(vm.isRegistering
                   ? "Masz konto? Zaloguj się"
                   : "Nie masz konta? Zarejestruj się") {
                vm.isRegistering.toggle()
                vm.errorMessage = nil
                vm.infoMessage = nil
            }
            Button {
                signIn()
            } label: {
                HStack {
                    Image(systemName: "g.circle.fill")
                    Text("Zaloguj się przez Google")
                }
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

