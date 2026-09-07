import Foundation
import SilentMoonDomain

extension AppError {
    public func toDomainError() -> DomainError {
        switch self {
        case .noInternetConnection, .timeout:
            return .connectivity

        case .unauthorized:
            return .unauthorized

        case .forbidden:
            return .unauthorized   

        case .notFound:
            return .notFound

        case .badRequest, .invalidURL, .noData, .decodingFailed:
            return .invalidInput(message: self.errorDescription ?? "")

        case .backend(let envelope):
            return .invalidInput(message: envelope.message)

        case .problem(let problem):
            return .invalidInput(message: problem.detail ?? problem.title ?? "")

        case .serverError:
            return .server

        case .unknown:
            return .unexpected
        }
    }
}
