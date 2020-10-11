//
//  DummyViewViewModel.swift
//  KupiBilet Test
//
//  Created by Eugene Ilyin on 11.10.2020.
//

// MARK: - View model
extension DummyView {
    struct ViewModel {
        // MARK: Properties
        struct ButtonViewModel {
            let title: String
            let action: () -> Void
        }
        
        let title: String
        let description: String
        let button: ButtonViewModel
    }
}
