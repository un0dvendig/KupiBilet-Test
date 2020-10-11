//
//  ListingDisconnectInfoCell.swift
//  KupiBilet Test
//
//  Created by Eugene Ilyin on 11.10.2020.
//

import TinyConstraints
import UIKit
import SwiftRichString

// MARK: - UITableViewCell
final class ListingDisconnectInfoCell: UITableViewCell {
    // MARK: Private properties
    private enum Layout {
        static let cellCornerRadius: CGFloat = 10
        static let contentContainerBackgroundInsets: UIEdgeInsets = .init(
            top: 10,
            left: 10,
            bottom: 10,
            right: 10
        )
        
        static let contentContainerInsets: UIEdgeInsets = .init(
            top: 5,
            left: 5,
            bottom: 5,
            right: 5
        )
        static let contentContainerSpacing: CGFloat = 5
        
        static let cityLabelHeight: CGFloat = 20
        static let streetLabelHeight: CGFloat = 20
        static let houseLabelHeight: CGFloat = 20
        static let dateLabelMaxHeight: CGFloat = 30
    }
    
    private enum Style {
        static let cityLabelStyle: SwiftRichString.Style = .init {
            $0.font = AppFont.bold20
            $0.color = UIColor.black
        }
        static let streetLabelStyle: SwiftRichString.Style = .init {
            $0.font = AppFont.medium15
            $0.color = UIColor.black
        }
        static let houseLabelStyle: SwiftRichString.Style = .init {
            $0.font = AppFont.regular15
            $0.color = UIColor.black
        }
        static let dateLabelStyle: SwiftRichString.Style = .init {
            $0.font = AppFont.bold17
            $0.color = UIColor.purple
        }
    }
    
    private var viewModel: ViewModel?
    
    // MARK: Subviews
    private let contentContainerBackgroundView: UIView
    private let contentContainer: UIStackView
    private let cityLabel: UILabel
    private let streetLabel: UILabel
    private let houseLabel: UILabel
    private let dateLabel: UILabel
    
    // MARK: Initialization
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        self.contentContainerBackgroundView = Self.makeContentContainerBackgroundView()
        self.contentContainer = Self.makeContentContainer()
        self.cityLabel = Self.makeCityLabel()
        self.streetLabel = Self.makeStreetLabel()
        self.houseLabel = Self.makeHouseLabel()
        self.dateLabel = Self.makeDateLabel()
        
        super.init(
            style: style,
            reuseIdentifier: reuseIdentifier
        )
        
        self.setupSelf()
        self.setupSubviews()
    }
    
    @available(*, unavailable)
    required init?(
        coder: NSCoder
    ) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UITableView methods
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.cityLabel.styledText = nil
        self.streetLabel.styledText = nil
        self.houseLabel.styledText = nil
        self.dateLabel.styledText = nil
    }
    
    // MARK: Private methods
    private func setupSelf() {
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        self.selectionStyle = .none
    }
    
    private func setupSubviews() {
        self.contentView.addSubview(
            self.contentContainerBackgroundView
        )
        self.contentContainerBackgroundView.edgesToSuperview(
            insets: Layout.contentContainerBackgroundInsets
        )
        
        self.contentContainerBackgroundView.addSubview(
            self.contentContainer
        )
        self.contentContainer.edgesToSuperview(
            insets: Layout.contentContainerInsets
        )
        
        self.contentContainer.addArrangedSubview(
            self.cityLabel
        )
        self.contentContainer.addArrangedSubview(
            self.streetLabel
        )
        self.contentContainer.addArrangedSubview(
            self.houseLabel
        )
        self.contentContainer.addArrangedSubview(
            self.dateLabel
        )
    }
}

// MARK: - TableViewConfigurableCell
extension ListingDisconnectInfoCell: TableViewConfigurableCell {
    func configure(
        with viewModel: TableViewCellViewModel
    ) {
        guard let viewModel = viewModel as? ViewModel else {
            return
        }
                
        self.cityLabel.styledText = viewModel.cityName
        self.streetLabel.styledText = viewModel.streetName
        self.houseLabel.styledText = viewModel.houseInfo
        self.dateLabel.styledText = viewModel.dateString
        
        self.viewModel = viewModel
    }
}

// MARK: - TableViewCellSelfHeightProvider
extension ListingDisconnectInfoCell: TableViewCellSelfHeightProvider {
    static func height(
        boundingSize: CGSize,
        viewModel: TableViewCellViewModel
    ) -> CGFloat {
        guard viewModel is ViewModel else {
            return .zero
        }
        
        let contentContainerHeight = Layout.contentContainerInsets.top
            + Layout.cityLabelHeight
            + Layout.contentContainerSpacing
            + Layout.streetLabelHeight
            + Layout.contentContainerSpacing
            + Layout.houseLabelHeight
            + Layout.contentContainerSpacing
            + Layout.dateLabelMaxHeight
            + Layout.contentContainerInsets.bottom
        
        let height = Layout.contentContainerBackgroundInsets.top
            + contentContainerHeight
            + Layout.contentContainerBackgroundInsets.bottom
        
        return height
    }
}

// MARK: - Factory
extension ListingDisconnectInfoCell {
    private static func makeContentContainerBackgroundView() -> UIView {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = Layout.cellCornerRadius
        return view
    }
    
    private static func makeContentContainer() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Layout.contentContainerSpacing
        return stackView
    }
    
    private static func makeCityLabel() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        label.style = Style.cityLabelStyle
        label.height(
            Layout.cityLabelHeight
        )
        return label
    }
    
    private static func makeStreetLabel() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        label.style = Style.streetLabelStyle
        label.height(
            Layout.streetLabelHeight
        )
        return label
    }
    
    private static func makeHouseLabel() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        label.style = Style.houseLabelStyle
        label.height(
            Layout.houseLabelHeight
        )
        return label
    }
    
    private static func makeDateLabel() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.style = Style.dateLabelStyle
        return label
    }
}
