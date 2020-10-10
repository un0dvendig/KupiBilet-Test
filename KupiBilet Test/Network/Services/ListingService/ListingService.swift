//
//  ListingService.swift
//  KupiBilet Test
//
//  Created by Eugene Ilyin on 10.10.2020.
//

import Moya

// MARK: - Protocol
protocol ListingService {
    func getClassifiers(
        withId id: Int,
        then handler: @escaping (Result<String, MoyaError>) -> Void
    )
}
