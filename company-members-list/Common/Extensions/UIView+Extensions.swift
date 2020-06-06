//
//  UIView+Extension.swift
//  company-members-list
//
//  Created by Shivam Jaiswal on 06/06/20.
//  Copyright © 2020 Shivam Jaiswal. All rights reserved.
//

import UIKit
import Toast

extension UIView {
    func showToast(_ message: String?) {
        self.makeToast(message, position: .bottom, style: ToastManager.shared.style)
    }

    func hide() {
        self.hideAllToasts()
    }
}
