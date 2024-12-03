//
//  DatabaseManager.swift
//  MixbyPreview
//
//  Created by Ys on 11/29/24.
//

import SQLite3
import Foundation

class DatabaseManager {
    static let shared = DatabaseManager()
    private var db: OpaquePointer?
    
    private init() {}
    
    func openDatabase() -> OpaquePointer? {
        if db == nil {
            let fileURL = try! FileManager.default
                .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent("AppDatabase.sqlite")
            if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
                print("db ok")
            } else {
                print("error in db")
                return nil
            }
            
        }
        return db
    }
    
    func closeDatabase() {
        if sqlite3_close(db) == SQLITE_OK {
            print("db closed")
        } else {
            print("error in db closed")
        }
        db = nil
    }
}
