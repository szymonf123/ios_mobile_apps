import SwiftUI

struct LoginView: View {
    @ObservedObject var vm: LoginViewModel

    var body: some View {
        VStack(spacing: 20) {
            Text("Logowanie")
                .font(.largeTitle)
                .bold()

            TextField("Login", text: $vm.username)
                .textFieldStyle(.roundedBorder)
                .autocapitalization(.none)

            SecureField("Hasło", text: $vm.password)
                .textFieldStyle(.roundedBorder)

            if let error = vm.errorMessage {
                Text(error)
                    .foregroundColor(.red)
            }

            Button("Zaloguj się") {
                Task {
                    await vm.login()
                }
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}
