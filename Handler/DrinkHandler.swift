//
//  DrinkHandler.swift
//  MixbyPreview
//
//  Created by Ys on 11/30/24.
//

import SQLite3
import Foundation

class DrinkHandler {
    static private let db = DatabaseManager.shared.openDatabase()
    
    init() {
        DrinkHandler.createTable()
    }
    
    static func createTable() {
        let createTableQuery = """
        CREATE TABLE IF NOT EXISTS Drink (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            code TEXT,
            name TEXT,
            baseCode TEXT,
            type TEXT,
            volume TEXT,
            alcohol TEXT,
            description TEXT
        );
        """
        
        executeQuery(query: createTableQuery, description: "Create Drink Table")
    }
    
    static func dropTable() {
        let dropTableQuery = "DROP TABLE IF EXISTS Drink;"
        executeQuery(query: dropTableQuery, description: "Drink table dropped")
    }
    
    
    static func executeQuery(query: String, description: String) {
        var statement: OpaquePointer?
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_DONE {
                print(description)
            } else {
                print("\(description) failed.")
            }
        }
        sqlite3_finalize(statement)
    }
    
    static func insert(drink: DrinkDTO) {
        let insertQuery = "INSERT INTO Drink (code, name, baseCode, type, volume, alcohol, description) VALUES (?, ?, ?, ?, ?, ?, ?);"
        var statement: OpaquePointer?
        print("in insert Drink : \(drink.name)")
        if sqlite3_prepare_v2(db, insertQuery, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, (drink.code as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 2, (drink.name as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 3, (drink.baseCode as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 4, (drink.type as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 5, (drink.volume as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 6, (drink.alcohol as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 7, (drink.description as NSString).utf8String, -1, nil)
            
            if sqlite3_step(statement) == SQLITE_DONE {
                print("Successfully inserted drink.")
            } else {
                print("Failed to insert drink.")
            }
        }
        sqlite3_finalize(statement)
    }
    
    static func delete(drink: DrinkDTO) {
        let deleteQuery = "DELETE FROM Drink WHERE code = ?;"
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, deleteQuery, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, (drink.code as NSString).utf8String, -1, nil)
            
            if sqlite3_step(statement) == SQLITE_DONE {
                print("Successfully deleted drink.")
            } else {
                print("Failed to delete drink.")
            }
        }
        sqlite3_finalize(statement)
    }
    
    static func searchAll() -> [DrinkDTO] {
        var drinks: [DrinkDTO] = []
        let query = "SELECT code, name, baseCode, type, volume, alcohol, description FROM Drink;"
        var statement: OpaquePointer?

        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                let code = String(cString: sqlite3_column_text(statement, 0))
                let name = String(cString: sqlite3_column_text(statement, 1))
                let baseCode = String(cString: sqlite3_column_text(statement, 2))
                let type = String(cString: sqlite3_column_text(statement, 3))
                let volume = String(cString: sqlite3_column_text(statement, 4))
                let alcohol = String(cString: sqlite3_column_text(statement, 5))
                let description = String(cString: sqlite3_column_text(statement, 6))
                
                let drink = DrinkDTO(code: code, name: name, baseCode: baseCode, type: type, volume: volume, alcohol: alcohol, description: description)
                drinks.append(drink)
            }
        } else {
            print("Failed to fetch drinks from database.")
        }
        sqlite3_finalize(statement)
        return drinks
    }
}
