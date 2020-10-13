//
//  Request.swift
//  API
//
//  Created by Kosuke Matsuda on 2020/10/13.
//  Copyright © 2020 Kosuke Matsuda. All rights reserved.
//

import Foundation

// MARK: - HttpMethod

public enum HttpMethod: String {
    case get = "GET"
}


// MARK: - Request

public protocol Request {
    associatedtype Response: Decodable
    var baseURL: URL { get }
    var method: HttpMethod { get }
    var path: String { get }
    var queryParameters: [String: String]? { get }
    var headerFields: [String: String] { get }
}

public extension Request {
    var baseURL: URL {
        URL(string: "https://picsum.photos/v2")!
    }

    var method: HttpMethod { .get }

    var queryParameters: [String: String]? { nil }

    var headerFields: [String: String] {
        ["Accept": "application/json"]
    }
}
