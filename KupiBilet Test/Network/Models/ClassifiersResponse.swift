//
//  ClassifiersResonse.swift
//  KupiBilet Test
//
//  Created by Eugene Ilyin on 10.10.2020.
//

import Foundation

// MARK: - ClassifiersResponse
struct ClassifiersResponse {
    let status: String
    let classifiers: [Classifier]
    let responseDate: String
}

// MARK: - Decodable
extension ClassifiersResponse: Decodable {
    enum CodingKeys: String, CodingKey {
        case status
        case classifiersRootKey = "responseData"
        case classifiers
        case responseDate = "expectedResponseDate"
    }
    
    init(
        from decoder: Decoder
    ) throws {
        let container = try decoder.container(
            keyedBy: CodingKeys.self
        )
        self.status = try container.decode(
            String.self,
            forKey: .status
        )
        
        let classifiersContainer = try container.nestedContainer(
            keyedBy: CodingKeys.self,
            forKey: .classifiersRootKey
        )
        self.classifiers = try classifiersContainer.decode(
            [Classifier].self,
            forKey: .classifiers
        )
        
        self.responseDate = try container.decode(
            String.self,
            forKey: .responseDate
        )
    }
}
