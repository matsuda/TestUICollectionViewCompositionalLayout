//
//  PhotoListRequest.swift
//  API
//
//  Created by Kosuke Matsuda on 2020/10/13.
//  Copyright © 2020 Kosuke Matsuda. All rights reserved.
//

import Foundation

public struct PhotoListRequest: Request {
    public typealias Response = [Photo]
    public let path = "/list"
    public var queryParameters: [String: String]? {
        var params: [String: String] = [:]
        if let value = page, value != 0 {
            params["page"] = String(value)
        }
        if let value = limit {
            params["limit"] = String(value)
        }
        return params.isEmpty ? nil : params
    }

    public var page: Int?
    public let limit: Int?

    public init(page: Int? = nil, limit: Int? = nil) {
        self.page = page
        self.limit = limit
    }
}
