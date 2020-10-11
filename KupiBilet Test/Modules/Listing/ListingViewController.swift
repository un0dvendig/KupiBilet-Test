//
//  ListingViewController.swift
//  KupiBilet Test
//
//  Created by Eugene Ilyin on 10.10.2020.
//

import UIKit

// MARK: - View controller
final class ListingViewController: UIViewController {
    // MARK: Private properties
    private let modelController: ListingModelController
    private let tableViewDirector: TableViewDirector
    
    // MARK: Subview
    private let tableView: UITableView
    
    // MARK: Initialization
    init(
        modelController: ListingModelController
    ) {
        self.tableView = Self.makeTableView()
        
        self.tableViewDirector = Self.makeTableViewDirector(
            forTableView: self.tableView
        )
        self.modelController = modelController
        
        super.init(
            nibName: nil,
            bundle: nil
        )
        
        self.view.backgroundColor = .white
        self.setupSubviews()
        
        self.modelController.delegate = self
        self.tableView.dataSource = self.tableViewDirector.adapter
        self.tableView.delegate = self.tableViewDirector.adapter
    }
    
    @available(*, unavailable)
    required init?(
        coder: NSCoder
    ) {
        fatalError(
            "init(coder:) has not been implemented"
        )
    }
    
    // MARK: View life cycle    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.modelController.loadPage()
    }
    
    // MARK: Private methods
    private func setupSubviews() {
        self.view.addSubview(
            self.tableView
        )
        self.tableView.edgesToSuperview(
            usingSafeArea: false
        )
    }
}

// MARK: - ListingModelControllerDelegate
extension ListingViewController: ListingModelControllerDelegate {
    func pageLoading() {
        
    }
    
    func mainPageLoaded(
        with result: PageLoadingResult
    ) {
        switch result {
        case .success(let viewModels):
            self.tableViewDirector.set(
                viewModels: viewModels
            )
        case .failure(let error):
            print("Got and error! \(error)")
        }
    }
}

// MARK: - Factory
extension ListingViewController {
    private static func makeTableView() -> UITableView {
        let tableView = UITableView(
            frame: .zero,
            style: .plain
        )
        tableView.separatorStyle = .none
        return tableView
    }
    
    private static func makeTableViewDirector(
        forTableView tableView: UITableView
    ) -> TableViewDirector {
        let cellTypeProvider: TableViewCellTypeProvider = ListingCellTypeProvider()
        let cellHeightProvider: TableViewCellHeightProvider = ListingCellHeightProvider(
            cellTypeProvider: cellTypeProvider
        )
        let adapter: TableViewAdapter = TableViewAdapterImpl(
            cellHeightProvider: cellHeightProvider,
            cellTypeProvider: cellTypeProvider
        )
        let updater: TableViewUpdater = TableViewUpdaterImpl()
        
        let tableViewDirector = TableViewDirector(
            tableView: tableView,
            cellTypeProvider: cellTypeProvider,
            cellHeightProvider: cellHeightProvider,
            adapter: adapter,
            updater: updater
        )
        return tableViewDirector
    }
}
