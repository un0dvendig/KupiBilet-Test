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
        ) { (
            resolver,
            classifiersId: Int
        ) -> ListingViewController in
            let modelController = resolver ~> (
                ListingModelController.self,
                argument: classifiersId
            )
            let viewController = ListingViewController(
                modelController: modelController
            )
            return viewController
        }
        
        // Model controller
        container.register(
            ListingModelController.self
        ) { (
            resolver,
            classifiersId: Int
        ) -> ListingModelController in
            let listingService = resolver ~> ListingService.self
            let modelController = ListingModelController(
                classifiersId: classifiersId,
                listingService: listingService
            )
            return modelController
        }
    }
}

