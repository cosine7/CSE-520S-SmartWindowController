//
//  SmartWindowControllerApp.swift
//  SmartWindowController
//
//  Created by lcx on 2022/2/22.
//

import SwiftUI

@main
struct SmartWindowControllerApp: App {
    @StateObject var iotSetup = IoTSetup()
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                if iotSetup.done {
                    ContentView(status: iotSetup.status)
                }
                Spinner(done: $iotSetup.done).zIndex(999)
            }
        }
    }
}
