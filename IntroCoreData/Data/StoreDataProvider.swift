//
//  StoreDataProvider.swift
//  IntroCoreData
//
//  Created by Pedro on 10/10/24.
//

import Foundation
import CoreData

class StoreDataProvider  {
    
    // Usamos una única instancia de StoreDataPRovider para asegurarnos de saber en el / los contextos que trabajamos.
    // Si crearamos varias instancias, crearíamos más contextos y hasta que no se guardara en base de datos la información
    // Las partes de la app que usan las otras instancias no se enteraría de esos cambios.
    
    static var shared: StoreDataProvider = .init()
    
    private let store: NSPersistentContainer
    private var context: NSManagedObjectContext {
        store.viewContext
    }
    
    init() {
        self.store = NSPersistentContainer(name: "Model")
        self.store.loadPersistentStores { _, error in
            if let error {
                // Cierra la app tanto en desarrollo como en producción.
                fatalError("Error loading persistent store: \(error)")
                
                // Cierra la app solo en desarrollo
                assertionFailure("Error loading persistent store: \(error)")
            }
        }
    }
    
    func save() {
        // Como guardar el contexto es una acción costosa antes de hacerlo comprobamos si hay cambios
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                AppLog.debug("Error saving context: \(error)")
            }
        }
    }
}


extension StoreDataProvider {
    
    // Crear un nuevo registro con lso datos recibidos
    func addKeepCoder(name: String, bootCamp: String?) {
        guard let entityDescription = NSEntityDescription.entity(forEntityName:"Keepcoder", in: context) else {
            return
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
        let reuqest = MOKeepcoder.fetchRequest()
        return try? context.fetch(reuqest)
    }
    
    // Elimina de la base de datos el registro que recibe
    func delete(keepcoder: MOKeepcoder) {
        context.delete(keepcoder)
        save()
    }
}
