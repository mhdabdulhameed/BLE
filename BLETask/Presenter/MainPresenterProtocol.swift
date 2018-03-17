//
//  MainPresenterProtocol.swift
//  BLETask
//
//  Created by Mohamed Abdul-Hameed on 3/17/18.
//  Copyright © 2018 Mohamed Abdul-Hameed. All rights reserved.
//

import Foundation

protocol MainPresenterProtocol {
    
    /// Set or attach the view to this presenter
    func attachView(view: MainViewProtocol)
    
    func connectButtonTapped(BLEDeviceName: String?)
}
