//
//  ListingViewController.swift
//  KupiBilet Test
//
//  Created by Eugene Ilyin on 10.10.2020.
//

import UIKit
import SVProgressHUD
import Moya

// MARK: - View controller
final class ListingViewController: UIViewController {
    // MARK: Private properties
    private let modelController: ListingModelController
    private let tableViewDirector: TableViewDirector
    
    // MARK: Subview
    private let tableView: UITableView
    private let noInternetDummyView: DummyView
    private let otherErrorDummyView: DummyView
    
    // MARK: Initialization
    init(
        modelController: ListingModelController
    ) {
        self.tableView = Self.makeTableView()
        self.noInternetDummyView = DummyView()
        self.otherErrorDummyView = DummyView()
        
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
        
        self.setupDummyViews()
        
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
        
        self.view.addSubview(
            self.noInternetDummyView
        )
        self.noInternetDummyView.centerInSuperview()
        
        self.view.addSubview(
            self.otherErrorDummyView
        )
        self.otherErrorDummyView.centerInSuperview()
    }
    
    private func setupDummyViews() {
        let retryButtonAction: () -> Void = {
            self.hideShownDummyView()
            self.modelController.loadPage()
        }
        let retryButtonViewModelTitle = NSLocalizedString(
            "DummyView.TryAgainButton.Title.Text",
            comment: ""
        )
        let retryButtonViewModel: DummyView.ViewModel.ButtonViewModel = .init(
            title: retryButtonViewModelTitle,
            action: retryButtonAction
        )
        
        let noInternetViewModelTitle = NSLocalizedString(
            "DummyView.NoConnection.Title.Text",
            comment: ""
        )
        let noInternetViewModelDescription = NSLocalizedString(
            "DummyView.NoConnection.Description.Text",
            comment: ""
        )
        let noInternetViewModel: DummyView.ViewModel = .init(
            title: noInternetViewModelTitle,
            description: noInternetViewModelDescription,
            button: retryButtonViewModel
        )
        self.noInternetDummyView.configure(
            withViewModel: noInternetViewModel
        )
        self.noInternetDummyView.isHidden = true
        
        let otherErrorViewModelTitle = NSLocalizedString(
            "DummyView.OtherError.Title.Text",
            comment: ""
        )
        let otherErrorViewModelDescription = NSLocalizedString(
            "DummyView.OtherError.Description.Text",
            comment: ""
        )
        let otherErrorViewModel: DummyView.ViewModel = .init(
            title: otherErrorViewModelTitle,
            description: otherErrorViewModelDescription,
            button: retryButtonViewModel
        )
        self.otherErrorDummyView.configure(
            withViewModel: otherErrorViewModel
        )
        self.otherErrorDummyView.isHidden = true
    }
    
    private func hideShownDummyView() {
        if !self.noInternetDummyView.isHidden {
            self.noInternetDummyView.isHidden = true
        }
        if !self.otherErrorDummyView.isHidden {
            self.otherErrorDummyView.isHidden = true
        }
    }
}

// MARK: - ListingModelControllerDelegate
extension ListingViewController: ListingModelControllerDelegate {
    func pageLoading() {
        SVProgressHUD.show()
    }
    
    func mainPageLoaded(
        with result: PageLoadingResult
    ) {
        SVProgressHUD.dismiss()
        switch result {
        case .success(let viewModels):
            self.tableViewDirector.set(
                viewModels: viewModels
            )
        case .failure(let error):
            switch error {
            case let MoyaError.underlying(error, _):
                if let alamofireError = error.asAFError {
                    switch alamofireError {
                    case .sessionTaskFailed(let sessionError):
                        if let urlError = sessionError as? URLError,
                           urlError.code == URLError.Code.notConnectedToInternet {
                            self.noInternetDummyView.isHidden = false
                        }
                    default:
                        break
                    }
                }
                break
            default:
                self.otherErrorDummyView.isHidden = false
                print("Got and error! \(error)")
            }
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
        tableView.backgroundColor = .lightGray
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
