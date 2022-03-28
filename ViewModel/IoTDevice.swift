//
//  IOT.swift
//  SmartWindowController
//
//  Created by lcx on 2022/2/23.
//

import Foundation
import AWSIoT

class IoTDevice: ObservableObject {
    @Published var isOpen: Bool
    @Published var status: Status
    
    private let iotDataManager = AWSIoTDataManager(forKey: "MyAWSIoTDataManager")
    
    init(_ status: Status) {
        self.status = status
        self.isOpen = status.windowAngle > 0
        //        iotDataManager.subscribe(toTopic: "smart_window", qoS: .messageDeliveryAttemptedAtMostOnce) {
        //            payload in
        //            guard let status = try? JSONDecoder().decode(Status.self, from: payload) else {
        //                return
        //            }
        //            DispatchQueue.main.async {
        //                self.status = status
        ////                self.isOpen = status.windowAngle > 0
        //                self.temperature = "\(status.temperature)\u{00B0}C"
        //
        //            }
        //        }
    }
    
    func publishTopic(_ needOpen: Bool) {
        guard let data = try? JSONSerialization.data(withJSONObject: ["needOpen": needOpen]),
              let message = String(data: data, encoding: .utf8)
        else {
            return
        }
        iotDataManager.publishString(
            message,
            onTopic: "remote_control",
            qoS:.messageDeliveryAttemptedAtMostOnce
        )
    }
}
