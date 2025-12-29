import SwiftUI
import GoogleSignIn

struct LoginView: View {
    @ObservedObject var vm: LoginViewModel
    
    private func signIn() {
        guard let clientID = Bundle.main.object(
            forInfoDictionaryKey: "GOOGLE_CLIENT_ID"
        ) as? String else {
            print("Brak GOOGLE_CLIENT_ID")
            return
        }

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

