
import CoreData

enum StatusKeepCoders {
    case loading
    case loaded
    case error
}

class ViewModel {
    private var storeProvider: StoreDataProvider
    private var keepcoders: [MOKeepcoder] = []
    private var observer: NSObjectProtocol?
    
    var status: ((StatusKeepCoders) -> Void)?
    
    deinit {
        if let observer {
            NotificationCenter.default.removeObserver(observer) //si hay observer, lo eliminamos
        }
    }
    
    init(storeProvider: StoreDataProvider = .shared) {
        self.storeProvider = storeProvider
        
        // Notificación que nos informa de cambios en base de datos, la aprovechamos para informar al controller
        // y recuperar la nueva información de BBDD. Mejor opción que llamar al loadData en el ViewWillAppear
        observer = NotificationCenter.default.addObserver(forName: NSManagedObjectContext.didSaveObjectsNotification, object: nil, queue: .main) {[weak self] _ in //forName especifica el nombre de la notificación que el observador debe escuchar. En este caso, es NSManagedObjectContext.didSaveObjectsNotification, que es una notificación enviada por NSManagedObjectContext cuando se guardan objetos en el contexto. Esta notificación se usa comúnmente para responder a cambios en una base de datos CoreData.
            self?.loadData() //se llama a loadData() que se encargará de cargar o recargar datos, posiblemente como respuesta a los cambios guardados en el contexto de CoreData.
        }
    }
    
    // Obtiene los Keepcoders de BBDD y notifica de ello
    func loadData() {
        let data = storeProvider.fetchKeepCoders()
        keepcoders = data ?? [] //El operador ?? se utiliza aquí como un operador de coalescencia nula, lo que significa que si data es nil (es decir, si no se recuperaron datos), entonces keepcoders se inicializará con un arreglo vacío [].
        status?(.loaded)
    }
    
    func numberOfKeepCoders() -> Int {
        keepcoders.count //al establecer esta función con el número e registros de Keepcoders y pasarselas a la tabla en el viewController, establecemos que el tamaño de la tabla sea igual a la cantidad de registros disponibles
    }
    
    // Protegemos la app de cerrase si se pide un index superior al numero de registros
    func keepCoder(at index: Int) -> MOKeepcoder? {
        guard index < keepcoders.count else { //si el índice es menor que el numero de keepcoders, return keepcoders[index]. Else, return nil.
            return nil
        }
        return keepcoders[index]
    }
    
    //nos aseguramos de que tenemos el objeto a borrar y lo borramos
    func deleteKeepCoder(at index: Int) {
        guard let keepCoder = keepCoder(at: index) else { //Nos aseguramos de que tenemos un keepcoder apoyandonos en la funcion func keepCoder(at index: Int)
            return //si no tenemos, return
        }
        storeProvider.delete(keepcoder: keepCoder) //si lo tenemos, llamamos a storeProvider y que elimine ese registro
    }
    
    /*
     El flujo del borrado con el gesto es el siguiente:
     
     1- Hago el gesto, llamo a la función deleteKeepCoder del viewModel, que realmente lo que borra es de la BBDD
     2- Esa acción provoca que se llame en el viewModel a observer = NotificationCenter.default.addObserver(forName: NSManagedObjectContext.didSaveObjectsNotification, object: nil, queue: .main) {[weak self] _ in
            , que es el observer que está escuchando que se producen cambios en el contexto
            y self?.loadData() actualiza la vista
     
     es decir, estamos eliminando directamente en la BBDD, la notificación nos avisa y se actualiza la vista

     */
    
  
}
