//
//  Classifier.swift
//  KupiBilet Test
//
//  Created by Eugene Ilyin on 10.10.2020.
//

import Foundation

// MARK: - Classifier
struct Classifier {
    let id: Int
    let name: String
    let file: String
    let version: String
}

// MARK: - Decodable
extension Classifier: Decodable {
    enum CodingKeys: String, CodingKey {
        case id = "classifierId"
        case name = "classifierName"
        case file
        case version
    }
    
    init(
        from decoder: Decoder
    ) throws {
        let container = try decoder.container(
            keyedBy: CodingKeys.self
        )
        self.id = try container.decode(
            Int.self,
            forKey: .id
        )
        self.name = try container.decode(
            String.self,
            forKey: .name
        )
        self.file = try container.decode(
            String.self,
            forKey: .file
        )
        self.version = try container.decode(
            String.self,
            forKey: .version
        )
    }
}
