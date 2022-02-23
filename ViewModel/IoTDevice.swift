//
//  IOT.swift
//  SmartWindowController
//
//  Created by lcx on 2022/2/23.
//

import Foundation
import AWSIoT

class IoTDevice: ObservableObject {
    @Published var isOpen: Bool {
        didSet {
            publishTopic(isOpen)
        }
    }
    private let iotDataManager: AWSIoTDataManager
    private let iot: AWSIoT
    private let iotManager: AWSIoTManager
    
    init() {
        isOpen = true
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType:.USEast2,
           identityPoolId:"us-east-2:d7fe918e-a665-4602-af6f-108f1ea04286")
        let configuration = AWSServiceConfiguration(region:.USEast2, credentialsProvider:credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        iotManager = AWSIoTManager.default()
        iot = AWSIoT.default()
        
        let iotEndPoint = AWSEndpoint(
            urlString: "wss://a31gd9kluhs5xl-ats.iot.us-east-2.amazonaws.com/mqtt")
        let iotDataConfiguration = AWSServiceConfiguration(
           region: AWSRegionType.USEast2,
           endpoint: iotEndPoint,
           credentialsProvider: credentialsProvider
       )
        AWSIoTDataManager.register(with: iotDataConfiguration!, forKey: "MyAWSIoTDataManager")
        iotDataManager = AWSIoTDataManager(forKey: "MyAWSIoTDataManager")
        let csrDictionary = [
            "commonName": "testApp",
            "countryName": "US",
            "organizationName": "cse520s",
            "organizationalUnitName": "000"
        ]
        self.iotManager.createKeysAndCertificate(fromCsr: csrDictionary) {
            response -> Void in
            guard let response = response else {
                print("fail============================")
                return
            }
            let attachPrincipalPolicyRequest = AWSIoTAttachPrincipalPolicyRequest()
            attachPrincipalPolicyRequest?.policyName = "testSWAppIOTPolicy"
            attachPrincipalPolicyRequest?.principal = response.certificateArn

            // Attach the policy to the certificate
            self.iot.attachPrincipalPolicy(attachPrincipalPolicyRequest!).continueWith (block: { (task) -> AnyObject? in
                if let error = task.error {
                    print("Failed: [\(error)]")
                } else  {
                    self.tryToConnect(response.certificateId)
                }
                return nil
            })
        }
    }
    
    func tryToConnect(_ certificateId: String) {
        iotDataManager.connect(
            withClientId: UUID().uuidString,
            cleanSession: true,
            certificateId: certificateId,
            statusCallback: mqttEventCallback
        )
        iotDataManager.subscribe(
            toTopic: "smart_window",
            qoS: .messageDeliveryAttemptedAtMostOnce,
            messageCallback: {
                (payload) ->Void in
                let stringValue = NSString(data: payload, encoding: String.Encoding.utf8.rawValue)!
                print("======================================================")
                print("Message received: \(stringValue)")
            }
        )
    }
    
    func mqttEventCallback(_ status: AWSIoTMQTTStatus ) {
        print("connection status = \(status.rawValue)")
    }
    
    private func publishTopic(_ needOpen: Bool) {
        guard let data = try? JSONSerialization.data(withJSONObject: ["needOpen": needOpen]),
              let message = String(data: data, encoding: .utf8)
        else {
            return
        }
        iotDataManager.publishString(
            message,
            onTopic: "forceAction",
            qoS:.messageDeliveryAttemptedAtMostOnce
        )
    }
}
