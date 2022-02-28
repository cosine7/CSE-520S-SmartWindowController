//
//  SmartWindowControllerApp.swift
//  SmartWindowController
//
//  Created by lcx on 2022/2/22.
//

import SwiftUI

//class Pre: ObservableObject {
//    @Published var showView = false
//
//    init() {
//        delay()
//    }
//
//    private func delay() {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 15) {
//            self.showView = true
//        }
//    }
//
//}

@main
struct SmartWindowControllerApp: App {
//    @StateObject var p = Pre()
    
    var body: some Scene {
        WindowGroup {
//            if p.showView {
//                ContentView()
//            }
            ContentView()

        }
    }
}
