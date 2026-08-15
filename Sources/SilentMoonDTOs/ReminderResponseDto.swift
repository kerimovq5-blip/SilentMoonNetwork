//
//  ReminderResponseDto.swift
//  SilentMoonNetwork
//
//  Created by Kerimov Qehreman on 14.08.26.
//

import Foundation
 
public struct ReminderResponse: Decodable, Sendable {
    public let id: String
    public let time: String
    public let days: [Int]
    public let message: String
}
