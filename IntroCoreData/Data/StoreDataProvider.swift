
import Foundation
import CoreData

class StoreDataProvider  {
    
    // Usamos una única instancia de StoreDataPRovider para asegurarnos de saber el/los contextos que trabajamos.
    // Si crearamos varias instancias, crearíamos más contextos y hasta que no se guardara en base de datos la información
    // Las partes de la app que usan las otras instancias no se enteraría de esos cambios.
    
    static var shared: StoreDataProvider = .init() //Se usa el patron singleton para realizar una única instancia del StoreDataProvider y poder usarla en toda la aplicación Es quien nos va a permitir acceder a la base de datos, realizar las conexiones, acceer a los registros, etc.
    
    private let store: NSPersistentContainer //donde guardamos toda la información de nuestra aplicación.
    private var context: NSManagedObjectContext { //Lo usamos para realizar acciones con la información, como añadir o cambiar datos.
        store.viewContext /* viewContext
                           
                           •    viewContext es una propiedad de NSPersistentContainer que proporciona un contexto de objetos gestionado (NSManagedObjectContext). Este contexto está configurado para ser usado en el hilo principal de la aplicación, lo que lo hace ideal para tareas relacionadas con la interfaz de usuario, como mostrar datos y responder a interacciones del usuario.
                           •    Utilizar viewContext asegura que todas las operaciones de datos que impactan directamente en la interfaz de usuario se realicen de manera segura y eficiente, evitando problemas de rendimiento o bloqueos de la aplicación.

                       Uso común

                           •    Típicamente, viewContext se utiliza para realizar consultas, insertar nuevos objetos, y actualizar o eliminar objetos existentes que serán mostrados directamente en la interfaz de usuario. Por ejemplo, si tu aplicación muestra una lista de elementos que los usuarios pueden editar, esos cambios se manejarían a través del viewContext para asegurar que la interfaz se actualice de manera fluida y reactiva. */
    }
    
    init() {
        self.store = NSPersistentContainer(name: "Model") //Aqui se le informa del modelo de datos que tiene que trabajar la BBDD. Se le informa del archivo que va a guardar todas las entidades de la BBDD de nuestro proyecto. Por ejemplo, si nuestro proyecto tratase de una biblioteca y tuvieramos tres entidades (libro, autor, editorial), guardariamos las entidades en un archivo de modelo de datos llamdo "library".
        self.store.loadPersistentStores { _, error in //Aqui nos aseguramos de que la BBDD pueda cargar
            if let error { //si no puede cargar:
                // Cierra la app tanto en desarrollo como en producción.
                fatalError("Error loading persistent store: \(error)")
                
                // Cierra la app solo en desarrollo
                assertionFailure("Error loading persistent store: \(error)")
            }
        }
    }
    
    func save() {
        // Como guardar el contexto es una acción costosa antes de hacerlo comprobamos si hay cambios
        if context.hasChanges { //aqui comporbamos si tiene cambios con el metodo hasChanges. If, los tien:
            do {
                try context.save() //try to guardar
            } catch { //si no puedes guardarlo
                AppLog.debug("Error saving context: \(error)") //mensaje de error
            }
        }
    }
}


extension StoreDataProvider {
    
    // Crear un nuevo registro con los datos recibidos
    func addKeepCoder(name: String, bootCamp: String?) { //por parametros un string nombre y un bootcamp opcional.
        guard let entityDescription = NSEntityDescription.entity(forEntityName:"Keepcoder", in: context) else {
            return //NSEntityDescription.entity(forEntityName:"Keepcoder", in: context) lo que hace es recuperar la información de la entidad "Keepcoder", que es nuestra entidad en el modelo de datos. Recupera sus atributos de name y bootcamp para cuando instanciemos en las siguientes lineas el MOKeepcoder le podamos informar de valores especificos para esos atributos y guardarlos en la base de datos.
        }
        let keecodder = MOKeepcoder(entity: entityDescription, insertInto: context)
        keecodder.name = name
        if let bootCamp {
            keecodder.bootcamp = bootCamp
        }
        save()
    }
    
    // Recupera todos los registros de la entidad MOKeepcoder de la BBDD
    func fetchKeepCoders() -> [MOKeepcoder]? {
        let request = MOKeepcoder.fetchRequest()
        return try? context.fetch(request)
    }
    
    // Elimina de la base de datos el registro que recibe
    func delete(keepcoder: MOKeepcoder) {
        context.delete(keepcoder)
        save()
    }
}
