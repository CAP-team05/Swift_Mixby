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
            do {
                let fileURL = try FileManager.default
                    .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                    .appendingPathComponent("AppDatabase.sqlite")
                
                print("Database path: \(fileURL.path)")
                
                if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
                    if let errmsg = sqlite3_errmsg(db) {
                        print("Error opening database: \(String(cString: errmsg))")
                    }
                    return nil
                } else {
                    print("Database opened successfully")
                }
            } catch {
                print("FileManager error: \(error)")
                return nil
            }
        }
        return db
    }
    
    func closeDatabase() {
        if db != nil {
            if sqlite3_close(db) == SQLITE_OK {
                print("Database closed successfully")
            } else {
                if let errmsg = sqlite3_errmsg(db) {
                    print("Error closing database: \(String(cString: errmsg))")
                }
            }
            db = nil
        }
    }
}
