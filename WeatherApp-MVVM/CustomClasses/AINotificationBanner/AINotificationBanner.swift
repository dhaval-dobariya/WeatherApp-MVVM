//
//  AINotificationBanner.swift
//  WeatherApp-MVVM
//
//  Created by Dhaval Dobariya on 10/08/21.
//

import UIKit
import NotificationBannerSwift

let AlertBanner = AINotificationBanner.shared

/// Show app alert as a notification banner
class AINotificationBanner {
    
    static let shared = AINotificationBanner()
    var banner: NotificationBanner?
    
    /// Show top success banner
    /// - Parameter message: show message in bannner
    func success(message: String) {
        banner?.dismiss()
        banner = NotificationBanner(title: "", subtitle: message, style: .success, colors: CustomBannerColors())
        banner?.show(bannerPosition: .top)
    }

    /// Show top failer banner
    /// - Parameter message: show message in bannner
    func failer(message: String) {
        banner?.dismiss()
        banner = NotificationBanner(title: "", subtitle: message, style: .info, colors: CustomBannerColors())
        banner?.show(bannerPosition: .top)
    }
    
    /// Show top notification banner
    /// - Parameter message: show message in bannner
    func notification(message: String) {
        banner?.dismiss()
        banner = NotificationBanner(title: "", subtitle: message, style: .info, colors: CustomBannerColors())
        banner?.show(bannerPosition: .top)
    }
}

class CustomBannerColors: BannerColorsProtocol {

    internal func color(for style: BannerStyle) -> UIColor {
        
        switch style {
        case .danger:
            return  UIColor.red // Your custom .danger color
        case .info:
            return  UIColor.black  // Your custom .info color
        default:
            return  UIColor.black
        }
    }

}
