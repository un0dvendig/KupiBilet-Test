//
//  TableViewUpdater.swift
//  KupiBilet Test
//
//  Created by Eugene Ilyin on 10.10.2020.
//

import UIKit
import DifferenceKit

// MARK: TableViewUpdater
protocol TableViewUpdater {
    typealias UpdateCompletion = (Bool) -> Void

    func performUpdate(
        tableView: UITableView,
        adapter: TableViewAdapter,
        viewModels: [TableViewCellViewModel],
        then completion: UpdateCompletion?
    )
}

// MARK: TableViewUpdaterImpl
final class TableViewUpdaterImpl: TableViewUpdater {
    // MARK: - Private
    private enum UpdateType {
        case reload
        case patch(
            StagedChangeset<[AnyTableViewCellViewModell]>,
            TableViewAdapter
        )
    }

    // MARK: Methods
    func performUpdate(
        tableView: UITableView,
        adapter: TableViewAdapter,
        viewModels: [TableViewCellViewModel],
        then completion: TableViewUpdater.UpdateCompletion? = nil
    ) {
        // Check for early bail out only from iOS 11.0.
        if #available(iOS 11.0, *) {
            guard adapter.viewModels.isEmpty == false,
                  viewModels.isEmpty == false else {
                self.update(
                    tableView: tableView,
                    type: .reload,
                    then: completion
                )
                return
            }
        }

        let oldViewModels = adapter.viewModels.map { AnyTableViewCellViewModell(viewModel: $0) }
        let newViewModels = viewModels.map { AnyTableViewCellViewModell(viewModel: $0) }
        
        let difference = StagedChangeset(
            source: oldViewModels,
            target: newViewModels
        )
        
        guard difference.isEmpty == false else {
            completion?(false)
            return
        }
        
        self.update(
            tableView: tableView,
            type: .patch(difference, adapter),
            then: completion
        )
    }

    // MARK: Private methods
    private func update(
        tableView: UITableView,
        type: UpdateType,
        then completion: TableViewUpdater.UpdateCompletion?
    ) {
        switch type {
        case .reload:
            if #available(iOS 11.0, *) {
                let updates = {
                    tableView.reloadData()
                }
                tableView.performBatchUpdates(
                    updates,
                    completion: completion
                )
            }
        case .patch(
            let stagedChangeset,
            let adapter
        ):
            tableView.reload(using: stagedChangeset, with: .automatic) { (data) in
                adapter.viewModels = data.map { $0.viewModel }
                completion?(true)
            }
        }
    }
}

