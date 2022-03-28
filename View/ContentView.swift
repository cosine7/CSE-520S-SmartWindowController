//
//  ContentView.swift
//  SmartWindowController
//
//  Created by lcx on 2022/2/22.
//

import SwiftUI
import AWSIoT

struct ContentView: View {
    @StateObject private var window: IoTDevice
    
    init(status: Status) {
        self._window = StateObject(wrappedValue: IoTDevice(status))
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    if window.status.isRaining {
                        getImage("cloud.rain", .blue)
                    } else {
                        getImage("sun.max", .yellow)
                    }
                    
                    Toggle("window1", isOn: $window.isOpen)
                        .onTapGesture {
//                            print(window.isOpen)
//                            window.interrupt()
                            window.publishTopic(!window.isOpen)
                        }
//                    Slider(value: $window.status.windowAngle.animation(), in: 0 ... 90)
//                        .animation(.linear, value: window.status.windowAngle)
                    HStack {
                        Text("Temperature")
                        Spacer()
                        Text("\(window.status.temperature)\u{00B0}C")
                    }
                    HStack {
                        Text("Humidity")
                        Spacer()
                        Text("\(window.status.humidity)%")
                    }
                }
            }
            .navigationTitle("Welcome")
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private func getImage(_ name: String, _ color: Color) -> some View {
        return Image(systemName: name)
            .renderingMode(.template)
            .foregroundColor(color)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(
            status: Status(isRaining: true, temperature: 0, windowAngle: 0, humidity: 0)
        )
    }
}
