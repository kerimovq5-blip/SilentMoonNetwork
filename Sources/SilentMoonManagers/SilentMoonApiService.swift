//
//  SilentMoonApiService.swift
//  SilentMoonNetwork
//
//  Created by Kerimov Qehreman on 07.08.26.
//

import Foundation
import SilentMoonNetworkCommon
import SilentMoonDTOs

public struct EmptyResponse: Decodable {
    public init() {}
}

public final class SilentMoonApiService {
    private let networkManager: NetworkManager<ApiErrorEnvelope>
    private let tokenStore: TokenStore

    private var isRefreshing = false
    private var refreshCallbacks: [(Bool) -> Void] = []

    public init(networkManager: NetworkManager<ApiErrorEnvelope>, tokenStore: TokenStore) {
        self.networkManager = networkManager
        self.tokenStore = tokenStore
    }
    
    private func requestWithRefresh<T: Decodable>(endPoint: EndPoint) async -> Result<T, Error> {
        let result: Result<T, Error> = await networkManager.request(endPoint: endPoint)
        
        guard case .failure(let error) = result,
              let appError = error as? AppError<ApiErrorEnvelope>,
              case .unauthorized = appError,
              endPoint.requiresAuth else {
            return result
        }
        let refreshResult = await refreshToken()
        switch refreshResult {
        case .success:
            return await networkManager.request(endPoint: endPoint)
        case .failure:
            return .failure(AppError<ApiErrorEnvelope>.unauthorized)
        }
    }

    public func register(
        name: String,
        email: String,
        password: String
    ) async -> Result<EmptyResponse, Error> {
        await networkManager.request(
            endPoint: SilentMoonEndPoint.register(name: name, email: email, password: password)
        )
    }

    public func login(
        email: String,
        password: String
    ) async -> Result<AuthResponse, Error> {
        let result: Result<AuthResponse, Error> = await networkManager.request(
            endPoint: SilentMoonEndPoint.login(email: email, password: password)
        )
        
        if case .success(let auth) = result {
            tokenStore.save(access: auth.accessToken, refresh: auth.refreshToken)
        }
        
        return result
    }

    public func verifyEmail(
        email: String,
        otp: String
    ) async -> Result<AuthResponse, Error> {
        let result: Result<AuthResponse, Error> = await networkManager.request(
            endPoint: SilentMoonEndPoint.verifyEmail(email: email, otp: otp)
        )
        
        if case .success(let auth) = result {
            tokenStore.save(access: auth.accessToken, refresh: auth.refreshToken)
        }
        
        return result
    }

    public func resendOtp(
        email: String
    ) async -> Result<ResendOtpResponse, Error> {
        await networkManager.request(
            endPoint: SilentMoonEndPoint.resendOtp(email: email)
        )
    }

    public func googleLogin(
        idToken: String
    ) async -> Result<AuthResponse, Error> {
        let result: Result<AuthResponse, Error> = await networkManager.request(
            endPoint: SilentMoonEndPoint.googleLogin(idToken: idToken)
        )
        
        if case .success(let auth) = result {
            tokenStore.save(access: auth.accessToken, refresh: auth.refreshToken)
        }
        
        return result
    }

    public func forgotPassword(
        email: String
    ) async -> Result<SimpleMessageResponse, Error> {
        await networkManager.request(
            endPoint: SilentMoonEndPoint.forgotPassword(email: email)
        )
    }

    public func resetPassword(
        email: String,
        otp: String,
        newPassword: String
    ) async -> Result<SimpleMessageResponse, Error> {
        await networkManager.request(
            endPoint: SilentMoonEndPoint.resetPassword(email: email, otp: otp, newPassword: newPassword)
        )
    }

    public func refreshToken() async -> Result<AuthResponse, Error> {
        guard let refreshToken = tokenStore.refreshToken else {
            return .failure(AppError<ApiErrorEnvelope>.unauthorized)
        }
        
        let result: Result<AuthResponse, Error> = await networkManager.request(
            endPoint: SilentMoonEndPoint.refresh(refreshToken: refreshToken)
        )
        
        switch result {
        case .success(let auth):
            tokenStore.save(access: auth.accessToken, refresh: auth.refreshToken)
        case .failure:
            tokenStore.clear()
        }
        
        return result
    }

    public func logout() async -> Result<Void, Error> {
        guard let refreshToken = tokenStore.refreshToken else {
            tokenStore.clear()
            return .success(())
        }
        
        let result: Result<EmptyResponse, Error> = await networkManager.request(
            endPoint: SilentMoonEndPoint.logout(refreshToken: refreshToken)
        )
        
        tokenStore.clear()
        
        switch result {
        case .success:
            return .success(())
        case .failure(let error):
            return .failure(error)
        }
    }
    
    public func search(
        query: String,
        type: String? = nil,
        page: Int = 1,
        limit: Int = 20
    ) async -> Result<SearchResponse, Error> {
        await networkManager.request(
            endPoint: SilentMoonEndPoint.search(query: query, type: type, page: page, limit: limit)
        )
    }

    public func getTopics() async -> Result<[String], Error> {
        
        await requestWithRefresh(endPoint: SilentMoonEndPoint.getTopics)
    }

    public func updateTopics(topicIds: [String]) async -> Result<[String], Error> {
        await requestWithRefresh(endPoint: SilentMoonEndPoint.updateTopics(topicIds: topicIds))
    }

    public func setReminder(time: String, days: [Int], message: String) async -> Result<ReminderResponse, Error> {
        await requestWithRefresh(endPoint: SilentMoonEndPoint.setReminder(time: time, days: days, message: message))
    }

    public func getReminders() async -> Result<[ReminderResponse], Error> {
        await requestWithRefresh(endPoint: SilentMoonEndPoint.getReminders)
    }

    public func updateReminder(id: String, time: String, days: [Int], message: String) async -> Result<ReminderResponse, Error> {
        await requestWithRefresh(endPoint: SilentMoonEndPoint.updateReminder(id: id, time: time, days: days, message: message))
    }

    public func deleteReminder(id: String) async -> Result<EmptyResponse, Error> {
        await requestWithRefresh(endPoint: SilentMoonEndPoint.deleteReminder(id: id))
    }

}
