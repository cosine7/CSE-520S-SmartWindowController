//
//  Status.swift
//  SmartWindowController
//
//  Created by lcx on 2022/2/23.
//

import Foundation

struct Status: Codable {
    var isRaining: Bool
    var temperature: Int
    var windowAngle: Double
    var humidity: Int
}
