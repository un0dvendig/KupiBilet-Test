//
//  ListingCellTypeProvider.swift
//  KupiBilet Test
//
//  Created by Eugene Ilyin on 11.10.2020.
//

// MARK: - TableViewCellTypeProvider
final class ListingCellTypeProvider: TableViewCellTypeProvider {
    // MARK: Properites
    let allCellTypes: [TableViewCell.Type] = [
        ListingDisconnectInfoCell.self,
        // Add new cells here

        FallbackCell.self
    ]

    // MARK: Methods
    func cellType(
        forViewModel viewModel: TableViewCellViewModel
    ) -> TableViewCell.Type {
        let cellType: TableViewCell.Type
        // Add new viewModels here

        switch viewModel {
        case is ListingDisconnectInfoCell.ViewModel:
            cellType = ListingDisconnectInfoCell.self
        default:
            assertionFailure(
                "Unknown viewModel type."
            )
            return FallbackCell.self
        }

        guard self.allCellTypes.contains(where: { String(describing: cellType) == String(describing: $0) }) else {
            assertionFailure(
                "You should add cell type to `allCellTypes`."
            )
            return FallbackCell.self
        }

        return cellType
    }
}

