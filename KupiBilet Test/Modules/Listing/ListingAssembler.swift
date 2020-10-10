//
//  ListingAssembler.swift
//  KupiBilet Test
//
//  Created by Eugene Ilyin on 10.10.2020.
//

import Swinject
import SwinjectAutoregistration

// MARK: - Assembler
struct ListingAssembler {
    // MARK: Properties
    private let assembler: Assembler
    
    // MARK: Private properties
    public var resolver: Resolver {
        self.assembler.resolver
    }
    
    // MARK: Initialization
    public init(
        parent: Assembler?
    ) {
        self.assembler = Assembler(
            [
                ListingAssembly()
            ],
            parent: parent
        )
    }
}

// MARK: - Assembly
struct ListingAssembly: Assembly {
    func assemble(
        container: Container
    ) {
        // View controller
        container.register(
            ListingViewController.self
        ) {
            let modelController = $0 ~> ListingModelController.self
            let viewController = ListingViewController(
                modelController: modelController
            )
            return viewController
        }
        
        // Model controller
        container.register(
            ListingModelController.self
        ) {
            let listingService = $0 ~> ListingService.self
            let modelController = ListingModelControllerImpl(
                listingService: listingService
            )
            return modelController
        }
    }
}

