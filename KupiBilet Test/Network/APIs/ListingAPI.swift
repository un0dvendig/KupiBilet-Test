//
//  ListingAPI.swift
//  KupiBilet Test
//
//  Created by Eugene Ilyin on 10.10.2020.
//

import Moya

// MARK: - API
enum ListingAPI {
    case classifiers(
        classifiersId: Int
    )
}

// MARK: - TargetType
extension ListingAPI: TargetType {
    var baseURL: URL {
        return URL(string: AppConstants.serverAPI)!
    }
    
    var path: String {
        switch self {
        case .classifiers:
            return "classifiers/downloadClassifiers"
        }
    }
    
    var method: Method {
        switch self {
        case .classifiers: return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .classifiers(
            let classifiersId
        ):
            var parameters: [String: Any] = [:]
            parameters.updateValue(
                classifiersId,
                forKey: "classifiersId"
            )
            return .requestParameters(
                parameters: parameters,
                encoding: URLEncoding.default
            )
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .classifiers: return [:]
        }
    }
}
