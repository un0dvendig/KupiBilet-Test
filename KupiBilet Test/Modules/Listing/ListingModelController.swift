//
//  ListingModelControllerImpl.swift
//  KupiBilet Test
//
//  Created by Eugene Ilyin on 10.10.2020.
//

import Foundation

// MARK: - Delegate
protocol ListingModelControllerDelegate: AnyObject {
    typealias PageLoadingResult = Result<[TableViewCellViewModel], Error>
    
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
    
    private lazy var dateStringFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter
    }()
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .init(identifier: "ru")
        dateFormatter.dateFormat = "d MMMM yyyy"
        return dateFormatter
    }()
    
    // View models
    private var disconnectInfoViewModel: [ListingDisconnectInfoCell.ViewModel] = []
    
    // MARK: Initialization
    init(
        classifiersId: Int,
        listingService: ListingService
    ) {
        self.classifiersId = classifiersId
        self.listingService = listingService
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
                    let items = self.disconnectInfoViewModel
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
                let disconnectInfoViewModel = disconnectInfoItems.map {
                    self.makeListingCellViewModel(
                        usingDisconnectInfo: $0
                    )
                }
                self.disconnectInfoViewModel = disconnectInfoViewModel
                handler(.success)
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
    
    private func makeListingCellViewModel(
        usingDisconnectInfo disconnectInfo: DisconnectInfo
    ) -> ListingDisconnectInfoCell.ViewModel {
        let cityName = disconnectInfo.cityName
        let streetName = disconnectInfo.streetName
        
        var houseInfo: String = "дом" + " " + disconnectInfo.houseNumber
        if let buildingNumber = disconnectInfo.buildingNumber {
            houseInfo += " " + "корпус" + " " + buildingNumber
        }
        if let buildingLetter = disconnectInfo.buildingLetter {
            houseInfo += " " + "литер" + " " + buildingLetter
        }
        
        // TODO: Format me
        let dateString: String
        let dateComponents = disconnectInfo.disconnectDateRange.components(separatedBy: "-")
        if let startDateString = dateComponents.first,
           let endDateString = dateComponents.last,
           let startDate = self.dateStringFormatter.date(from: startDateString),
           let endDate = self.dateStringFormatter.date(from: endDateString) {
            let formattedStartDateString = self.dateFormatter.string(from: startDate)
            let formattedEndDateString = self.dateFormatter.string(from: endDate)
            
            dateString = formattedStartDateString + " - " + formattedEndDateString
        } else {
            // In case of any error, just use unformatted date.
            dateString = disconnectInfo.disconnectDateRange
        }
        
        let listingDisconnectViewModel: ListingDisconnectInfoCell.ViewModel = .init(
            cityName: cityName,
            streetName: streetName,
            houseInfo: houseInfo,
            dateString: dateString
        )
        
        return listingDisconnectViewModel
    }
}
