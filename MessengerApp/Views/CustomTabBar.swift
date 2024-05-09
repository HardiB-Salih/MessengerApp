//
//  CustomTabBar.swift
//  MessengerApp
//
//  Created by HardiB.Salih on 5/9/24.
//

import UIKit

class CustomTabBar: UITabBar {

    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Round the corners of the tab bar
        self.layer.cornerRadius = 30
        self.layer.cornerCurve = .continuous
//        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
//        self.backgroundColor = .secondarySystemBackground.withAlphaComponent(0.4)
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.systemGray.withAlphaComponent(0.4).cgColor
        self.tintColor = UIColor.link
        self.clipsToBounds = true
        
        // Create a blur effect view
        let blurEffect = UIBlurEffect(style: .systemMaterial)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        
        // Create a vibrancy effect view
        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
        let vibrancyEffectView = UIVisualEffectView(effect: vibrancyEffect)
        vibrancyEffectView.frame = self.bounds
        
        // Add the vibrancy effect view as a subview of the blur effect view
        blurEffectView.contentView.addSubview(vibrancyEffectView)
        
        // Add the blur effect view as a subview
        self.insertSubview(blurEffectView, at: 0)
        
        // Position the tab bar with 10 points offset from bottom left and right
        let tabBarHeight = self.frame.size.height
        let tabBarWidth = self.superview!.bounds.width - CGFloat(30)
        let tabBarX = CGFloat(15) // Offset from left
        let tabBarY = self.superview!.bounds.height - tabBarHeight - CGFloat(24) // Offset from bottom
        

        
        self.frame = CGRect(x: tabBarX, y: tabBarY, width: tabBarWidth, height: tabBarHeight)
    }
}
