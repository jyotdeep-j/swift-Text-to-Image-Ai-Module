//
//  DBManager.swift
//  DreamAI
//
//  Created by iApp on 20/01/23.
//

import Foundation
import RealmSwift
class DBManager: NSObject {
    
    /// shared instance for Database
    static let shared = DBManager()
    
    /// we are using `RealSwift` for local database management
    private(set) var localDB: Realm?
    
    /// this will help for db `migration`
    /// this should be changed in every local db `schemna` update
    private var schemaVersion: UInt64 = 1
    
    @available(*,deprecated,message: "- please use DBManager.isDbAvailable")
    var isEnabled: Bool! {
        get { localDB != nil }
    }
    
    static var isDbAvailable: Bool! {
        get { DBManager.shared.localDB != nil }
    }
    
    // make constructor private
    private override init() {
        super.init()
    }
    
    /// - migration: every update in schema need to migrate from current version
    /// - this will do automatic migration in `localDB` schema
    private func migrateDBIF () -> Realm.Configuration {
        let config = Realm.Configuration (
            // Set the new schema version. This must be greater than the previously used
            // version (if you've never set a schema version before, the version is 0).
            schemaVersion: schemaVersion,
            // Set the block which will be called automatically when opening a Realm with
            // a schema version lower than the one set above
            migrationBlock: { migration, oldSchemaVersion in
                // We haven’t migrated anything yet, so oldSchemaVersion == 0
                switch oldSchemaVersion {
                case 0: // old schema
                    print("old schema",oldSchemaVersion)
                    break
                case 1: // new schema
                    print("New schema",migration)
                    break
                default:
                    // Nothing to do!
                    // Realm will automatically detect new properties and removed properties
                    // And will update the schema on disk automatically
                    break
                }
        })
        return config
    }
    
    /// this will start `localDb` using `realm` instance
    func startLocalDB() {
        // get latest migration
        let config = migrateDBIF()
        // add config to default config
        Realm.Configuration.defaultConfiguration = config
        do {
            localDB = try Realm()
            
        }
        catch _ {
            print("DB failes to load")
        }//assertionFailure("Local db not able to start , Need proper migration in schema") }
    }
   
}


