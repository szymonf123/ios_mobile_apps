import SwiftUI
import GoogleSignIn

@main
struct clientApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject private var vm = LoginViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView(vm: vm)
                .environment(\.managedObjectContext,
                              persistenceController.container.viewContext)
                .onOpenURL { url in
                    if GIDSignIn.sharedInstance.handle(url) {
                        return
                    }
                    handleGitHubCallback(url: url)
                }
        }
    }

    private func handleGitHubCallback(url: URL) {
        guard
            url.scheme == "myapp",
            url.host == "oauth",
            let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
            let code = components.queryItems?
                .first(where: { $0.name == "code" })?.value
        else { return }

        Task {
            await vm.loginWithGitHub(code: code)
        }
    }
}

