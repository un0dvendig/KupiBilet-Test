//
//  ListingModelControllerImpl.swift
//  KupiBilet Test
//
//  Created by Eugene Ilyin on 10.10.2020.
//

import Foundation

// MARK: - Delegate
protocol ListingModelControllerDelegate: AnyObject {
    typealias PageLoadingResult = Result<[DisconnectInfo], Error>
    
    /// Handles start of the page loading process.
    func pageLoading()
    
    /// Handles result of the page loading process.
    ///
    /// - Parameters:
    ///    - result: The result of page loading process.
    func mainPageLoaded(
        with result: PageLoadingResult
    )
}

// MARK: - Model controller
final class ListingModelController {
    // MARK: Properties
    weak var delegate: ListingModelControllerDelegate?
    
    // MARK: Private properties
    private let classifiersId: Int
    private let listingService: ListingService
    
    // View models
    private var listingItems: [DisconnectInfo] = []
    
    // MARK: Initialization
    init(
        classifiersId: Int,
        listingService: ListingService
    ) {
        self.classifiersId = classifiersId
        self.listingService = listingService
    }
    
    // MARK: Private methods
    private func updateListing(
        then handler: @escaping (VoidResult) -> Void
    ) {
        let id = self.classifiersId
        
        self.listingService.getClassifiers(
            withId: id
        ) { (result) in
            switch result {
            case .success(let disconnectInfoItems):
                self.listingItems = disconnectInfoItems
                handler(.success)
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
    
    // MARK: - Methods
    public func loadPage() {
        DispatchQueue.main.async {
            self.delegate?.pageLoading()
        }
        
        self.updateListing { (result) in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    let items = self.listingItems
                    self.delegate?.mainPageLoaded(
                        with: .success(items)
                    )
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.delegate?.mainPageLoaded(
                        with: .failure(error)
                    )
                }
            }
        }
    }
}
