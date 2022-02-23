//
//  ContentView.swift
//  SmartWindowController
//
//  Created by lcx on 2022/2/22.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var window = IoTDevice()

    var body: some View {
        NavigationView {
            Form {
                Section {
                    Toggle("window1", isOn: $window.isOpen)
                }
            }
            .navigationTitle("Welcome")
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
