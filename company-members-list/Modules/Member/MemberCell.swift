//
//  MemberCell.swift
//  company-members-list
//
//  Created by Shivam Jaiswal on 06/06/20.
//  Copyright © 2020 Shivam Jaiswal. All rights reserved.
//

import UIKit
import Stevia

private struct Constants {
    static let titleLabelFontSize: CGFloat = 16
    static let subTitleLabelFontSize: CGFloat = 16
}

class MemberCell: UITableViewCell {
    private let nameLabel = UILabel()
    private let emailButton = UIButton(type: .system)
    private let ageLabel = UILabel()
    private let phoneButton = UIButton(type: .system)
    private let favoriteButton = FavoriteButton(type: .system)
    private (set) var member: Member?

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
        contentView.subviews(nameLabel, emailButton, ageLabel, phoneButton, favoriteButton)
    }

    private func adjustSubViews() {
        nameLabel.style {
            $0.numberOfLines = 0
            $0.font = UIFont.systemFont(ofSize: Constants.titleLabelFontSize)
            $0.textColor = .darkText
        }

        ageLabel.style {
            $0.font = UIFont.systemFont(ofSize: Constants.subTitleLabelFontSize)
            $0.textColor = .lightGray
        }

        favoriteButton.style {
            $0.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        }
    }

    private func setupConstraints() {
        nameLabel.top(CGFloat.sidePadding).leading(CGFloat.sidePadding)
        favoriteButton.Top == nameLabel.Top
        favoriteButton.trailing(CGFloat.sidePadding)

        ageLabel.Top == nameLabel.Top
        ageLabel.Leading == nameLabel.Trailing

        phoneButton.Top == nameLabel.Bottom
        phoneButton.Leading == nameLabel.Leading

        emailButton.Top == phoneButton.Bottom
        emailButton.Leading == nameLabel.Leading
        emailButton.bottom(CGFloat.verticalPadding)
    }

    @objc private func favoriteButtonTapped(_ sender: FavoriteButton) {
        member?.isfavorite = sender.isFavorite
    }

    func configure(member: Member) {
        self.member = member
        nameLabel.text = "\(member.name.first) \(member.name.last)"
        ageLabel.text = ", \(member.age)"
        phoneButton.setTitle(member.phone, for: .normal)
        emailButton.setTitle(member.email, for: .normal)
        favoriteButton.isFavorite = member.isfavorite
    }
}
