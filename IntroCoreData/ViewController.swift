import UIKit

class ViewController: UIViewController {
    
    let viewModel: ViewModel = ViewModel() // Instancia del ViewModel

    @IBOutlet weak var tableView: UITableView! // Conexión con la tabla del storyboard.
    
    func configure() {
        tableView.dataSource = self // Establece el objeto que proporciona los datos.
        tableView.delegate = self // Establece el objeto que maneja eventos de la tabla.
        navigationItem.title = "KeepCoders" // Establece el título del elemento de navegación. Esto significa que cuando esta vista está visible, la barra de navegación en la parte superior de la pantalla mostrará “KeepCoders” como título. Este título ayuda a los usuarios a identificar en qué parte de la aplicación se encuentran y puede ser un elemento clave en la navegación y la usabilidad de la interfaz de usuario.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AppLog.debug("Log test") // Envía un mensaje de prueba al registro de depuración.
        configure() // Configura la vista.

        viewModel.status = { [weak self] status in
            if status == .loaded {
                self?.tableView.reloadData() // Recarga la tabla cuando los datos están completamente cargados.
            }
        }
        viewModel.loadData() // Carga los datos en el ViewModel.
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    // Número de filas en cada sección de la tabla.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfKeepCoders() // Devuelve el número de "KeepCoders" estableciendo el tamaño de la tabla.
    }
    
    // Configuración de las celdas de la tabla.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) // Reutiliza o crea una celda con el identificador "Cell".
        
        if let keepCoder = viewModel.keepCoder(at: indexPath.row) { // Verifica si hay un "keepCoder" en el índice especificado.
            cell.textLabel?.text = keepCoder.name // Configura el texto principal de la celda con el nombre del "keepCoder".
            cell.detailTextLabel?.text = keepCoder.bootcamp // Configura el texto secundario de la celda con el bootcamp del "keepCoder".
        }
        
        return cell
    }
    
}
