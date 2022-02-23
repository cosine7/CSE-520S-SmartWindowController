//
//  ContentView.swift
//  SmartWindowController
//
//  Created by lcx on 2022/2/22.
//

import SwiftUI
import AWSIoT
import Amplify
import AWSMobileClient
import AmplifyPlugins

struct ContentView: View {
    @State private var isOn = true
    @StateObject private var iot = IOT()

    var body: some View {
        NavigationView {
            Form {
                Section {
                    Toggle(isOn: $isOn) {
                        Text("window1")
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
