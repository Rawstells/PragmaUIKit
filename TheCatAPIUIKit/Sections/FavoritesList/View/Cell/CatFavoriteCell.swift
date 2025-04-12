//
//  CatFavoriteCell.swift
//  TheCatAPIUIKit
//
//  Created by joan on 06/04/25.
//

import UIKit

class CatFavoriteCell: UICollectionViewCell {
    
    // MARK: - UI Elements
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 12
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowRadius = 4
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let catImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemGray5
        imageView.layer.cornerRadius = 8
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let originLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        button.tintColor = .systemRed
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        contentView.addSubview(containerView)
        
        containerView.addSubview(catImageView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(originLabel)
        containerView.addSubview(favoriteButton)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            catImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            catImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            catImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            catImageView.heightAnchor.constraint(equalTo: catImageView.widthAnchor, multiplier: 0.75),
            
            nameLabel.topAnchor.constraint(equalTo: catImageView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(equalTo: favoriteButton.leadingAnchor, constant: -8),
            
            originLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            originLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            originLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            originLabel.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -12),
            
            favoriteButton.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),
            favoriteButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            favoriteButton.widthAnchor.constraint(equalToConstant: 24),
            favoriteButton.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    // MARK: - Configuration
    func configure(with favorite: FavoriteData) {
        nameLabel.text = favorite.breedName
        originLabel.text = favorite.origin
        
        loadImage(imageId: favorite.imageId)
    }
    
    private func loadImage(imageId: String) {
        let imageUrlString = "https://cdn2.thecatapi.com/images/\(imageId).jpg"
        ImageLoader.shared.loadImage(from: imageUrlString) { [weak self] image in
            DispatchQueue.main.async {
                self?.catImageView.image = image ?? UIImage(systemName: "photo")
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        catImageView.image = nil
        nameLabel.text = nil
        originLabel.text = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.layer.shadowPath = UIBezierPath(roundedRect: containerView.bounds, cornerRadius: containerView.layer.cornerRadius).cgPath
    }
}
