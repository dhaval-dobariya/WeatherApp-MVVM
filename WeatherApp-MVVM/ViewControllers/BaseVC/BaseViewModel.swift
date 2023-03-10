//
//  BaseViewModel.swift
//  WeatherApp-MVVM
//
//  Created by Dhaval Dobariya on 10/03/23.
//

import Foundation

enum BaseViewModelChange {
    case loaderStart
    case loaderEnd
    case error(message: String)
}


class BaseViewModel {
    
    var changeHandler:((BaseViewModelChange)->Void)?
}
