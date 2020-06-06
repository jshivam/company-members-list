//
//  CompanyCell.swift
//  company-members-list
//
//  Created by Shivam Jaiswal on 06/06/20.
//  Copyright © 2020 Shivam Jaiswal. All rights reserved.
//

import UIKit
import Stevia

private struct Constants {
    static let titleLabelFontSize: CGFloat = 16
    static let subTitleLabelFontSize: CGFloat = 14
    static let logoDimention: CGFloat = 80
}

class CompanyCell: UITableViewCell {
    private let nameLabel = UILabel()
    private let logoImageView = UIImageView()
    private let websiteButton = UIButton(type: .system)
    private let descriptionLabel = UILabel()
    private let followButton = FollowButton(type: .system)
    private let favoriteButton = FavoriteButton(type: .system)
    private (set) var company: Company?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubViews()
        adjustSubViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubViews() {
        contentView.subviews(nameLabel, logoImageView, websiteButton, descriptionLabel, followButton, favoriteButton)
    }

    private func adjustSubViews() {
        nameLabel.style {
            $0.numberOfLines = 0
            $0.font = UIFont.systemFont(ofSize: Constants.titleLabelFontSize)
            $0.textColor = .darkText
        }

        descriptionLabel.style {
            $0.numberOfLines = 0
            $0.font = UIFont.systemFont(ofSize: Constants.subTitleLabelFontSize)
            $0.textColor = .lightGray
        }

        logoImageView.style {
            $0.contentMode = .scaleAspectFill
            $0.layer.cornerRadius = .cornerRadius
            $0.clipsToBounds = true
        }

        followButton.style {
            $0.addTarget(self, action: #selector(followButtonTapped), for: .touchUpInside)
        }

        favoriteButton.style {
            $0.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        }
    }

    private func setupConstraints() {
        logoImageView.left(CGFloat.sidePadding).top(CGFloat.sidePadding).size(Constants.logoDimention)
        logoImageView.bottom(>=CGFloat.sidePadding)

        followButton.Top == logoImageView.Top
        followButton.trailing(CGFloat.sidePadding)

        nameLabel.Leading == logoImageView.Trailing + CGFloat.sidePadding
        nameLabel.Top == logoImageView.Top

        favoriteButton.Top == nameLabel.Top
        favoriteButton.Leading == nameLabel.Trailing + CGFloat.sidePadding
        favoriteButton.Trailing == followButton.Leading - CGFloat.sidePadding

        websiteButton.Top == nameLabel.Bottom
        websiteButton.Leading == nameLabel.Leading

        descriptionLabel.Leading == nameLabel.Leading
        descriptionLabel.Top == websiteButton.Bottom
        descriptionLabel.trailing(CGFloat.sidePadding).bottom(CGFloat.sidePadding)
    }

    @objc private func followButtonTapped(_ sender: FollowButton) {
        company?.isfollwing = sender.isFollowing
    }

    @objc private func favoriteButtonTapped(_ sender: FavoriteButton) {
        company?.isfavorite = sender.isFavorite
    }

    func configure(company: Company) {
        self.company = company
        logoImageView.loadImage(url: company.logo)
        nameLabel.text = company.company
        websiteButton.setTitle(company.website.absoluteString, for: .normal)
        descriptionLabel.text = company.about
        favoriteButton.isFavorite = company.isfavorite
        followButton.isFollowing = company.isfollwing
    }
}
