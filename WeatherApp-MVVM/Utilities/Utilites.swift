//
//  Utilites.swift
//  WeatherApp-MVVM
//
//  Created by Dhaval Dobariya on 09/03/23.
//

import UIKit
import Foundation
import Photos


/// Get app root window
/// - Returns: Scene UIWindow
func getDeleteWindow() -> UIWindow? {
    let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
    if let sceneDelegate = windowScene?.delegate as? SceneDelegate {
      return sceneDelegate.window
    }
    return nil
}

func IS_INTERNET_AVAILABLE() -> Bool{
    return AIReachabilityManager.shared.isInternetAvailableForAllNetworks()
}

func SHOW_INTERNET_ALERT() {
    if let vc = getDeleteWindow()?.rootViewController {
        showAlertWithTitleFromVC(vc: vc, title: "Weather", andMessage: INTERNET_MESSAGE, buttons: ["OK"]) { index in
        }
    }
}

let INTERNET_MESSAGE:String = "Please check your internet connection and try again."

/// Show weather app alert
/// - Parameters:
///   - vc: parent view controller for presented UIAlertController
///   - title: Specify alert title
///   - message: Specify alert description info
///   - buttons: Array of button names
///   - completion: Buttons tapped completion handel with associated index value
/// - Returns: Nathing
func showAlertWithTitleFromVC(vc:UIViewController, title:String, andMessage message:String, buttons:[String], completion:((_ index:Int) -> Void)!) -> Void {
    
    var newMessage = message
    if newMessage == "The Internet connection appears to be offline." {
        newMessage = INTERNET_MESSAGE
    }
    
    
    let alertController = UIAlertController(title: title, message: newMessage, preferredStyle: .alert)
    for index in 0..<buttons.count    {
        
        let action = UIAlertAction(title: buttons[index], style: .default, handler: {
            (alert: UIAlertAction!) in
            if(completion != nil){
                completion(index)
            }
        })
        
        alertController.addAction(action)
    }
    
    vc.present(alertController, animated: true, completion: nil)
}

// MARK: - check Media Permition

enum MedialType: Int {
    case photo
    case camera
}

/// Check permistion of other app media
/// - Parameters:
///   - type: Photo pick of specific app like photo library or camera
///   - completion: Permission granted to completion handler
func checkMediaPermition(type: MedialType, completion:(() -> Void)?) {
    switch type {
    
    case .camera:
        let cameraSatus = AVCaptureDevice.authorizationStatus(for: .video)
        switch cameraSatus {
        case .authorized:
            completion?()
        case .denied:
            showSettingAlert(type)
        default:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    DispatchQueue.main.sync {
                        completion?()
                    }
                }
            }
        }
        
    case .photo:
        let photosStatus = PHPhotoLibrary.authorizationStatus()
        switch photosStatus {
        case .authorized, .limited:
            completion?()
        case .denied:
            showSettingAlert(type)
        default:
            PHPhotoLibrary.requestAuthorization { status in
                if status == .authorized {
                    DispatchQueue.main.sync {
                        completion?()
                    }
                }
            }
        }
        break
    }
}

/// Alert for user denie permistion of open app
/// - Parameter type: Photo pick of specific app like photo library or camera
func showSettingAlert(_ type: MedialType) {
    guard let window = getDeleteWindow()  else {
        return
    }
    if let parentController = window.rootViewController {
        let title = type == .camera ? "Enable Camera Access" : "Enable Photo Access"
        let message =  type == .camera ? "Go to Settings >> Privacy and Enable Camera access." : "Go to Settings >> Privacy and Enable Photo access."
        showAlertWithTitleFromVC(vc: parentController, title: title, andMessage: message, buttons: ["Cancel", "Setting"]) { index in
            if index == 1 {
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, options: [ : ], completionHandler: nil)
                }
            }
        }
    }else {
        print("not found root")
    }
}
