//
//  Searchmodels.swift
//  SilentMoon
//
//  Created by Kerimov Qehreman on 02.08.26.
//

import Foundation
import SilentMoonNetworkCommon

public struct CourseSummary: Decodable {
    public let id: String
    public let title: String
    public let subtitle: String?
    public let type: String
    public let categoryId: String?
    public let imageUrl: String?
    public let durationSec: Int
    public let isFeatured: Bool?
    public let narrators: [String]?
}

public struct PaginationMeta: Decodable {
    public let page: Int
    public let limit: Int
    public let total: Int
    public let totalPages: Int
}

public struct SearchResponse: Decodable {
    public let query: String
    public let data: [CourseSummary]
    public let meta: PaginationMeta
}
