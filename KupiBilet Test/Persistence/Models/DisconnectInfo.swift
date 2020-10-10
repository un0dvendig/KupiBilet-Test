//
//  DisconnectInfo.swift
//  KupiBilet Test
//
//  Created by Eugene Ilyin on 10.10.2020.
//

import Foundation

// MARK: - DisconnectInfo
struct DisconnectInfo {
    // MARK: Properties
    private let cityName: String
    private let streetName: String
    private let houseNumber: String
    private let buildingNumber: String?
    private let buildingLetter: String?
    private let disconnectDateRange: String
}

// MARK: - Decodable
extension DisconnectInfo: Decodable {
    enum CodingKeys: String, CodingKey {
        case cityName = "Населенный пункт"
        case streetName = "Адрес жилого здания"
        case houseNumber = "№ дома"
        case buildingNumber = "корпус"
        case buildingLetter = "литер"
        case disconnectDateRange = "Период отключения ГВС"
    }
    
    init(
        from decoder: Decoder
    ) throws {
        let container = try decoder.container(
            keyedBy: CodingKeys.self
        )
        self.cityName = try container.decode(
            String.self,
            forKey: .cityName
        )
        self.streetName = try container.decode(
            String.self,
            forKey: .streetName
        )
        
        self.houseNumber = try container.decode(
            String.self,
            forKey: .houseNumber
        )
        
        self.buildingNumber = try container.decodeIfPresent(
            String.self,
            forKey: .buildingNumber
        )
        
        self.buildingLetter = try container.decodeIfPresent(
            String.self,
            forKey: .buildingLetter
        )
        self.disconnectDateRange = try container.decode(
            String.self,
            forKey: .disconnectDateRange
        )
    }
}
