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
                    .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                    .appendingPathComponent("AppDatabase.sqlite")
                print("Database path: \(fileURL.path)")

                if sqlite3_open(fileURL.path, &db) == SQLITE_OK {
                    print("Successfully opened database")
                } else {
                    let errorMessage = String(cString: sqlite3_errmsg(db))
                    print("Unable to open database. Error: \(errorMessage)")
                    return nil
                }
            } catch {
                print("Error while constructing database path: \(error.localizedDescription)")
                return nil
            }
        }
        return db
    }

    func closeDatabase() {
        if db != nil {
            if sqlite3_close(db) == SQLITE_OK {
                print("Database successfully closed")
            } else {
                let errorMessage = String(cString: sqlite3_errmsg(db))
                print("Error while closing database: \(errorMessage)")
            }
            db = nil
        } else {
            print("Database was already closed or not initialized")
        }
    }
}
