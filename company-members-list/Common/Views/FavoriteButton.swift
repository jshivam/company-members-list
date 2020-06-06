//
//  FavoriteButton.swift
//  company-members-list
//
//  Created by Shivam Jaiswal on 06/06/20.
//  Copyright © 2020 Shivam Jaiswal. All rights reserved.
//

import UIKit

class FavoriteButton: UIButton {
    var isFavorite = false {
        willSet {
            guard newValue != self.isFavorite else { return }
            newValue ? setImage(#imageLiteral(resourceName: "heart_filled"), for: .normal) : setImage(#imageLiteral(resourceName: "heart"), for: .normal)
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

    private func adjustSubViews() {
        setImage(#imageLiteral(resourceName: "heart"), for: .normal)
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }

    @objc private func buttonTapped() {
        isFavorite.toggle()
    }
}
