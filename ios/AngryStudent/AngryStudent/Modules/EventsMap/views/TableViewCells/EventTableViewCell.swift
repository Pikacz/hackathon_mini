//
//  EventTableViewCell.swift
//  AngryStudent
//
//  Created by Mateusz Orzoł on 13.01.2018.
//  Copyright © 2018 Paweł Czerwiński. All rights reserved.
//

import Foundation
import UIKit

protocol EventTableViewCellDelegate: class {
    func eventTableViewCellRemove(cell: EventTableViewCell, model: Event?)
}

class EventTableViewCell: BasicTableViewCell {
    
    // MARK: - Delegate
    
    weak var delegate: EventTableViewCellDelegate?
    
    // MARK: - Properties
    
    private var model: Event?
    
    // MARK: - Outlets
    
    private let bcgView: UIView = {
        $0.backgroundColor = Color.clear
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIView())
    
    private let iconImageView: UIImageView = {
        $0.backgroundColor = Color.clear
        $0.tintColor = Color.blue
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFit
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIImageView())
    
    private let nameLabel: UILabel = {
        $0.textColor = Color.blueDark
        $0.font = UIFont.systemFont(ofSize: 20)
        $0.numberOfLines = 1
        $0.textAlignment = .left
        $0.lineBreakMode = .byTruncatingTail
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    private let descriptionLabel: UILabel = {
        $0.textColor = Color.blueDark
        $0.font = UIFont.systemFont(ofSize: 15)
        $0.numberOfLines = 1
        $0.textAlignment = .left
        $0.lineBreakMode = .byTruncatingTail
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    private lazy var trashButton: UIButton = {
        $0.setImage(#imageLiteral(resourceName: "Trash"), for: UIControlState.normal)
        $0.tintColor = Color.blueDark
        $0.backgroundColor = Color.clear
        $0.addTarget(self, action: #selector(trashPressedd), for: .touchUpInside)
        $0.isUserInteractionEnabled = true
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIButton(type: UIButtonType.system))
    
    private let labelsStackView: UIStackView = {
        $0.axis = .vertical
        $0.distribution = .fill
        $0.alignment = .fill
        $0.spacing = 3
        $0.isUserInteractionEnabled = true
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIStackView())
    
    // MARK: - Inititalization
    
    override public func initialize() {
        super.initialize()
        setupUI()
    }
    
    override public func prepareForReuse() {
        super.prepareForReuse()
        if let iconName = model?.iconName {
            iconImageView.image = UIImage(named: iconName)
        }
    }
    
    // MARK: - Actions
    
    @objc private func trashPressedd() {
        delegate?.eventTableViewCellRemove(cell: self, model: model)
    }
    
    // MARK: - Helpers
    
    func setup(model: Event) {
        self.model = model
        if let iconName = model.iconName {
            let image = UIImage(named: iconName)?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
            print("♞")
            print(model.iconName)
            iconImageView.image = image
        }
        nameLabel.text = model.name
        descriptionLabel.text = model.description
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        self.backgroundColor = Color.clear
        self.selectionStyle = .none
        addSubview(bcgView)
        addSubview(iconImageView)
        labelsStackView.addArrangedSubview(nameLabel)
        labelsStackView.addArrangedSubview(descriptionLabel)
        addSubview(labelsStackView)
        addSubview(trashButton)
        setupBcgView()
        setupIconImageView()
        setupLabelsStackView()
        setupTrashButton()
    }
    
    private func setupBcgView() {
        bcgView.topAnchor.constraint(equalTo: topAnchor, constant: 3).isActive = true
        bcgView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        bcgView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        bcgView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -3).isActive = true
    }
    
    private func setupIconImageView() {
        iconImageView.centerYAnchor.constraint(equalTo: bcgView.centerYAnchor).isActive = true
        iconImageView.leadingAnchor.constraint(equalTo: bcgView.leadingAnchor, constant: 16).isActive = true
        iconImageView.heightAnchor.constraint(equalTo: iconImageView.widthAnchor).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    private func setupLabelsStackView() {
        labelsStackView.centerYAnchor.constraint(equalTo: bcgView.centerYAnchor).isActive = true
        labelsStackView.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 10).isActive = true
        labelsStackView.trailingAnchor.constraint(equalTo: bcgView.trailingAnchor, constant: -5).isActive = true
    }
    
    private func setupTrashButton() {
        trashButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        trashButton.centerYAnchor.constraint(equalTo: bcgView.centerYAnchor).isActive = true
        trashButton.heightAnchor.constraint(equalTo: trashButton.widthAnchor).isActive = true
        trashButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
}
