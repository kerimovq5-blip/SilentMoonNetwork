//
//  TokenStore.swift
//  SilentMoonNetwork
//
//  Created by Kerimov Qehreman on 06.08.26.
//


import Foundation

public struct TokenKeys {
    public let accessToken: String
    public let refreshToken: String

    public init(accessToken: String, refreshToken: String) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
}

public final class TokenStore {
    private let keys: TokenKeys

    public init(keys: TokenKeys) {
        self.keys = keys
    }

    public private(set) var accessToken: String? {
        get { UserDefaults.standard.string(forKey: keys.accessToken) }
        set { UserDefaults.standard.setValue(newValue, forKey: keys.accessToken) }
    }

    public private(set) var refreshToken: String? {
        get { UserDefaults.standard.string(forKey: keys.refreshToken) }
        set { UserDefaults.standard.setValue(newValue, forKey: keys.refreshToken) }
    }

    public var isLoggedIn: Bool { accessToken != nil }

    public  func save(access: String, refresh: String) {
        accessToken = access
        refreshToken = refresh
    }

    public func clear() {
        accessToken = nil
        refreshToken = nil
    }
}
