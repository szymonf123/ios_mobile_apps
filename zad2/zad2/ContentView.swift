//
//  ContentView.swift
//  zad2
//
//  Created by user279406 on 11/29/25.
//

import SwiftUI

struct TaskItem: Identifiable {
    let id = UUID()
    var name: String
    var done: Bool
}
struct ContentView: View {
    @State private var tasks = [
            TaskItem(name: "Iść do okulisty zbadać tęczówkę", done: false),
            TaskItem(name: "Zrobić odcisk palca do wizy", done: false),
            TaskItem(name: "Iść na wykład o starożytnych Chinach", done: false),
            TaskItem(name: "Przygotować referat na za tydzień", done: false)
        ]
    var body: some View {
        VStack {
            
            Text("Lista rozmaitych zadań")
            List {
                ForEach(tasks.indices, id: \.self) { index in
                    HStack {
                        Toggle(isOn: $tasks[index].done) {
                            Label(tasks[index].name, systemImage: "t.circle")
                            }
                        Button("X") {
                            tasks.remove(at: index)
                        }
                    }
                }
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
