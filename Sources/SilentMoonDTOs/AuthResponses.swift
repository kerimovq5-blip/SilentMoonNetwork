//
//  AuthResponses.swift
//  SilentMoonNetwork
//
//  Created by Kerimov Qehreman on 09.08.26.
//



import Foundation

public struct SimpleMessageResponse: Decodable, Sendable {
    public let message: String
    
    public init(message: String) {
        self.message = message
    }
}

public struct ResendOtpResponse: Decodable, Sendable {
    public let message: String
    public let otpExpiresAt: String
    
    public init(message: String, otpExpiresAt: String) {
        self.message = message
        self.otpExpiresAt = otpExpiresAt
    }
}

public struct AuthResponse: Decodable, Sendable {
    public let accessToken: String
    public let refreshToken: String
    public let tokenType: String
    public let expiresIn: Int
    public let user: UserProfile
    
    public init(
        accessToken: String,
        refreshToken: String,
        tokenType: String,
        expiresIn: Int,
        user: UserProfile
    ) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.tokenType = tokenType
        self.expiresIn = expiresIn
        self.user = user
    }
}

public struct UserProfile: Decodable, Sendable {
    public let id: String
    public let name: String
    public let email: String
    public let emailVerified: Bool
    public let avatarUrl: String?
    public let createdAt: String
    
    public init(
        id: String,
        name: String,
        email: String,
        emailVerified: Bool,
        avatarUrl: String?,
        createdAt: String
    ) {
        self.id = id
        self.name = name
        self.email = email
        self.emailVerified = emailVerified
        self.avatarUrl = avatarUrl
        self.createdAt = createdAt
    }
}
