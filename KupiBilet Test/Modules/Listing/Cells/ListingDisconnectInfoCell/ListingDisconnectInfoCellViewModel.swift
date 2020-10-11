//
//  ListingDisconnectInfoCellViewModel.swift
//  KupiBilet Test
//
//  Created by Eugene Ilyin on 11.10.2020.
//

// MARK: - View model
extension ListingDisconnectInfoCell {
    struct ViewModel: TableViewCellViewModel, Hashable, Equatable {
        // MARK: Properties
        // TableViewCellViewModel properties
        let cellEventHandler: CellEventHandler = DefaultCellEventHandler()
        
        // View model properties
        let cityName: String
        let streetName: String
        let houseInfo: String
        let dateString: String
        
        // MARK: Hashable
        func hash(
            into hasher: inout Hasher
        ) {
            hasher.combine(self.cityName)
            hasher.combine(self.streetName)
            hasher.combine(self.houseInfo)
            hasher.combine(self.dateString)
        }
        
        // MARK: Equatable
        static func == (
            lhs: ListingDisconnectInfoCell.ViewModel,
            rhs: ListingDisconnectInfoCell.ViewModel
        ) -> Bool {
            return lhs.cityName == rhs.cityName
                && lhs.streetName == rhs.streetName
                && lhs.houseInfo == rhs.houseInfo
                && lhs.dateString == rhs.dateString
        }
    }
}
