//
//  TemperamentChipCell.swift
//  TheCatAPIUIKit
//
//  Created by joan on 05/04/25.
//

import UIKit

class TemperamentChipCell: UICollectionViewCell {
    static let chipColors: [(background: UIColor, text: UIColor)] = [
        (UIColor(red: 1.0, green: 0.91, blue: 0.91, alpha: 1.0), UIColor(red: 0.8, green: 0.2, blue: 0.2, alpha: 1.0)),
        (UIColor(red: 0.91, green: 0.96, blue: 1.0, alpha: 1.0), UIColor(red: 0.2, green: 0.5, blue: 0.8, alpha: 1.0)),
        (UIColor(red: 0.91, green: 1.0, blue: 0.91, alpha: 1.0), UIColor(red: 0.2, green: 0.7, blue: 0.3, alpha: 1.0)),
        (UIColor(red: 1.0, green: 0.96, blue: 0.91, alpha: 1.0), UIColor(red: 0.8, green: 0.5, blue: 0.2, alpha: 1.0)),
        (UIColor(red: 0.95, green: 0.91, blue: 1.0, alpha: 1.0), UIColor(red: 0.6, green: 0.2, blue: 0.8, alpha: 1.0))
    ]
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        return view
    }()
    
    private let iconLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(containerView)
        containerView.addSubview(iconLabel)
        containerView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            iconLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            iconLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: iconLabel.trailingAnchor, constant: 4),
            titleLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 32)
        ])
    }
    
    func configure(with trait: String, colorIndex: Int) {
        let colors = TemperamentChipCell.chipColors[colorIndex]
        
        let icon = getIconForTrait(trait)
        iconLabel.text = icon
        
        titleLabel.text = trait
        containerView.backgroundColor = colors.background
        titleLabel.textColor = colors.text
        iconLabel.textColor = colors.text
        
        addPressDownEffect()
    }
    
    private func getIconForTrait(_ trait: String) -> String {
        let lowercaseTrait = trait.lowercased()
        
        if lowercaseTrait.contains("curious") { return "🔍" }
        if lowercaseTrait.contains("intelligent") { return "🧠" }
        if lowercaseTrait.contains("gentle") { return "🤗" }
        if lowercaseTrait.contains("active") { return "⚡" }
        if lowercaseTrait.contains("playful") { return "🎮" }
        if lowercaseTrait.contains("social") { return "🗣️" }
        if lowercaseTrait.contains("affectionate") { return "💕" }
        if lowercaseTrait.contains("loyal") { return "🛡️" }
        if lowercaseTrait.contains("vocal") { return "🔊" }
        if lowercaseTrait.contains("quiet") { return "🔈" }
        if lowercaseTrait.contains("friendly") { return "👋" }
        
        return "✨"
    }
    
    private func addPressDownEffect() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        containerView.addGestureRecognizer(tapGesture)
        containerView.isUserInteractionEnabled = true
    }
    
    @objc private func handleTap() {
        UIView.animate(withDuration: 0.1, animations: {
            self.containerView.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }, completion: { _ in
            UIView.animate(withDuration: 0.1) {
                self.containerView.transform = CGAffineTransform.identity
            }
        })
        
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconLabel.text = nil
        titleLabel.text = nil
    }
}

