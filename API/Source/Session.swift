//
//  Session.swift
//  API
//
//  Created by Kosuke Matsuda on 2020/10/13.
//  Copyright © 2020 Kosuke Matsuda. All rights reserved.
//

import Foundation

public enum SessionError: Error {
    case invalidURL(URL)
    case connectionError(Error)
    case invalidResponse(URLResponse?)
    case unacceptableStatusCode(Int)
    case responseError(Error)
}

public final class Session {
    public static let shared: Session = .init()

    @discardableResult
    public func send<T: Request>(_ request: T,
                                 completion: @escaping (Result<T.Response, Error>) -> Void) -> URLSessionTask? {
        let url = request.baseURL.appendingPathComponent(request.path)

        guard var componets = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            completion(.failure(SessionError.invalidURL(url)))
            return nil
        }
        componets.queryItems = request.queryParameters?.compactMap(URLQueryItem.init)

        guard var urlRequest = componets.url.map({ URLRequest(url: $0) }) else {
            completion(.failure(SessionError.invalidURL(url)))
            return nil
        }

        urlRequest.httpMethod = request.method.rawValue
        urlRequest.allHTTPHeaderFields = request.headerFields

        #if DEBUG
        print("request URL >>>>>", urlRequest.url as Any)
        #endif

        let task = URLSession.shared.dataTask(with: urlRequest) { (data, urlResponse, error) in
            if let error = error {
                completion(.failure(SessionError.connectionError(error)))
                return
            }
            guard let response = urlResponse as? HTTPURLResponse,
                  let data = data else {
                completion(.failure(SessionError.invalidResponse(urlResponse)))
                return
            }
            guard (200..<300).contains(response.statusCode) else {
                completion(.failure(SessionError.unacceptableStatusCode(response.statusCode)))
                return
            }

            do {
                let object = try JSONDecoder().decode(T.Response.self, from: data)
                completion(.success(object))
            } catch {
                completion(.failure(SessionError.responseError(error)))
            }
        }
        task.resume()
        return task
    }
}
