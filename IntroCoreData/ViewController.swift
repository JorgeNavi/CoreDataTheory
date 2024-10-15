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
    
    //El sistema invoca el método prepare(for:sender:) justo antes de que la transición se lleve a cabo. En este método puedes preparar la pantalla de destino y, por ejemplo, pasarle datos, en este caso, en el prepare for de mas arriba. El parámetro sender en este caso será el objeto keepcoder, que podrías usar en el método prepare(for:sender:) para configurar el controlador de destino.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailVC = segue.destination as? DetailKeepcoderController, //se está estableciendo la propiedad destination del segue, es decir, empaquetamos en una constante detailVC que el destino del segue es del tipo DetailKeepcoderController
                let keepcoder = sender as? MOKeepcoder else { //la propiedad sender del segue es del tipo MOKeepcoder
            return
        }
        detailVC.keepCoder = keepcoder //aqui en detailVC le asignamos el sender del segue que es nuestro regfistro
    }
    
    
    
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    // Número de filas en cada sección de la tabla.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfKeepCoders() // Devuelve el número de "KeepCoders" estableciendo el tamaño de la tabla.
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
    
    //vamos a mandarle el registro para que se pueda editar
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let keepcoder = viewModel.keepCoder(at: indexPath.row) else { //Nos aseguramos de que tenemos el registro usando el método del viewModel
            return
        }
        /*
         •    performSegue: Es un método disponible en cualquier controlador de vista (UIViewController) que permite activar un “segue”, es decir, una transición entre dos controladores de vista que están conectados en un Storyboard. Los segues son la manera en que se navega de una pantalla a otra en una aplicación.
         •    Parámetros:
         •    withIdentifier: Es el identificador único del segue que quieres ejecutar. Este identificador es una cadena (String) y debe coincidir exactamente con el identificador que configuraste en el storyboard. En este caso, "segDetail" es el nombre del segue que estás invocando.
         •    sender: Es un parámetro opcional (Any?) que se puede utilizar para enviar información a la siguiente pantalla o vista (el controlador de destino). Este valor puede ser cualquier tipo de objeto. En este caso, keepcoder es un objeto que será pasado al controlador de destino (en el método prepare(for:sender:), por ejemplo). Es útil para pasar datos relacionados con el evento que desencadenó el segue.

     2. Funcionamiento del Código

         •    Paso 1: Cuando llamas a performSegue, le estás diciendo al sistema que ejecute la transición a otro controlador de vista que has definido previamente en el storyboard. El identificador "segDetail" hace referencia al segue que conecta el controlador actual con el controlador de destino.
         •    Paso 2: El sistema invoca el método prepare(for:sender:) justo antes de que la transición se lleve a cabo. En este método puedes preparar la pantalla de destino y, por ejemplo, pasarle datos, en este caso, en el prepare for de mas arriba. El parámetro sender en este caso será el objeto keepcoder, que podrías usar en el método prepare(for:sender:) para configurar el controlador de destino.
         */
        performSegue(withIdentifier: "segDetail", sender: keepcoder) //aqui pues, solo se lanza la información del keepcoder a través de un segue determinado (la flecha que conecta pantallas en el storyboard). Lo que se manda es el sender
        
        
        //Otra manera de hacerlo en lugar de usar el segue, usando storyboard
        //let storyboard = UIStoryboard(name: "Main", bundle: nil) //localizamos nuestro storyboard
        //if let detailVC = storyboard.instantiateViewController(withIdentifier: "DetailKeepcoder") as?
        //DetailKeepcoderController { //isntanciamos un viewController con un identificador que pusimos previamente ("DetailKeepcoder") y nos aseguramos de que sea de tipo DetailKeepcoderController
            //detailVC.keepCoder = keepCoder //a nuestro detalle la añadimos el registro
            //navigationController?.pushViewController(detailVC, animated: true) //y le decimos a navigationController que haga una transción push al detailVC
        }
        
    
    //vamos a establecer una funcionalidad que haga que cuando arrastremos fuerte una celda hacia la izquierda, se elimine el registro del Keepcoder de la base de datos
    
    //indica si una celda es editble. En este caso vamos a decir que todas son editables, aunque se podría establecer lógcas para determinar si algunas si y otras no
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true //al sólo poner true, todas son editables
    }
    //indicamos el tipo de acción en la celda al editar, en este caso .delete (también es el valor por defecto, si no pusieramos nada, también seria .delete)
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    //Ejecutamos la acción de borrar que hemos establecido en la función anterior lo que hace, en nuestro caso, es eliminar un KeepCoder. En los parámetros, viene commit editingStyle: UITableViewCell.EditingStyle, esto es, que recibe la acción configuada previamente en el método editingStyleForRowAt.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        viewModel.deleteKeepCoder(at: indexPath.row) //Usamos aqui el metodo borrar keepcoder del viewModel
    }
}


    

