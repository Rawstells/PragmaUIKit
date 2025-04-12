//
//  CatBreedCell.swift
//  TheCatAPIUIKit
//
//  Created by joan on 04/04/25.
//

import UIKit

class CatBreedCell: UITableViewCell {
    static let identifier = "CatBreedCell"
    
    // MARK: - UI Elements
    private let cardView: UIView = {
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
        imageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        imageView.layer.cornerRadius = 12
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let placeholderImage = UIImage(systemName: "cat")?.withTintColor(.systemGray3, renderingMode: .alwaysOriginal)
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let originLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let characteristicsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = .secondaryLabel
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .separator
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        contentView.addSubview(cardView)
        cardView.addSubview(catImageView)
        cardView.addSubview(nameLabel)
        cardView.addSubview(originLabel)
        cardView.addSubview(characteristicsLabel)
        cardView.addSubview(separatorView)
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            catImageView.topAnchor.constraint(equalTo: cardView.topAnchor),
            catImageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            catImageView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor),
            catImageView.widthAnchor.constraint(equalTo: catImageView.heightAnchor),
            catImageView.widthAnchor.constraint(equalToConstant: 100),
            
            nameLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            nameLabel.leadingAnchor.constraint(equalTo: catImageView.trailingAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
            
            originLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            originLabel.leadingAnchor.constraint(equalTo: catImageView.trailingAnchor, constant: 12),
            originLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
            
            characteristicsLabel.topAnchor.constraint(equalTo: originLabel.bottomAnchor, constant: 4),
            characteristicsLabel.leadingAnchor.constraint(equalTo: catImageView.trailingAnchor, constant: 12),
            characteristicsLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
            
            separatorView.leadingAnchor.constraint(equalTo: catImageView.trailingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            separatorView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        catImageView.image = placeholderImage
    }
    
    // MARK: - Configuration
    func configure(with breed: CatBreed) {
        nameLabel.text = breed.name
        originLabel.text = breed.origin
        characteristicsLabel.text = breed.temperament
        
        if let imageId = breed.referenceImageId {
            loadBreedImage(imageId: imageId)
        } else {
            catImageView.image = placeholderImage
        }
    }
    
    private func loadBreedImage(imageId: String) {
        let imageUrlString = "https://cdn2.thecatapi.com/images/\(imageId).jpg"
        
        ImageLoader.shared.loadImage(from: imageUrlString) { [weak self] image in
            DispatchQueue.main.async {
                self?.catImageView.image = image ?? self?.placeholderImage
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        originLabel.text = nil
        characteristicsLabel.text = nil
        catImageView.image = placeholderImage
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        cardView.layer.shadowPath = UIBezierPath(roundedRect: cardView.bounds, cornerRadius: cardView.layer.cornerRadius).cgPath
    }
}
