//
//  FollowButton.swift
//  company-members-list
//
//  Created by Shivam Jaiswal on 06/06/20.
//  Copyright © 2020 Shivam Jaiswal. All rights reserved.
//

import UIKit

private struct Constatns {
    static let borderWidth: CGFloat = 1.0
    static let followingText = "Following"
    static let followText = "Follow"
}

class FollowButton: UIButton {
    var isFollowing = false {
        willSet {
            guard newValue != self.isFollowing else { return }
            refreshView(newValue)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        adjustSubViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        adjustSubViews()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height * 0.5
    }

    private func adjustSubViews() {
        setTitle(Constatns.followText, for: .normal)
        layer.borderWidth = Constatns.borderWidth
        layer.borderColor = tintColor.cgColor
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }

    @objc private func buttonTapped() {
        isFollowing.toggle()
    }

    func refreshView(_ isFollowing: Bool) {
        self.setNeedsLayout()
        self.setTitle(isFollowing ? Constatns.followingText : Constatns.followText , for: .normal)
        self.backgroundColor = isFollowing ? self.tintColor : .clear
        self.setTitleColor(isFollowing ? .white : self.tintColor, for: .normal)
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {
            self.layoutIfNeeded()
        }, completion: nil)
    }

    override var tintColor: UIColor! {
        didSet {
            layer.borderColor = tintColor.cgColor
        }
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + .sidePadding, height: size.height)
    }
}
