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
                        .onTapGesture {
                            print(window.isOpen)
//                            window.interrupt()
                            window.publishTopic(!window.isOpen)
                        }
                    Slider(value: $window.status.windowAngle.animation(), in: 0 ... 90)
                        .animation(.linear, value: window.status.windowAngle)
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
