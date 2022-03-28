//
//  Status.swift
//  SmartWindowController
//
//  Created by lcx on 2022/2/23.
//

import Foundation

struct Status: Codable {
    var isRaining: Bool
    let temperature: Int
    var windowAngle: Double
    let humidity: Int
}
