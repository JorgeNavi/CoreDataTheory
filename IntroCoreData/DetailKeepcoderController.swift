import UIKit

class DetailKeepcoderController: UIViewController {

    @IBOutlet weak var txtName: UITextField! // Campo de texto para ingresar el nombre.
    @IBOutlet weak var txtBootCamp: UITextField! // Campo de texto para ingresar el bootcamp.
    private let storeDataPRovider: StoreDataProvider = .shared // Instancia compartida del proveedor de datos.
    
    override func viewDidLoad() {
        super.viewDidLoad() // Método llamado al cargarse la vista.
    }
    
    // Método que se ejecuta al pulsar el botón de aceptar.
    @IBAction func btnAccepTapped(_ sender: Any) {
        guard let name = txtName.text, !name.isEmpty else { return } // Verifica que el campo nombre no esté vacío, si lo está, termina la ejecución del método.
        
        var bootCamp: String? // Variable opcional para almacenar el bootcamp.
        if let bootCampText = txtBootCamp.text, !bootCampText.isEmpty {
            bootCamp = bootCampText // Asigna el valor al bootcamp si no está vacío.
        }
        
        storeDataPRovider.addKeepCoder(name: name, bootCamp: bootCamp) // Añade el KeepCoder a la base de datos.
        
        navigationController?.popViewController(animated: true) // Regresa a la vista anterior.
    }
}
