import SwiftUI

struct LoggedInView: View {
    let username: String
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "checkmark.seal.fill")
                .font(.system(size: 80))
                .foregroundColor(.green)

            Text("Zalogowano")
                .font(.title)

            Text("Witaj, " + username + "!")
                .foregroundColor(.gray)
        }
    }
}
