//
//  NetworkManager.swift
//  SilentMoon
//
//  Created by Kerimov Qehreman on 29.07.26.
//

import Foundation

public final class NetworkManager<E: BackendError> {
    
    public let session: URLSession
    public let mainPath: String
    public let header: [String: String]
    public let tokenStore: TokenStore
    public let errorDecoder: (Data) -> Error?
    
    public init(
        session: URLSession = .shared,
        mainPath: String,
        header: [String: String] = [:],
        errorDecoder: @escaping (Data) -> Error? = { data in
            try? JSONDecoder().decode(E.self, from: data)
        },
        tokenStore: TokenStore
    ) {
        self.session = session
        self.mainPath = mainPath
        self.header = header
        self.errorDecoder = errorDecoder
        self.tokenStore = tokenStore
        
    }
    
    public func request<T: Decodable>(endPoint: EndPoint) async -> Result<T, Error> {
        let urlRequestResult = urlRequest(endPoint: endPoint)
        switch urlRequestResult {
        case .success(let urlRequest):
            do {
                #if DEBUG
                print("\n🌐 [NetworkManager Request]")
                print("📌 URL:", urlRequest.url?.absoluteString ?? "")
                print("🛠 Method:", urlRequest.httpMethod ?? "")
                
                if let body = urlRequest.httpBody,
                   let bodyString = String(data: body, encoding: .utf8) {
                    print("📦 Body:", bodyString)
        } #endif
                let (data, response) = try await session.data(for: urlRequest)
#if DEBUG
           if let httpResponse = response as? HTTPURLResponse {
                    print("🔢 Status Code:", httpResponse.statusCode)
                }
                print("📦 Response data count:", data.count)
                if data.isEmpty {
                    print("📩 Response Body: EMPTY")
                } else if let responseString = String(
                    data: data,
                    encoding: .utf8
                ) {
                    print("📩 Response Body:", responseString)
                }
                
                print("----------------------------------------\n")
#endif
                 if let appError = AppError<E>.map(
                    data: data,
                    response: response,
                    error: nil,
                    errorDecoder: errorDecoder
                ) {
                    return .failure(appError)
                }
                do {
                    let result = try JSONDecoder().decode(T.self,from: data)
                    return .success(result)
                } catch {
                    if data.isEmpty,
                       let emptyObjectData = "{}".data(using: .utf8),
                       let fallbackResult = try? JSONDecoder().decode(T.self, from: emptyObjectData) {
#if DEBUG
                        print("⚠️ Boş body gəldi — fallback ilə UĞURLU sayıldı")
#endif
                        return .success(fallbackResult)
                    }
                    print("❌ Decoding error:", error)
                    return .failure(AppError<E>.decodingFailed)
                }
            } catch {
                if let appError = AppError<E>.map(
                    data: nil,
                    response: nil,
                    error: error,
                    errorDecoder: errorDecoder
                ) {
                    return .failure(appError)
                }
                return .failure(error)
            }
        case .failure(let error):
            return .failure(error)
        }
    }
    public func request(endPoint: EndPoint) async -> Result<Void, Error> {
        let urlRequestResult = urlRequest(endPoint: endPoint)
        switch urlRequestResult {
        case .success(let urlRequest):
            
            do {
#if DEBUG
                print("\n🌐 [NetworkManager Request]")
                print("📌 URL:", urlRequest.url?.absoluteString ?? "")
                print("🛠 Method:", urlRequest.httpMethod ?? "")
                
                if let body = urlRequest.httpBody,
                   let bodyString = String(data: body, encoding: .utf8) {
                    print("📦 Body:", bodyString)
                }
#endif
                let (data, response) = try await session.data(for: urlRequest)
#if DEBUG
                if let httpResponse = response as? HTTPURLResponse {
                    print("🔢 Status Code:", httpResponse.statusCode)
                }
                print("📦 Response data count:", data.count)
                if data.isEmpty {
                    print("📩 Response Body: EMPTY")
                } else if let responseString = String(
                    data: data,
                    encoding: .utf8
                ) {
                    print("📩 Response Body:", responseString)
                }
                print("----------------------------------------\n")
#endif
                if let appError = AppError<E>.map(
                    data: data,
                    response: response,
                    error: nil,
                    errorDecoder: errorDecoder
                ) {
                    return .failure(appError)
                }
                return .success(())
            } catch {
                if let appError = AppError<E>.map(
                    data: nil,
                    response: nil,
                    error: error,
                    errorDecoder: errorDecoder
                ) {
                    return .failure(appError)
                }
                return .failure(error)
            }
            
        case .failure(let error):
            return .failure(error)
        }
    }

    public func urlRequest(endPoint: EndPoint) -> Result<URLRequest, Error> {
       let path = "\(mainPath)\(endPoint.path)"
        guard var url = URL(string: path) else {
                return .failure(AppError<E>.invalidURL)
            }
            url.append(queryItems: endPoint.queryItems)
            var urlRequest = URLRequest(url: url)
          header.forEach { key, value in
                   urlRequest.setValue(
                       value,
                       forHTTPHeaderField: key
                   )
               }

            let supportedLanguages: Set<String> = ["az", "en", "ru"]
            let deviceLanguage = Locale.preferredLanguages.first
                .flatMap { Locale(identifier: $0).language.languageCode?.identifier }
            let acceptLanguage = supportedLanguages.contains(deviceLanguage ?? "") ? (deviceLanguage ?? "en") : "en"
            urlRequest.setValue(acceptLanguage, forHTTPHeaderField: "Accept-Language")

                if endPoint.requiresAuth,
               let accessToken = tokenStore.accessToken {
                
                urlRequest.setValue(
                    "Bearer \(accessToken)",
                    forHTTPHeaderField: "Authorization"
                )
            }
            urlRequest.httpMethod = endPoint.method.rawValue
            
        if let body = endPoint.requestBody {
              switch body {
                case .rawdata(let data):
                    urlRequest.httpBody = data
                case .encodable(let encodable):
                    do {
                        urlRequest.httpBody = try JSONEncoder().encode(encodable)
                    } catch {
                        return .failure(error)
                    }
                case .dictionary(let dictionary):
                    do {
                        urlRequest.httpBody = try JSONSerialization.data(
                            withJSONObject: dictionary
                        )
                    } catch {
                        return .failure(error)
                    }
                }
            }
            return .success(urlRequest)
        }
        public func loadData(urlString: String) async -> Result<Data, Error> {
            guard let url = URL(string: urlString) else {
                return .failure(AppError<E>.invalidURL)
            }
            do {
                let (data, response) = try await session.data(
                    from: url
                )
                if let appError = AppError<E>.map(
                    data: data,
                    response: response,
                    error: nil,
                    errorDecoder: errorDecoder
                ) {
                    return .failure(appError)
                }
                
                return .success(data)
            } catch {
                if let appError = AppError<E>.map(
                    data: nil,
                    response: nil,
                    error: error,
                    errorDecoder: errorDecoder
                ) {
                    return .failure(appError)
                }
                return .failure(error)
            }
        }
    }
