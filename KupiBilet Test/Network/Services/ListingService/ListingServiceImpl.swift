//
//  ListingServiceImlp.swift
//  KupiBilet Test
//
//  Created by Eugene Ilyin on 10.10.2020.
//

import Moya

// MARK: - ListingServiceImpl
public class ListingServiceImpl{
    // MARK: Properties
    private let provider: MoyaProvider<ListingAPI>
    
    // MARK: Initialization
    init(
        provider: MoyaProvider<ListingAPI>
    ) {
        self.provider = provider
    }
}

// MARK: - ListingService
extension ListingServiceImpl: ListingService {
    func getClassifiers(
        withId id: Int,
        then handler: @escaping (Result<String, MoyaError>) -> Void
    ) {
        self.provider.request(.classifiers(classifiersId: id)) { (result) in
            switch result {
            case .success(let response):
                do {
                    let filteredResponse = try response.filterSuccessfulStatusCodes()
//                    let classifiers = try filteredResponse.map(Classifiers.self)
                    let string = String()
                    handler(.success(string))
                } catch let moyaError as MoyaError {
                    handler(.failure(moyaError))
                } catch {
                    let error = MoyaError.underlying(error, response)
                    handler(.failure(error))
                }
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
}
