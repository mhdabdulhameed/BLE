//
//  MainPresenter.swift
//  BLETask
//
//  Created by Mohamed Abdul-Hameed on 3/17/18.
//  Copyright © 2018 Mohamed Abdul-Hameed. All rights reserved.
//

import Foundation

class MainPresenter: MainPresenterProtocol {
    
    private weak var view: MainViewProtocol?
    
    func attachView(view: MainViewProtocol) {
        self.view = view
    }
    
    func connectButtonTapped(BLEDeviceName: String?) {
        guard let BLEDeviceName = BLEDeviceName, BLEDeviceName.count > 0 else {
            view?.showError(title: "Error", message: "You need to enter the name of the BLE device you want to connect to!", buttonTitle: "OK")
            return
        }
        
        BluetoothManager.shared.startScan()
    }
}
