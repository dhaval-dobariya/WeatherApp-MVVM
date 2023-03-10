//
//  UITableView+Extensions.swift
//  WeatherApp-MVVM
//
//  Created by Dhaval Dobariya on 09/03/23.
//

import UIKit

extension UITableView {
    
    func registerCell<T: UITableViewCell>(_: T.Type){
        self.register(T.nibName, forCellReuseIdentifier: T.className)
    }
    func dequeueReusableCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.className, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.className)")
        }
        return cell
    }
}

extension NSObject {
    
    static var className: String {
        return String(describing: self)
    }
    
    static var nibName : UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
}
