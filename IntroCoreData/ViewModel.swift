
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
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
    init(storeProvider: StoreDataProvider = .shared) {
        self.storeProvider = storeProvider
        
        // Notificación que no informa de cambios en base de datos, la aprovechamos para informar al controller
        // y recuperar la nueva información de BBDD. Mejor opción que llamar al loadData en el ViewWillAppear
        observer = NotificationCenter.default.addObserver(forName: NSManagedObjectContext.didSaveObjectsNotification, object: nil, queue: .main) {[weak self] _ in
            self?.loadData()
        }
    }
    
    // Obtiene los Keepcoders de BBDD y notifica de ello
    func loadData() {
        let data = storeProvider.fetchKeepCoders()
        keepcoders = data ?? []
        status?(.loaded)
    }
    
    func numberOfKeepCoders() -> Int {
        keepcoders.count
    }
    
    // Protegemos la app de cerrase si se pide un index superior al numero de registros
    func keepCoder(at index: Int) -> MOKeepcoder? {
        guard index < keepcoders.count else {
            return nil
        }
        return keepcoders[index]
    }
}
