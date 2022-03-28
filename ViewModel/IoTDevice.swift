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
    private var isPublishing = false
    
    private let iotDataManager = AWSIoTDataManager(forKey: "MyAWSIoTDataManager")
    
    init(_ status: Status) {
        self.status = status
        self.isOpen = status.windowAngle > 0
        
        iotDataManager.subscribe(toTopic: "boardcast", qoS: .messageDeliveryAttemptedAtMostOnce) {
            guard !self.isPublishing,
                  let status = try? JSONDecoder().decode(Status.self, from: $0)
            else {
                return
            }
            DispatchQueue.main.async {
                self.status.temperature = status.temperature
                self.status.humidity = status.humidity
                self.status.isRaining = status.isRaining
                self.isOpen = status.windowAngle > 0
            }
        }
        iotDataManager.subscribe(toTopic: "resume", qoS: .messageDeliveryAttemptedAtMostOnce) {
            _ in self.isPublishing = false
        }
    }
    
    
    
    func publishTopic(_ angle: Int) {
        isPublishing = true
        guard let data = try? JSONSerialization.data(withJSONObject: ["angle": angle]),
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
