//
//  Photo.swift
//  API
//
//  Created by Kosuke Matsuda on 2020/10/13.
//  Copyright © 2020 Kosuke Matsuda. All rights reserved.
//

import Foundation

public struct Photo: Decodable {
    public let id: String
    public let imageURL: URL

    enum CodingKeys: String, CodingKey {
        case id
        case imageURL = "download_url"
    }
}
