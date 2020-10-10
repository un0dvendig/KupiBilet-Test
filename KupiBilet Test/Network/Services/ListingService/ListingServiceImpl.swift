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
    enum CustomErrors: Error {
        case cannotReadFile
    }
    
    // MARK: Private properties
    private let provider: MoyaProvider<ListingAPI>
    private let localFilesProvider: LocalFilesProvider
    
    // MARK: Initialization
    init(
        provider: MoyaProvider<ListingAPI>,
        localFilesProvider: LocalFilesProvider
    ) {
        self.provider = provider
        self.localFilesProvider = localFilesProvider
    }
}

// MARK: - ListingService
extension ListingServiceImpl: ListingService {
    func getClassifiers(
        withId id: Int,
        then handler: @escaping (Result<[DisconnectInfo], MoyaError>) -> Void
    ) {
        self.provider.request(
            .classifiers(
                classifiersId: id
            )
        ) { (result) in
            switch result {
            case .success(let response):
                do {
                    let filteredResponse = try response.filterSuccessfulStatusCodes()
                    let classifiersResponse = try filteredResponse.map(
                        ClassifiersResponse.self
                    )
                    
                    assert(
                        classifiersResponse.classifiers.count <= 1,
                        "Expected 1 or less Classifier objects. More Classifiers request changing of saving / retrieving mechanism. This assertion exists in the sake of saving time as a temporary workaround."
                    )
                    
                    let base64EncodedString = classifiersResponse.classifiers[0].file
                    self.localFilesProvider.saveArchiveIfNeeded(
                        usingBase64EncodedString: base64EncodedString
                    ) { (result) in
                        switch result {
                        case .success:
                            let savedFileURL = self.localFilesProvider.getEncodedFileURL()
                            guard let disconnectInfoItems = self.localFilesProvider.readFile(
                                atURL: savedFileURL,
                                ofType: DisconnectInfo.self
                            ) else {
                                let error = MoyaError.underlying(
                                    CustomErrors.cannotReadFile,
                                    nil
                                )
                                handler(.failure(error))
                                return
                            }
                            handler(.success(disconnectInfoItems))
                        case .failure(let savingError):
                            let error = MoyaError.underlying(
                                savingError,
                                nil
                            )
                            handler(.failure(error))
                        }
                    }
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
