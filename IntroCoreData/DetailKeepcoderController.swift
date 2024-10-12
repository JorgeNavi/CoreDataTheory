//
//  DetailKeepcoderController.swift
//  IntroCoreData
//
//  Created by Pedro on 10/10/24.
//

import UIKit

class DetailKeepcoderController: UIViewController {

    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtBootCamp: UITextField!
    private let storeDataPRovider: StoreDataProvider = .shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    // Al pulsar el botón de aceptar
    // Si hay nombre no hacemos nada
    // Si lo hay creramos el registro en Base dedtaos validando el valor de botcamp
    @IBAction func btnAccepTapped(_ sender: Any) {
        guard let name = txtName.text, !name.isEmpty else { return }
        var bootCamp: String?
        if let bootCampText = txtBootCamp.text, !bootCampText.isEmpty {
            bootCamp = bootCampText
        }
        storeDataPRovider.addKeepCoder(name: name, bootCamp: bootCamp)
        
        navigationController?.popViewController(animated: true)
    }
}
