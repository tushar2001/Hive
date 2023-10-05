//
//  WikiModel.swift
//  Hive
//
//  Created by Tushar Tayal on 05/10/23.
//

import Foundation
import UIKit

struct WikipediaResponse: Codable {
    let batchComplete: String
    let `continue`: Continue
    let query: Query
    let limits: Limits?
    
    private enum CodingKeys: String, CodingKey {
        case batchComplete = "batchcomplete"
        case `continue` = "continue", query, limits
    }
}

struct Continue: Codable {
    let gsroffset: Int
    let `continue`: String
    
    private enum CodingKeys: String, CodingKey {
        case gsroffset
        case `continue` = "continue"
    }
}

struct Query: Codable {
    let pages: [String: Page]
}

struct Page: Codable {
    let pageid: Int
    let ns: Int
    let title: String
    let index: Int
    let thumbnail: Thumbnail?
    let pageimage: String?
    let extract: String?
}

struct Thumbnail: Codable {
    let source: String
    let width: Int
    let height: Int
}

struct Limits: Codable {
    let pageimages: Int
    let extracts: Int
}
