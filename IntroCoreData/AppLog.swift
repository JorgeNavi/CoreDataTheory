//
//  AppLog.swift
//  IntroCoreData
//
//  Created by Pedro on 10/10/24.
//
import Foundation
import OSLog
import UIKit

class AppLog {
    
    // Subsistem lo idea es que sea el bundle id de la app pero puede ser cualquier string
    private static  let subsystem = "com.softpmc.IntroCoreData"
    // Creamos un log de la categoría "network" podemos crear tantos logger  como categorías necesitemos Interfaz, Base de datos, secciones de la app.
    // En la consola podemos ver estos datos si no es de ayuda y filtrar por tipos de log.
    private static  let logger = Logger(subsystem: subsystem, category: "network")

    
    /// Función crea logs para mostrar en consola.
    /// - Parameters:
    ///   - file: Nombre del fichero donde se encuentra el objeto que lanza el log. Se puede indicar , pero #file lo hace por nostros
    ///   - line: Linea del fichero donde se encuentra el objeto que lanza el log. Se puede indicar , pero #line lo hace por nostros
    ///   - function: Nombre de la función  donde se encuentra el objeto que lanza el log. Se puede indicar , pero #file lo hace por nostros
    ///   - message: Meesage a mostrar en el log
    static func debug(file: StaticString = #file, line: UInt = #line, function: StaticString = #function,_ message: String) {
        #if DEBUG  // Directiva de compilación para añadir logs solo en versiones de desarrollo de la app
        let filename = ("\(file)" as NSString).lastPathComponent
        logger.debug("\(filename) \(function) \(line)\n\(String(describing: message))")
        #endif
    }
    
    // Otro tipo de log, se podría crear tantos como tipos nos ofrece Loggoer
    static func info(_ message: String) {
        logger.info("\(String(describing: message))")
    }
    
    
}

// Ejemplo de uso del logger creando uno
// Tipos de log
// lo ideal es tener un clase a la que se pueda acceder desde la app y ahí gestionar los logs
// como hemos hecho con AppLog
class ViewControllerSampleLogs: UIViewController {
    
    let logger = Logger(subsystem: "com.softpmc.IntroCoreData", category: "network") //el subsystem y el category pueden ser lo que queramos, pero el subsytem suele ser el bundle de la aplicacion y el category se suele usar para separar los tipos de logs (networking, debuger, error, etc)

    override func viewDidLoad() {
        super.viewDidLoad()
        logger.debug("Log debug")
        logger.info("Log info")
        logger.error("Log error")
        logger.fault("Log fault")
        logger.trace("Log trace")
        logger.notice("Loh notice")
        logger.critical("Log critical")
        
        AppLog.debug("Log debug")
    }
}
