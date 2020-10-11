//
//  DummyView.swift
//  KupiBilet Test
//
//  Created by Eugene Ilyin on 11.10.2020.
//

import UIKit
import SwiftRichString

// MARK: - DummyView
final class DummyView: UIView {
    // MARK: Private properties
    private enum Layout {
        static let viewCornerRadious: CGFloat = 15
        static let viewHorizontalInsets: CGFloat = 20
        
        static let containerInsets: UIEdgeInsets = .init(
            top: 10,
            left: 0,
            bottom: 10,
            right: 0
        )
        static let containerSpacing: CGFloat = 10
        
        static let titleLabelHeight: CGFloat = 20
        static let descriptionLabelMaxHeight: CGFloat = 40
        
        static let buttonHeight: CGFloat = 30
        static let buttonWidth: CGFloat = 200
    }
    
    private enum Style {
        static let titleLabelStyle: SwiftRichString.Style = .init {
            $0.font = AppFont.bold20
            $0.color = UIColor.black
        }
        
        static let descriptionLabelStyle: SwiftRichString.Style = .init {
            $0.font = AppFont.regular15
            $0.color = UIColor.black
        }
        
        static let buttonTitleStyle: SwiftRichString.Style = .init {
            $0.font = AppFont.medium17
            $0.color = UIColor.white
        }
    }
    
    private var viewModel: ViewModel?
    
    // MARK: Subviews
    private let container: UIStackView
    private let titleLabel: UILabel
    private let descriptionLabel: UILabel
    private let button: UIButton
    
    // MARK: Initialization
    override init(
        frame: CGRect
    ) {
        self.container = Self.makeContainer()
        self.titleLabel = Self.makeTitleLabel()
        self.descriptionLabel = Self.makeDescriptionLabel()
        self.button = Self.makeButton()
        
        super.init(
            frame: frame
        )
        
        self.setupSelf()
        self.setupSubviews()
        
        self.button.addTarget(
            self,
            action: #selector(self.buttonTapped(_:)),
            for: .touchUpInside
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
    
    // MARK: Methods
    func configure(
        withViewModel viewModel: ViewModel
    ) {
        self.titleLabel.styledText = viewModel.title
        self.descriptionLabel.styledText = viewModel.description
        
        let title = viewModel.button.title.set(
            style: Style.buttonTitleStyle
        )
        self.button.setAttributedTitle(
            title,
            for: .normal
        )
        
        self.viewModel = viewModel
    }
    
    // MARK: Private methods
    private func setupSelf() {
        self.backgroundColor = .white
        self.layer.cornerRadius = Layout.viewCornerRadious
        
        let height = Layout.containerInsets.top
            + Layout.titleLabelHeight
            + Layout.containerSpacing
            + Layout.descriptionLabelMaxHeight
            + Layout.containerSpacing
            + Layout.buttonHeight
            + Layout.containerInsets.bottom
        self.height(
            height
        )
        
        let deviceWidth = UIScreen.main.bounds.width < UIScreen.main.bounds.height
            ? UIScreen.main.bounds.width
            : UIScreen.main.bounds.height
        let width = deviceWidth
            - Layout.viewHorizontalInsets
            - Layout.viewHorizontalInsets
        self.width(
            width
        )
    }
    
    private func setupSubviews() {
        self.addSubview(
            self.container
        )
        self.container.edgesToSuperview(
            insets: Layout.containerInsets
        )
        
        self.container.addArrangedSubview(
            self.titleLabel
        )
        self.container.addArrangedSubview(
            self.descriptionLabel
        )
        self.container.addArrangedSubview(
            self.button
        )
    }
    
    @objc
    private func buttonTapped(
        _ button: UIButton
    ) {
        self.viewModel?.button.action()
    }
}

// MARK: - Factory
extension DummyView {
    private static func makeContainer() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = Layout.containerSpacing
        return stackView
    }
    
    private static func makeTitleLabel() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        label.style = Style.titleLabelStyle
        label.height(
            Layout.titleLabelHeight
        )
        return label
    }
    
    private static func makeDescriptionLabel() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.style = Style.descriptionLabelStyle
        return label
    }
    
    private static func makeButton() -> UIButton {
        let button = UIButton()
        button.backgroundColor = .purple
        button.clipsToBounds = true
        button.layer.cornerRadius = Layout.buttonHeight / 2
        button.height(
            Layout.buttonHeight
        )
        button.width(
            Layout.buttonWidth
        )
        return button
    }
}
