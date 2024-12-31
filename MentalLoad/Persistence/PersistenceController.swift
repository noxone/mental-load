//
//  Persistence.swift
//  MentalLoad
//
//  Created by Olaf Neumann on 28.12.24.
//

import CoreData
import os

fileprivate let logger = Logger(category: "PersistenceController")


struct PersistenceController {
    static let shared = PersistenceController()

    //let container: NSPersistentCloudKitContainer
    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        //container = NSPersistentCloudKitContainer(name: "MentalLoad")
        container = NSPersistentContainer(name: "MentalLoad")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}


/*
import Foundation
import CoreData
import CloudKit

private let gCloudKitContainerIdentifier = "iCloud.org.olafneumann.fefereader"

extension Notification.Name {
    static let fefeStoreDidChange = Notification.Name("fefeStoreDidChange")
}

struct UserInfoKey {
    static let storeUUID = "storeUUID"
    static let transactions = "transactions"
}

class PersistenceController: NSObject, ObservableObject {
    static let shared = PersistenceController()
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*// Create folders for new store location
         let baseURL = NSPersistentContainer.defaultDirectoryURL()
         let storeFolderURL = baseURL.appendingPathComponent("CoreDataStores")
         let storeURL = storeFolderURL.appendingPathComponent("FefeReader.sqlite")
         
         let fileManager = FileManager.default
         if !fileManager.fileExists(atPath: storeFolderURL.path) {
         do {
         try fileManager.createDirectory(at: storeFolderURL, withIntermediateDirectories: true, attributes: nil)
         } catch {
         fatalError("#\(#function): Failed to create the store folder: \(error)")
         }
         }*/
        
        // Create Container
        let container = NSPersistentCloudKitContainer(name: "FefeReader")
        
        // Read and configure store description
        guard let storeDescription = container.persistentStoreDescriptions.first else {
            fatalError("#\(#function): Failed to retrieve a persistent store description.")
        }
        // we are not setting this URL, because the 'old' store is still at the same location...
        // storeDescription.url = storeURL
        // https://developer.apple.com/documentation/coredata/consuming_relevant_store_changes
        storeDescription.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
        storeDescription.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
        
        let cloudKitContainerOptions = NSPersistentCloudKitContainerOptions(containerIdentifier: gCloudKitContainerIdentifier)
        cloudKitContainerOptions.databaseScope = .private
        storeDescription.cloudKitContainerOptions = cloudKitContainerOptions
        
        
        container.loadPersistentStores(completionHandler: { loadedStoreDescription, error in
            guard error == nil else {
                fatalError("#\(#function): Failed to load persistent stores:\(error!)")
            }
            
            guard let cloudKitContainerOptions = loadedStoreDescription.cloudKitContainerOptions else {
                return
            }
            if cloudKitContainerOptions.databaseScope == .private {
                self._privatePersistentStore = container.persistentStoreCoordinator.persistentStore(for: loadedStoreDescription.url!)
                //} else if cloudKitContainerOptions.databaseScope  == .shared {
                //    self._sharedPersistentStore = container.persistentStoreCoordinator.persistentStore(for: loadedStoreDescription.url!)
            }
        })
        
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.transactionAuthor = "app"
        container.viewContext.automaticallyMergesChangesFromParent = true
        do {
            try container.viewContext.setQueryGenerationFrom(.current)
        } catch {
            fatalError("#\(#function): Failed to pin viewContext to the current generation: \(error)")
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(storeRemoteChange(_:)), name: .NSPersistentStoreRemoteChange, object: container.persistentStoreCoordinator)
        NotificationCenter.default.addObserver(self, selector: #selector(containerEventChanged(_:)), name: NSPersistentCloudKitContainer.eventChangedNotification, object: container)
        
        return container
    }()
    
    private var _privatePersistentStore: NSPersistentStore?
    var privatePersistentStore: NSPersistentStore {
        return _privatePersistentStore!
    }
    
    /*private var _sharedPersistentStore: NSPersistentStore?
     var sharedPersistentStore: NSPersistentStore {
     return _sharedPersistentStore!
     }*/
    
    private lazy var stores: [String : NSPersistentStore] = {
        [privatePersistentStore]
            .reduce(into: [:]) { $0[$1.identifier] = $1 }
    }()
    
    lazy var storeIdentifiers: any Collection<String> = stores.keys
    
    func getStore(for uuid: String) -> NSPersistentStore? {
        stores[uuid]
    }
    
    /*lazy var cloudKitContainer: CKContainer = {
     return CKContainer(identifier: gCloudKitContainerIdentifier)
     }()*/
    
    
    /**
     An operation queue for handling history processing tasks: watching changes, deduplicating tags, and triggering UI updates if needed.
     */
    lazy var historyQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
}
*/

