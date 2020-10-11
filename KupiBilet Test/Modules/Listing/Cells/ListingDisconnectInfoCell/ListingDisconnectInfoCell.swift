//
//  ListingDisconnectInfoCell.swift
//  KupiBilet Test
//
//  Created by Eugene Ilyin on 11.10.2020.
//

import TinyConstraints
import UIKit

// MARK: - UITableViewCell
final class ListingDisconnectInfoCell: UITableViewCell {
    // MARK: Private properties
    private enum Layout {
        static let contentContainerInsets: UIEdgeInsets = .init(
            top: 0,
            left: 0,
            bottom: 0,
            right: 0
        )
        static let contentContainerSpacing: CGFloat = 5
        
        static let cityLabelHeight: CGFloat = 60
        static let streetLabelHeight: CGFloat = 60
        static let houseLabelHeight: CGFloat = 60
        static let dateLabelHeight: CGFloat = 60
    }
    
    private enum Style {

    }
    
    private var viewModel: ViewModel?
    
    // MARK: Subviews
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
        self.contentContainer = Self.makeContentContainer()
        self.cityLabel = Self.makeLabel()
        self.streetLabel = Self.makeLabel()
        self.houseLabel = Self.makeLabel()
        self.dateLabel = Self.makeLabel()
        
        super.init(
            style: style,
            reuseIdentifier: reuseIdentifier
        )
        
        self.contentContainer.backgroundColor = .white
        self.selectionStyle = .none
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
        
        self.cityLabel.text = nil
        self.streetLabel.text = nil
        self.houseLabel.text = nil
        self.dateLabel.text = nil
    }
    
    // MARK: Private methods
    private func setupSubviews() {
        self.contentView.addSubview(
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
        
        self.cityLabel.text = viewModel.cityName
        self.streetLabel.text = viewModel.streetName
        self.houseLabel.text = viewModel.houseInfo
        self.dateLabel.text = viewModel.dateString
        
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
        
        let height = Layout.contentContainerInsets.top
            + Layout.cityLabelHeight
            + Layout.contentContainerSpacing
            + Layout.streetLabelHeight
            + Layout.contentContainerSpacing
            + Layout.houseLabelHeight
            + Layout.contentContainerSpacing
            + Layout.dateLabelHeight
            + Layout.contentContainerInsets.bottom
        
        return height
    }
}

// MARK: - Factory
extension ListingDisconnectInfoCell {
    private static func makeContentContainer() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Layout.contentContainerSpacing
        return stackView
    }
    
    private static func makeLabel() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .black
        return label
    }
}
