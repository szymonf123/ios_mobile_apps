import SwiftUI

struct ContentView: View {
    @ObservedObject var vm: LoginViewModel

    var body: some View {
        if vm.isLoggedIn {
            LoggedInView(username: vm.username)
        } else {
            LoginView(vm: vm)
        }
    }
}
