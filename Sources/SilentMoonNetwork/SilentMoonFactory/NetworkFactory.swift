//
//  NetworkFactory.swift
//  SilentMoonData
//
//  Created by Kerimov Qehreman on 10.08.26.
//

import Foundation
import SilentMoonNetworkCommon

public struct NetworkFactory {
    public static func make() -> (
        tokenStore: TokenStore,
        apiService: SilentMoonApiService,
        networkManager: NetworkManager<ApiErrorEnvelope>
    ) {

        let tokenStore = TokenStore(
            keys: TokenKeys(
                accessToken: "silentmoon.accessToken",
                refreshToken: "silentmoon.refreshToken"
            )
        )
        
        let networkManager = NetworkManager<ApiErrorEnvelope>(
            session: URLSession.shared,
            mainPath: "http://13.48.242.142:30080/api/v1",
            header: [
                "Accept": "application/json",
                "Content-Type": "application/json"
            ],
            tokenStore: tokenStore
        )
        
        let apiService = SilentMoonApiService(
            networkManager: networkManager,
            tokenStore: tokenStore
        )
        
        return (tokenStore, apiService, networkManager)
    }
}
