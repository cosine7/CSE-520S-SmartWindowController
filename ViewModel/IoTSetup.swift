//
//  IoTSetup.swift
//  SmartWindowController
//
//  Created by lcx on 2022/3/27.
//

import Foundation
import AWSIoT

class IoTSetup: ObservableObject {
    @Published var done = false
    
    let iotDataManager: AWSIoTDataManager
    private let iot: AWSIoT
    private let iotManager: AWSIoTManager
    var status = Status(isRaining: false, temperature: 0, windowAngle: 0, humidity: 0)
    private var time: Date?
    
    init() {
        let credentialsProvider = AWSCognitoCredentialsProvider(
            regionType:.USEast2,
            identityPoolId: Secret.identityPoolId
        )
        let configuration = AWSServiceConfiguration(region:.USEast2, credentialsProvider:credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        iotManager = AWSIoTManager.default()
        iot = AWSIoT.default()
        
        let iotEndPoint = AWSEndpoint(urlString: Secret.AWSEndpoint)
        let iotDataConfiguration = AWSServiceConfiguration(
           region: AWSRegionType.USEast2,
           endpoint: iotEndPoint,
           credentialsProvider: credentialsProvider
       )
        AWSIoTDataManager.register(with: iotDataConfiguration!, forKey: "MyAWSIoTDataManager")
        iotDataManager = AWSIoTDataManager(forKey: "MyAWSIoTDataManager")
        self.iotManager.createKeysAndCertificate(fromCsr: Secret.csrDictionary) {
            response -> Void in
            guard let response = response,
                  let attachPrincipalPolicyRequest = AWSIoTAttachPrincipalPolicyRequest()
            else {
                print("fail============================")
                return
            }
            attachPrincipalPolicyRequest.policyName = Secret.policyName
            attachPrincipalPolicyRequest.principal = response.certificateArn

            // Attach the policy to the certificate
            self.iot.attachPrincipalPolicy(attachPrincipalPolicyRequest).continueWith {
                task -> AnyObject? in
                if let error = task.error {
                    print("Failed: [\(error)]")
                } else  {
                    self.connect(response.certificateId)
                }
                return nil
            }
        }
    }

    func connect(_ certificateId: String) {
        iotDataManager.connect(
            withClientId: UUID().uuidString,
            cleanSession: true,
            certificateId: certificateId
        ) {
            status in
            print("connection status = \(status.rawValue)")
            self.syncData()
        }
    }
    
    private func syncData() {
        iotDataManager.subscribe(toTopic: "sync_end", qoS: .messageDeliveryAttemptedAtMostOnce) {
            payload in
            guard let status = try? JSONDecoder().decode(Status.self, from: payload) else {
                return
            }
            DispatchQueue.main.async {
                self.status = status
                self.iotDataManager.unsubscribeTopic("sync_end")
                self.done = true
                print(self.time?.timeIntervalSinceNow ?? 0.0)
            }
        }
        time = Date()
        iotDataManager.publishString(
            "{}",
            onTopic: "sync_start",
            qoS: .messageDeliveryAttemptedAtMostOnce
        )
    }
}
