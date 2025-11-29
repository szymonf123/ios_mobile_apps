//
//  ContentView.swift
//  zad2
//
//  Created by user279406 on 11/29/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            
            Text("Lista rozmaitych zadan")
            List {
                Toggle(isOn: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Is On@*/.constant(true)/*@END_MENU_TOKEN@*/) {
                    Label("Isc do okulisty zbadac teczowke", systemImage: "t.circle")
                }
                Toggle(isOn: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Is On@*/.constant(true)/*@END_MENU_TOKEN@*/) {
                    Label("Zrobic odcisk palca do wizy", systemImage: "t.circle")
                }
                Toggle(isOn: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Is On@*/.constant(true)/*@END_MENU_TOKEN@*/) {
                    Label("Isc na wyklad o starozytnych Chinach", systemImage: "t.circle")
                }
                Toggle(isOn: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Is On@*/.constant(true)/*@END_MENU_TOKEN@*/) {
                    Label("Przygotowac referat na za tydzien", systemImage: "t.circle")
                }            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
