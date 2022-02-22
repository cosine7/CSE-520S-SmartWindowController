//
//  ContentView.swift
//  SmartWindowController
//
//  Created by lcx on 2022/2/22.
//

import SwiftUI

struct ContentView: View {
    @State private var isOn = true
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    HStack {
                        Toggle(isOn: $isOn) {
                            Text("window1")
                        }
                    }
                }
            }.navigationTitle("Welcome")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
