//
//  Router.swift
//  jobSearch
//
//  Created by MithranN on 08/03/20.
//  Copyright © 2020 MithranN. All rights reserved.
//

import Foundation
class Router<EndPoint: EndPointType>: NetworkRouter {
    private let session = URLSession(configuration: .default)
    private var task: URLSessionDataTask?
    private let jsonDecoder = JSONDecoder()
    private var requestTimeHash: [Int: Date] = [:]
    typealias JSONTaskCompletionHandler = (Decodable?, APIError?) -> Void

    init() {}

    func fetch<T>(_ route: EndPoint, decode: @escaping (Decodable) -> T?, completion: @escaping (Result<T, APIError>) -> Void) where T: Decodable {
        do {
            let request = try buildRequest(from: route)
            requestTimeHash[request.hashValue] = Date()
            NetworkLogger.log(request: request)
            task = decodingTask(with: request, decodingType: T.self) { json, error in

                // MARK: change to main queue

                DispatchQueue.main.async {
                    guard let json = json else {
                        if let error = error {
                            completion(Result.failure(error))
                        } else {
                            completion(Result.failure(.invalidData))
                        }
                        return
                    }
                    if let value = decode(json) {
                        completion(.success(value))
                    } else {
                        completion(.failure(.jsonParsingFailure))
                    }
                }
            }
        } catch {}
        task?.resume()
    }

    func decodingTask<T: Decodable>(with request: URLRequest, decodingType _: T.Type, completionHandler completion: @escaping JSONTaskCompletionHandler) -> URLSessionDataTask? {
        task = session.dataTask(with: request) { data, response, _ in

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(nil, .requestFailed)
                return
            }

            // Logging
            let requestTime = self.requestTimeHash[request.hashValue]
            self.requestTimeHash.removeValue(forKey: request.hashValue)
            NetworkLogger.log(response: httpResponse, requestedTime: requestTime, withData: data)

            switch httpResponse.statusCode {
            case 200 ... 399:
                let genericModel = parseNetworkResponse(jsonDecoder: self.jsonDecoder, data: data, type: T.self)
                completion(genericModel, nil)
                return
            default:
                let errorObject = parseNetworkResponse(jsonDecoder: self.jsonDecoder, data: data, type: APIErrorMessage.self)
                if let errorMessage = errorObject?.error {
                    completion(nil, .serverErrorResponse(message: errorMessage))
                    return
                }
            }
        }
        return task
    }

    func cancel() {
        task?.cancel()
    }

    fileprivate func buildRequest(from route: EndPoint) throws -> URLRequest {
        var request = URLRequest(url: route.baseURL.appendingPathComponent(route.path),
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: 60.0)

        request.httpMethod = route.httpMethod.rawValue
        do {
            switch route.task {
            case .request:
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            case let .requestParameters(bodyParameters, bodyEncoding, urlParameters):

                try configureParameters(bodyParameters: bodyParameters, bodyEncoding: bodyEncoding, urlParameters: urlParameters, request: &request)

            case let .requestParametersAndHeaders(bodyParameters, bodyEncoding, urlParameters, additionalHeaders):

                addAdditionalHeaders(additionalHeaders, request: &request)
                try configureParameters(bodyParameters: bodyParameters, bodyEncoding: bodyEncoding, urlParameters: urlParameters, request: &request)
            }
            return request
        } catch {
            throw error
        }
    }

    fileprivate func configureParameters(bodyParameters: Parameters?,
                                         bodyEncoding: ParameterEncoding,
                                         urlParameters: Parameters?,
                                         request: inout URLRequest) throws {
        do {
            try bodyEncoding.encode(urlRequest: &request,
                                    bodyParameters: bodyParameters, urlParameters: urlParameters)
        } catch {
            throw error
        }
    }

    fileprivate func addAdditionalHeaders(_ additionalHeaders: HTTPHeaders?, request: inout URLRequest) {
        guard let headers = additionalHeaders else { return }
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
}
