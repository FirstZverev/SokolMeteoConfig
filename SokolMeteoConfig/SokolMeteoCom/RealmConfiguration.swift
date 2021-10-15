//
//  RealmConfiguration.swift
//  SOKOL
//
//  Created by Володя Зверев on 15.04.2021.
//  Copyright © 2021 zverev. All rights reserved.
//

import Foundation
import RealmSwift

class RealmConfiguration: NSObject {
    
    static func configuration() -> Realm.Configuration {
        var config = Realm.Configuration(
            schemaVersion: 3,
            
            migrationBlock: { migration, oldSchemaVersion in
                if (oldSchemaVersion < 3) {
                }
            })
        config.deleteRealmIfMigrationNeeded = true

//        let url = Realm.Configuration.defaultConfiguration
//        remove(realmURL: url)
//
//        let documentdir:String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!
//        config.fileURL = URL(fileURLWithPath: documentdir).appendingPathComponent("de.realm")
        return config
    }
    
    public static func remove(realmURL: URL) {
            let realmURLs = [
                realmURL,
                realmURL.appendingPathExtension("lock"),
                realmURL.appendingPathExtension("note"),
                realmURL.appendingPathExtension("management"),
                ]
            for URL in realmURLs {
                try? FileManager.default.removeItem(at: URL)
            }
    }
}
