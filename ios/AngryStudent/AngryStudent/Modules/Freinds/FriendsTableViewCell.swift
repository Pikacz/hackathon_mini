import Foundation
import UIKit


class FriendsTableViewCell: BasicTableViewCell {
    
    // MARK: - Outlets
    
    private let bcgView: UIView = {
        $0.backgroundColor = Color.clear
        $0.layer.borderColor = Color.blueDark.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 10
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIView())
    
    private let iconImageView: UIImageView = {
        $0.backgroundColor = Color.clear
        $0.layer.cornerRadius = 35
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFit
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIImageView())
    
    private let nameLabel: UILabel = {
        $0.textColor = Color.blueDark
        $0.font = UIFont.systemFont(ofSize: 22)
        $0.numberOfLines = 1
        $0.textAlignment = .left
        $0.lineBreakMode = .byTruncatingTail
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    private let descriptionLabel: UILabel = {
        $0.textColor = Color.blueDark
        $0.font = UIFont.systemFont(ofSize: 17)
        $0.numberOfLines = 1
        $0.textAlignment = .left
        $0.lineBreakMode = .byTruncatingTail
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
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
        iconImageView.image = nil
        descriptionLabel.text = nil
        nameLabel.text = nil
    }
    
    // MARK: - Helpers
    
    func setup(model: Friend) {
        iconImageView.image = model.faceIamge
        nameLabel.text = model.name
        descriptionLabel.text = model.event
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
        setupBcgView()
        setupIconImageView()
        setupLabelsStackView()
    }
    
    private func setupBcgView() {
        bcgView.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        bcgView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 7).isActive = true
        bcgView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -7).isActive = true
        bcgView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
    }
    
    private func setupIconImageView() {
        iconImageView.centerYAnchor.constraint(equalTo: bcgView.centerYAnchor).isActive = true
        iconImageView.leadingAnchor.constraint(equalTo: bcgView.leadingAnchor, constant: 16).isActive = true
        iconImageView.heightAnchor.constraint(equalTo: iconImageView.widthAnchor).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
    }
    
    private func setupLabelsStackView() {
        labelsStackView.centerYAnchor.constraint(equalTo: bcgView.centerYAnchor).isActive = true
        labelsStackView.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 10).isActive = true
        labelsStackView.trailingAnchor.constraint(equalTo: bcgView.trailingAnchor, constant: -5).isActive = true
    }
}

