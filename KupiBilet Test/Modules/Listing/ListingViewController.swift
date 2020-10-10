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
    
    // MARK: Initialization
    init(
        modelController: ListingModelController
    ) {
        self.modelController = modelController
        
        super.init(
            nibName: nil,
            bundle: nil
        )
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
    }
}
