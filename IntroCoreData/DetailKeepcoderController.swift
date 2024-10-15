import UIKit


class DetailKeepcoderController: UIViewController {

    @IBOutlet weak var txtName: UITextField! // Campo de texto para ingresar el nombre.
    @IBOutlet weak var txtBootCamp: UITextField! // Campo de texto para ingresar el bootcamp.
    private let storeDataPRovider: StoreDataProvider = .shared // Instancia compartida del proveedor de datos.
    
    //en esta vista vamos a editar un Keepcoder
    var keepCoder: MOKeepcoder? //vamos a pasar el registro que queremos editar
    
    //actualizamos el titulo de la pantalla en función de si estamos añadiendo un nuevo keepcoder o editando uno existente
    override func viewDidLoad() {
        super.viewDidLoad() // Método llamado al cargarse la vista.
        if let keepCoder{ //si tenemos un keepCoder (llamando al registro de arriba), editamos:
            navigationItem.title = "Edit \(keepCoder.name ?? "No name")" //Edit el nombre del registro, si no tiene nombre el valor será "No name"
            txtName.text = keepCoder.name  //se mostrará en el UITextField el nombre del registro que queremos editar
            txtBootCamp.text = keepCoder.bootcamp //se mostrará en el UITextField el bootcamp del registro que queremos editar
        } else { //si no tenemos un keepCoder:
            navigationItem.title = "New KeepCoder" //El título cambia a "New KeepCoder"
        }
      
    }
    
    // Método que se ejecuta al pulsar el botón de aceptar.
    @IBAction func btnAccepTapped(_ sender: Any) {
        guard let name = txtName.text, !name.isEmpty else { return } // Verifica que el campo nombre no esté vacío, si lo está, termina la ejecución del método.
        
        var bootCamp: String? // Variable opcional para almacenar el bootcamp.
        if let bootCampText = txtBootCamp.text, !bootCampText.isEmpty {
            bootCamp = bootCampText // Asigna el valor al bootcamp si no está vacío.
        }
        
        //Aqui continuamos con la edición, en el caso de estar actualizando, al pulsar el botón de aceptar:
        if let keepCoder { //Si tenemos keepCoder,
            keepCoder.name = txtName.text //el nombre del keepCoder será igual al valor de campo de texto
            keepCoder.bootcamp = txtBootCamp.text //el bootcamp del keepCoder será igual al valor de campo de texto
            storeDataPRovider.save() //Guardar los cambios en el contexto
        } else {
            storeDataPRovider.addKeepCoder(name: name, bootCamp: bootCamp) //Si no hay registro existente, se crea uno nuevo al pulsar el botón
        }
        navigationController?.popViewController(animated: true) // Regresa a la vista anterior.
    }
}
