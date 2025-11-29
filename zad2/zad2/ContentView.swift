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
        TaskItem(name: "Iść do okulisty", done: false),
        TaskItem(name: "Zrobić odcisk palca do wizy", done: false),
        TaskItem(name: "Iść na wykład o starożytnych Chinach", done: false),
        TaskItem(name: "Przygotować referat na za tydzień", done: false)
    ]
    @State private var taskBeingEdited: TaskItem?
    @State private var newName: String = ""
    
    var body: some View {
        VStack {
            
            Text("Lista zadań")
            List {
                ForEach(Array($tasks.enumerated()), id: \.element.id) { index, $task in
                    HStack {
                        Toggle(isOn: $task.done){
                            Label{
                                Text(task.name)
                                    .foregroundStyle( task.done ? Color.gray.opacity(0.3) : .primary)
                            }
                            icon: {
                                Image(systemName: "\(index + 1).circle")
                            }
                        }
                        Spacer()
                        
                        Button(action: {
                            taskBeingEdited = task
                            newName = task.name
                        }){
                            Image(systemName: "pencil.circle")
                                .font(.title2)
                        }
                        .buttonStyle(.borderless)
                        .padding(.leading, 10)
                        
                        Button(action: {
                            tasks.removeAll { $0.id == task.id }
                        }) {
                            Image(systemName: "x.circle")
                                .font(.title2)
                        }
                        .buttonStyle(.borderless)
                        .padding(.leading, 10)
                    }
                }
                
            }
            
        }
        .padding()
        .sheet(item: $taskBeingEdited) { task in
            VStack(spacing: 20) {
                Text("Edytuj zadanie").font(.headline)
                
                TextField("Nowa nazwa", text: $newName)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                
                Button("Zapisz") {
                    if let index = tasks.firstIndex(where: { $0.id == task.id }) {
                                    tasks[index].name = newName
                                }
                                taskBeingEdited = nil
                }
                
                Button("Anuluj") {
                    taskBeingEdited = nil
                }
                .foregroundColor(.red)
            }
            .padding()
        }
    }
}
#Preview {
    ContentView()
}
