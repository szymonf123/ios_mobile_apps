import SwiftUI

struct LoginView: View {
    @ObservedObject var vm: LoginViewModel

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
        }
        .padding()
    }
}

