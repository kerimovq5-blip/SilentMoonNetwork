//
//  RegisterResponse.swift
//  SilentMoon
//
//  Created by Kerimov Qehreman on 30.07.26.
//

import Foundation
 
// MARK: - RegisterResponse
public struct RegisterResponse: Decodable {
    public let message: String?
    public let email: String?
    public let otpExpiresAt: String?
 
    enum CodingKeys: String, CodingKey {
        case message = "message"
        case email = "email"
        case otpExpiresAt = "otpExpiresAt"
    }
}
