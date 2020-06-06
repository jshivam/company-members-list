//
//  Toast.swift
//  company-members-list
//
//  Created by Shivam Jaiswal on 06/06/20.
//  Copyright © 2020 Shivam Jaiswal. All rights reserved.
//

import Toast
import Foundation

private struct Constants {
    static let animationDuration: TimeInterval = 2.0
}

class Toast {
    private init() {}
    static func configure() {
        var style = ToastStyle()
        style.messageColor = .white
        ToastManager.shared.style = style
        ToastManager.shared.isTapToDismissEnabled = true
        ToastManager.shared.isQueueEnabled = true
        ToastManager.shared.duration = Constants.animationDuration
    }
}
