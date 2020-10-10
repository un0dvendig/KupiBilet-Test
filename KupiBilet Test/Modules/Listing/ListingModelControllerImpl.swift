//
//  ListingModelControllerImpl.swift
//  KupiBilet Test
//
//  Created by Eugene Ilyin on 10.10.2020.
//

// MARK: - Model controller
final class ListingModelControllerImpl {
    // MARK: Properties
    weak var delegate: ListingModelControllerDelegate?
    
    // MARK: Private properties
    private let listingService: ListingService
    
    // MARK: Initialization
    init(
        listingService: ListingService
    ) {
        self.listingService = listingService
    }
}

// MARK: - ListingModelController
extension ListingModelControllerImpl: ListingModelController {
    
}
