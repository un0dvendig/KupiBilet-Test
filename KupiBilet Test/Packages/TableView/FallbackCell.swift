//
//  FallbackCell.swift
//  KupiBilet Test
//
//  Created by Eugene Ilyin on 10.10.2020.
//

import UIKit

// MARK: - FallbackCell
final class FallbackCell: UITableViewCell { }

// MARK: - TableViewCell
extension FallbackCell: TableViewCell {
    func configure(
        with viewModel: TableViewCellViewModel
    ) {
        assertionFailure(
            "This cell should not be used. Check your `CellTypeProvider`."
        )
    }

    static func height(
        boundingSize: CGSize,
        viewModel: TableViewCellViewModel
    ) -> CGFloat {
        assertionFailure(
            "This cell should not be used. Check your `CellTypeProvider`."
        )
        return .zero
    }
}

