//
//  AIReachabilityManager.swift
//  Copyright © 2018 agile. All rights reserved.
//

import Foundation
//import Reachability

class AIReachabilityManager: NSObject {
	
	private let reachability = Reachability()!
	private var isFirstTimeSetupDone:Bool = false
	private var callCounter:Int = 0
	
	// MARK: - SHARED MANAGER
	static let shared: AIReachabilityManager = AIReachabilityManager()

	
	//MARK:- ALL NETWORK CHECK
	func isInternetAvailableForAllNetworks() -> Bool {
		if(!self.isFirstTimeSetupDone){
			self.isFirstTimeSetupDone = true
			doSetupReachability()
		}
        
    return reachability.connection != .none ||  reachability.connection == .wifi || reachability.connection == .cellular
        
//		return reachability.connection || reachability.isReachableViaWiFi || reachability.isReachableViaWWAN
	}
	
	
	//MARK:- SETUP
	private func doSetupReachability() {
	
		reachability.whenReachable = { [unowned self] reachability in
			DispatchQueue.main.async {
				self.postIntenetReachabilityDidChangeNotification(isInternetAvailable: true)
			}
		}
		reachability.whenUnreachable = { [unowned self] reachability in
			DispatchQueue.main.async {
				self.postIntenetReachabilityDidChangeNotification(isInternetAvailable: false)
			}
		}
		do{
			try reachability.startNotifier()
		}catch{
		}
	}
	
	deinit {
		reachability.stopNotifier()
//        NotificationCenter.default.removeObserver(self, name: ReachabilityChangedNotification, object: nil)
	}

	
	
	//MARK:- NOTIFICATION
	private func postIntenetReachabilityDidChangeNotification(isInternetAvailable isAvailable:Bool){
		
		DispatchQueue.main.async {
			if(isAvailable){
				// TO AVOID INITIAL ALERT
				if(self.callCounter != 0){
                    print("You are now ONLINE")
				}
			}else{
                print("You are now OFFLINE")
			}
			self.callCounter += 1
		}
		
	}
}
