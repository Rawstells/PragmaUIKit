//
//  CatBreedDetailViewController.swift
//  TheCatAPIUIKit
//
//  Created by joan on 05/04/25.
//

import UIKit

class CatBreedDetailViewController: UIViewController {
    
    // MARK: - Properties
    private let viewModel: CatBreedDetailViewModel
    private var scrollViewInitialOffset: CGFloat = 0
    
    // MARK: - UI Elements
    private let headerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let breedImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .systemGray6
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private lazy var favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        button.layer.cornerRadius = 20
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(toggleFavorite), for: .touchUpInside)
        return button
    }()
    
    private let overlayView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.black.withAlphaComponent(0.4).cgColor
        ]
        gradientLayer.locations = [0.6, 1.0]
        view.layer.insertSublayer(gradientLayer, at: 0)
        return view
    }()
    
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.showsVerticalScrollIndicator = false
        sv.backgroundColor = .clear
        sv.contentInsetAdjustmentBehavior = .never
        return sv
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    private let contentStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 20
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.isLayoutMarginsRelativeArrangement = true
        sv.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 30, right: 20)
        return sv
    }()
    
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private var skeletonViews: [UIView] = []
    
    private lazy var breedInfoCard: UIView = createCard()
    private lazy var temperamentCard: UIView = createCard()
    private lazy var descriptionCard: UIView = createCard()
    private lazy var attributesCard: UIView = createCard()
    private lazy var moreInfoButton: UIButton = createMoreInfoButton()
    
    // MARK: - Initializers
    init(viewModel: CatBreedDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        showSkeletonLoading()
        viewModel.loadBreedImages()
        updateFavoriteButtonState()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let gradientLayer = overlayView.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.frame = overlayView.bounds
        }
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .white
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.tintColor = .white
        
        view.addSubview(headerView)
        headerView.addSubview(breedImageView)
        headerView.addSubview(overlayView)
        headerView.addSubview(favoriteButton)
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(contentStackView)
        
        breedImageView.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        
        let headerHeight = view.bounds.height * 0.4
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: headerHeight),
            
            breedImageView.topAnchor.constraint(equalTo: headerView.topAnchor),
            breedImageView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            breedImageView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            breedImageView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor),
            
            overlayView.topAnchor.constraint(equalTo: headerView.topAnchor),
            overlayView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            overlayView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor),
            
            favoriteButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            favoriteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            favoriteButton.widthAnchor.constraint(equalToConstant: 40),
            favoriteButton.heightAnchor.constraint(equalToConstant: 40),
            
            scrollView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -20),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            contentStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            contentStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: breedImageView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: breedImageView.centerYAnchor)
        ])
        
        scrollView.delegate = self
        
        contentView.layer.cornerRadius = 20
        contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        contentView.backgroundColor = .white
        
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.1
        contentView.layer.shadowRadius = 10
        contentView.layer.shadowOffset = CGSize(width: 0, height: -5)
        
        contentStackView.addArrangedSubview(breedInfoCard)
        contentStackView.addArrangedSubview(temperamentCard)
        contentStackView.addArrangedSubview(descriptionCard)
        contentStackView.addArrangedSubview(attributesCard)
        contentStackView.addArrangedSubview(moreInfoButton)
    }
    
    private func populateBreedData() {
        let breed = viewModel.breed
        
        let nameOriginView = createBreedNameOriginView(name: breed.name, origin: breed.origin)
        addContentToCard(nameOriginView, toCard: breedInfoCard)
        
        let temperamentChipsView = createTemperamentChipsView(traits: breed.temperament.components(separatedBy: ", "))
        addContentToCard(temperamentChipsView, toCard: temperamentCard)
        
        let descriptionView = createDescriptionView(description: breed.description)
        addContentToCard(descriptionView, toCard: descriptionCard)
        
        let attributesView = createAttributesGridView()
        addContentToCard(attributesView, toCard: attributesCard)
        
        hideSkeletonLoading()
    }
    
    // MARK: - Card Creation Methods
    private func createCard() -> UIView {
        let cardView = UIView()
        cardView.backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1.0)
        cardView.layer.cornerRadius = 16
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.05
        cardView.layer.shadowRadius = 8
        cardView.layer.shadowOffset = CGSize(width: 0, height: 2)
        cardView.translatesAutoresizingMaskIntoConstraints = false
        
        cardView.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        return cardView
    }
    
    private func addContentToCard(_ contentView: UIView, toCard card: UIView) {
        card.subviews.forEach { $0.removeFromSuperview() }
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: card.topAnchor, constant: 16),
            contentView.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
            contentView.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -16),
            contentView.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -16)
        ])
    }
    
    // MARK: - Content View Creation Methods
    private func createBreedNameOriginView(name: String, origin: String) -> UIView {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        let trophyIcon = UIImageView(image: UIImage(systemName: "trophy"))
        trophyIcon.tintColor = UIColor(red: 0.18, green: 0.18, blue: 0.18, alpha: 1.0)
        trophyIcon.contentMode = .scaleAspectFit
        trophyIcon.translatesAutoresizingMaskIntoConstraints = false
        
        let nameLabel = UILabel()
        nameLabel.text = name
        nameLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        nameLabel.textColor = UIColor(red: 0.18, green: 0.18, blue: 0.18, alpha: 1.0)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let globeIcon = UIImageView(image: UIImage(systemName: "globe"))
        globeIcon.tintColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        globeIcon.contentMode = .scaleAspectFit
        globeIcon.translatesAutoresizingMaskIntoConstraints = false
        
        let originLabel = UILabel()
        originLabel.text = origin
        originLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        originLabel.textColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        originLabel.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(trophyIcon)
        containerView.addSubview(nameLabel)
        containerView.addSubview(globeIcon)
        containerView.addSubview(originLabel)
        
        NSLayoutConstraint.activate([
            trophyIcon.topAnchor.constraint(equalTo: containerView.topAnchor),
            trophyIcon.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            trophyIcon.widthAnchor.constraint(equalToConstant: 24),
            trophyIcon.heightAnchor.constraint(equalToConstant: 24),
            
            nameLabel.leadingAnchor.constraint(equalTo: trophyIcon.trailingAnchor, constant: 8),
            nameLabel.centerYAnchor.constraint(equalTo: trophyIcon.centerYAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            
            globeIcon.topAnchor.constraint(equalTo: trophyIcon.bottomAnchor, constant: 12),
            globeIcon.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            globeIcon.widthAnchor.constraint(equalToConstant: 20),
            globeIcon.heightAnchor.constraint(equalToConstant: 20),
            globeIcon.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            originLabel.leadingAnchor.constraint(equalTo: globeIcon.trailingAnchor, constant: 8),
            originLabel.centerYAnchor.constraint(equalTo: globeIcon.centerYAnchor),
            originLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])
        
        return containerView
    }
    
    private func createTemperamentChipsView(traits: [String]) -> UIView {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        let headerLabel = UILabel()
        headerLabel.text = "Temperamento"
        headerLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        headerLabel.textColor = UIColor(red: 0.18, green: 0.18, blue: 0.18, alpha: 1.0)
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(TemperamentChipCell.self, forCellWithReuseIdentifier: "TemperamentChipCell")
        collectionView.dataSource = self
        
        containerView.addSubview(headerLabel)
        containerView.addSubview(collectionView)
        
        setTemperamentTraits(traits)
        
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            headerLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            headerLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            
            collectionView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 12),
            collectionView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 44),
            collectionView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        return containerView
    }
    
    private func createDescriptionView(description: String) -> UIView {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        let headerLabel = UILabel()
        headerLabel.text = "Descripción"
        headerLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        headerLabel.textColor = UIColor(red: 0.18, green: 0.18, blue: 0.18, alpha: 1.0)
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let descriptionLabel = UILabel()
        descriptionLabel.text = description
        descriptionLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        descriptionLabel.textColor = .darkGray
        descriptionLabel.numberOfLines = 0
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 8
        
        let attributedText = NSMutableAttributedString(string: description)
        attributedText.addAttribute(
            .paragraphStyle,
            value: paragraphStyle,
            range: NSRange(location: 0, length: attributedText.length)
        )
        
        let keyPhrases = ["love", "affectionate", "friendly", "playful", "intelligent", "social"]
        for phrase in keyPhrases {
            if let range = description.lowercased().range(of: phrase) {
                let nsRange = NSRange(range, in: description)
                attributedText.addAttribute(.font, value: UIFont.systemFont(ofSize: 16, weight: .semibold), range: nsRange)
            }
        }
        
        descriptionLabel.attributedText = attributedText
        
        containerView.addSubview(headerLabel)
        containerView.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            headerLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            headerLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 12),
            descriptionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        return containerView
    }
    
    private func createAttributesGridView() -> UIView {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        let headerLabel = UILabel()
        headerLabel.text = "Datos clave"
        headerLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        headerLabel.textColor = UIColor(red: 0.18, green: 0.18, blue: 0.18, alpha: 1.0)
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let lifeSpanRow = createAttributeRow(
            icon: "clock",
            title: "Esperanza de vida:",
            value: viewModel.breed.lifeSpan,
            valueColor: .darkGray
        )
        
        let attributesStack = UIStackView()
        attributesStack.axis = .vertical
        attributesStack.spacing = 16
        attributesStack.translatesAutoresizingMaskIntoConstraints = false
        
        let attributes = [
            (name: "Adaptabilidad", icon: "house", value: viewModel.breed.adaptability),
            (name: "Afectuosidad", icon: "heart", value: viewModel.breed.affectionLevel),
            (name: "Niños", icon: "figure.2.and.child.holdinghands", value: viewModel.breed.childFriendly),
            (name: "Perros", icon: "dog", value: viewModel.breed.dogFriendly),
            (name: "Energía", icon: "bolt", value: viewModel.breed.energyLevel),
            (name: "Salud", icon: "cross.case", value: viewModel.breed.healthIssues),
            (name: "Inteligencia", icon: "brain.head.profile", value: viewModel.breed.intelligence)
        ]
        
        containerView.addSubview(headerLabel)
        containerView.addSubview(lifeSpanRow)
        containerView.addSubview(attributesStack)
        
        let divider = UIView()
        divider.backgroundColor = UIColor.systemGray5
        divider.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(divider)
        
        for attribute in attributes {
            let attributeView = createRatingRow(title: attribute.name, icon: attribute.icon, rating: attribute.value)
            attributesStack.addArrangedSubview(attributeView)
        }
        
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            headerLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            headerLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            
            lifeSpanRow.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 12),
            lifeSpanRow.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            lifeSpanRow.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            
            divider.topAnchor.constraint(equalTo: lifeSpanRow.bottomAnchor, constant: 16),
            divider.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            divider.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            divider.heightAnchor.constraint(equalToConstant: 1),
            
            attributesStack.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 16),
            attributesStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            attributesStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            attributesStack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        return containerView
    }
    
    private func createAttributeRow(icon: String, title: String, value: String, valueColor: UIColor) -> UIView {
        let rowView = UIView()
        rowView.translatesAutoresizingMaskIntoConstraints = false
        
        let iconView = UIImageView(image: UIImage(systemName: icon))
        iconView.tintColor = .systemBlue
        iconView.contentMode = .scaleAspectFit
        iconView.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = .darkGray
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        valueLabel.textColor = valueColor
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        rowView.addSubview(iconView)
        rowView.addSubview(titleLabel)
        rowView.addSubview(valueLabel)
        
        NSLayoutConstraint.activate([
            iconView.leadingAnchor.constraint(equalTo: rowView.leadingAnchor),
            iconView.centerYAnchor.constraint(equalTo: rowView.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 24),
            iconView.heightAnchor.constraint(equalToConstant: 24),
            
            titleLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 8),
            titleLabel.centerYAnchor.constraint(equalTo: rowView.centerYAnchor),
            
            valueLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 8),
            valueLabel.centerYAnchor.constraint(equalTo: rowView.centerYAnchor),
            valueLabel.trailingAnchor.constraint(equalTo: rowView.trailingAnchor),
            
            rowView.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        return rowView
    }
    
    private func createRatingRow(title: String, icon: String, rating: Int) -> UIView {
        let rowView = UIView()
        rowView.translatesAutoresizingMaskIntoConstraints = false
        
        let iconView = UIImageView(image: UIImage(systemName: icon))
        iconView.tintColor = .systemBlue
        iconView.contentMode = .scaleAspectFit
        iconView.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = .darkGray
        titleLabel.setContentHuggingPriority(.required, for: .horizontal)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let ratingView = UIStackView()
        ratingView.axis = .horizontal
        ratingView.spacing = 4
        ratingView.distribution = .fillEqually
        ratingView.translatesAutoresizingMaskIntoConstraints = false
        
        for i in 1...5 {
            let isActive = i <= rating
            let dot = UIImageView()
            dot.contentMode = .scaleAspectFit
            
            if isActive {
                dot.image = UIImage(systemName: "checkmark.circle.fill")
                dot.tintColor = rating >= 4 ? .systemGreen : (rating <= 2 ? .systemRed : .systemOrange)
            } else {
                dot.image = UIImage(systemName: "circle")
                dot.tintColor = .systemGray3
            }
            
            NSLayoutConstraint.activate([
                dot.widthAnchor.constraint(equalToConstant: 16),
                dot.heightAnchor.constraint(equalToConstant: 16)
            ])
            
            ratingView.addArrangedSubview(dot)
        }
        
        rowView.addSubview(iconView)
        rowView.addSubview(titleLabel)
        rowView.addSubview(ratingView)
        
        NSLayoutConstraint.activate([
            iconView.leadingAnchor.constraint(equalTo: rowView.leadingAnchor),
            iconView.centerYAnchor.constraint(equalTo: rowView.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 24),
            iconView.heightAnchor.constraint(equalToConstant: 24),
            
            titleLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 8),
            titleLabel.centerYAnchor.constraint(equalTo: rowView.centerYAnchor),
            
            ratingView.leadingAnchor.constraint(greaterThanOrEqualTo: titleLabel.trailingAnchor, constant: 8),
            ratingView.trailingAnchor.constraint(equalTo: rowView.trailingAnchor),
            ratingView.centerYAnchor.constraint(equalTo: rowView.centerYAnchor),
            
            rowView.heightAnchor.constraint(equalToConstant: 36)
        ])
        
        return rowView
    }
    
    private func createMoreInfoButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("Más información", for: .normal)
        button.setImage(UIImage(systemName: "info.circle"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = UIColor(red: 1.0, green: 0.42, blue: 0.42, alpha: 1.0)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.layer.cornerRadius = 12
        button.contentEdgeInsets = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.15
        button.layer.shadowRadius = 6
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        
        button.addTarget(self, action: #selector(moreInfoButtonTapped), for: .touchUpInside)
        
        return button
    }
    
    // MARK: - Loading / Skeleton Views
    private func showSkeletonLoading() {
        skeletonViews = [
            createSkeletonCard(height: 80),
            createSkeletonCard(height: 100),
            createSkeletonCard(height: 200),
            createSkeletonCard(height: 250)
        ]
        
        skeletonViews.forEach { skeleton in
            contentStackView.addArrangedSubview(skeleton)
        }
        
        breedInfoCard.isHidden = true
        temperamentCard.isHidden = true
        descriptionCard.isHidden = true
        attributesCard.isHidden = true
        moreInfoButton.isHidden = true
        
        animateSkeletons()
    }
    
    private func hideSkeletonLoading() {
        skeletonViews.forEach { $0.removeFromSuperview() }
        skeletonViews = []
        
        breedInfoCard.isHidden = false
        temperamentCard.isHidden = false
        descriptionCard.isHidden = false
        attributesCard.isHidden = false
        moreInfoButton.isHidden = false
    }
    
    private func createSkeletonCard(height: CGFloat) -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1.0)
        view.layer.cornerRadius = 16
        
        let pulseLayer = CAGradientLayer()
        pulseLayer.startPoint = CGPoint(x: 0, y: 0.5)
        pulseLayer.endPoint = CGPoint(x: 1, y: 0.5)
        pulseLayer.colors = [
            UIColor.systemGray5.cgColor,
            UIColor.systemGray4.cgColor,
            UIColor.systemGray5.cgColor
        ]
        pulseLayer.locations = [0, 0.5, 1]
        pulseLayer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 40, height: height)
        pulseLayer.cornerRadius = 16
        view.layer.addSublayer(pulseLayer)
        view.tag = 100
        
        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: height)
        ])
        
        return view
    }
    
    private func animateSkeletons() {
        for view in skeletonViews {
            guard let pulseLayer = view.layer.sublayers?.first as? CAGradientLayer else { continue }
            
            let animation = CABasicAnimation(keyPath: "locations")
            animation.fromValue = [-1.0, -0.5, 0.0]
            animation.toValue = [1.0, 1.5, 2.0]
            animation.duration = 1.5
            animation.repeatCount = .infinity
            pulseLayer.add(animation, forKey: "pulsing")
        }
    }
    
    // MARK: - Helper Methods for Temperaments
    private var temperamentTraits: [String] = []
    
    private func setTemperamentTraits(_ traits: [String]) {
        temperamentTraits = traits
    }
    
    // MARK: - Actions
    @objc private func toggleFavorite() {
        guard let image = viewModel.breedImages.first else {
            showAlert(title: "Error", message: "No hay imagen disponible para añadir a favoritos")
            return
        }
        
        if viewModel.isFavorite {
            viewModel.removeFromFavorites()
        } else {
            viewModel.addToFavorites(imageId: image.id) { [weak self] success, error in
                if !success, let error = error {
                    self?.showAlert(title: "Error", message: error.localizedDescription)
                }
            }
        }
        
        animateFavoriteButton()
        
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
    
    @objc private func moreInfoButtonTapped() {
        if let wikipediaUrl = viewModel.breed.wikipediaUrl, let url = URL(string: wikipediaUrl) {
            let webViewController = WebViewController(url: url)
            let navigationController = UINavigationController(rootViewController: webViewController)
            navigationController.modalPresentationStyle = .fullScreen
            present(navigationController, animated: true)
        } else if let searchQuery = viewModel.breed.name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                  let googleUrl = URL(string: "https://www.google.com/search?q=\(searchQuery)+cat+breed") {
            let webViewController = WebViewController(url: googleUrl)
            let navigationController = UINavigationController(rootViewController: webViewController)
            navigationController.modalPresentationStyle = .fullScreen
            present(navigationController, animated: true)
        } else {
            showAlert(title: "Error", message: "No se pudo abrir la información adicional.")
        }
    }
    
    // MARK: - Setup Bindings
    private func setupBindings() {
        viewModel.onImagesLoaded = { [weak self] in
            guard let self = self, let firstImage = self.viewModel.breedImages.first else { return }
            self.loadBreedImage(from: firstImage.url)
            self.populateBreedData()
        }
        
        viewModel.onLoadingStateChanged = { [weak self] in
            if self?.viewModel.isLoading == true {
                self?.activityIndicator.startAnimating()
            } else {
                self?.activityIndicator.stopAnimating()
            }
        }
        
        viewModel.onErrorOccurred = { [weak self] errorMessage in
            self?.showAlert(title: "Error", message: errorMessage)
        }
        
        viewModel.onFavoriteStatusChanged = { [weak self] isFavorite in
            self?.updateFavoriteButtonState()
        }
    }
    
    private func loadBreedImage(from urlString: String) {
        ImageLoader.shared.loadImage(from: urlString) { [weak self] image in
            DispatchQueue.main.async {
                self?.breedImageView.image = image ?? UIImage(systemName: "photo")
                self?.activityIndicator.stopAnimating()
                
                self?.breedImageView.alpha = 0
                UIView.animate(withDuration: 0.3) {
                    self?.breedImageView.alpha = 1
                }
            }
        }
    }
    
    private func updateFavoriteButtonState() {
        let isFavorite = viewModel.isFavorite
        
        if isFavorite {
            favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            favoriteButton.tintColor = UIColor(red: 1.0, green: 0.42, blue: 0.42, alpha: 1.0)
        } else {
            favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
            favoriteButton.tintColor = .white
        }
    }
    
    private func animateFavoriteButton() {
        UIView.animate(withDuration: 0.1, animations: {
            self.favoriteButton.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }, completion: { _ in
            UIView.animate(withDuration: 0.1) {
                self.favoriteButton.transform = CGAffineTransform.identity
            }
        })
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UIScrollViewDelegate
extension CatBreedDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        
        if offset < 0 {
            let scale = min(1 + abs(offset) / 500, 1.1)
            breedImageView.transform = CGAffineTransform(scaleX: scale, y: scale)
        } else {
            let scale = max(1 - offset / 1000, 0.95)
            breedImageView.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
        
        let headerHeight = headerView.bounds.height
        let alpha = min(offset / (headerHeight / 2), 1)
        
        if alpha > 0.5 {
            navigationController?.navigationBar.tintColor = .systemBlue
            title = viewModel.breed.name
        } else {
            navigationController?.navigationBar.tintColor = .white
            title = ""
        }
    }
}

// MARK: - UICollectionViewDataSource
extension CatBreedDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return temperamentTraits.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TemperamentChipCell", for: indexPath) as? TemperamentChipCell else {
            return UICollectionViewCell()
        }
        
        let trait = temperamentTraits[indexPath.item]
        let colorIndex = indexPath.item % TemperamentChipCell.chipColors.count
        cell.configure(with: trait, colorIndex: colorIndex)
        
        return cell
    }
}
