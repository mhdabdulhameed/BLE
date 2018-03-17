//
//  ViewController.swift
//  BLETask
//
//  Created by Mohamed Abdul-Hameed on 3/17/18.
//  Copyright © 2018 Mohamed Abdul-Hameed. All rights reserved.
//

import UIKit

class MainViewController: UITableViewController {
    
    let presenter: MainPresenterProtocol = MainPresenter()
    
    // - MARK: IBOutlets

    @IBOutlet weak var BLEDeviceNameTextField: UITextField!
    
    // - MARK: - IBActions
    
    @IBAction func connectButtonTapped(_ sender: UIButton) {
        presenter.connectButtonTapped(BLEDeviceName: BLEDeviceNameTextField.text)
    }
    
    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.attachView(view: self)
    }
}

extension MainViewController: MainViewProtocol {
    func showError(title: String, message: String, buttonTitle: String) {
        showAlert(title: title, message: message, buttonTitle: buttonTitle)
    }
}
