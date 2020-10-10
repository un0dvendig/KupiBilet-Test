//
//  TableViewCellTypeProvider.swift
//  KupiBilet Test
//
//  Created by Eugene Ilyin on 10.10.2020.
//

// MARK: - TableViewCellTypeProvider
protocol TableViewCellTypeProvider {
    var allCellTypes: [TableViewCell.Type] { get }

    func cellType(
        forViewModel viewModel: TableViewCellViewModel
    ) -> TableViewCell.Type
}

