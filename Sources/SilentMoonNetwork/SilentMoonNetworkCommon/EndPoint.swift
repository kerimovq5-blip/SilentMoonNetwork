//
//  EndPoint.swift
//  SilentMoonNetwork
//
//  Created by Kerimov Qehreman on 06.08.26.
//


import Foundation
import SilentMoonDomain

public protocol EndPoint {
     var path: String { get }
     var method : HTTPMethod { get }
     var queryItems: [URLQueryItem] { get }
     var requestBody: RequestBody? { get }
     var requiresAuth: Bool { get }
}

extension EndPoint {
    public var requiresAuth: Bool { false }
}

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

public enum RequestBody {
    case rawdata(Data)
    case encodable(Encodable)
    case dictionary([String: Encodable])
}


public struct ApiErrorEnvelope: Decodable, Error, Sendable, BackendError {
    public struct ErrorDetail: Decodable, Sendable {
        public let field: String
        public let issue: String
    }
    public struct ErrorBody: Decodable , Sendable{
        public let code: String
        public let message: String
        public let details: [ErrorDetail]?
        public let requestId: String?
    }
    public let error: ErrorBody

    public var code: String { error.code }
    public var message: String { error.message }
}

public struct ProblemDetails: Decodable, Error, Sendable {
    public let type: String?
    public let title: String?
    public let status: Int?
    public let detail: String?
    public let errorCode: String?
}
