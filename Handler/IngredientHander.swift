//
//  DrinkHandler.swift
//  MixbyPreview
//
//  Created by Ys on 11/30/24.
//

import SQLite3
import Foundation

class IngredientHandler {
    public static let shared = IngredientHandler()
    private let db: OpaquePointer?
        
    private init() {
        db = DatabaseManager.shared.getDB()
        createTable()
    }
    
    private func createTable() {
        let createTableQuery = """
        CREATE TABLE IF NOT EXISTS Ingredient (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            code TEXT,
            name TEXT
        );
        """
        
        executeQuery(query: createTableQuery, description: "Create Ingredient Table")
    }
    
    private func dropTable() {
        let dropTableQuery = "DROP TABLE IF EXISTS Ingredient;"
        executeQuery(query: dropTableQuery, description: "Ingredient table dropped")
    }
    
    
    private func executeQuery(query: String, description: String) {
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
    
    func insert (ingredient: IngredientDTO) {
        let insertQuery = "INSERT INTO Ingredient (code, name) VALUES (?, ?);"
        var statement: OpaquePointer?
        //print("in insert Ingredient : \(ingredient.name)")
        if sqlite3_prepare_v2(db, insertQuery, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, (ingredient.code as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 2, (ingredient.name as NSString).utf8String, -1, nil)
            
            if sqlite3_step(statement) == SQLITE_DONE {
                //print("Successfully inserted ingredient.")
            } else {
                print("Failed to insert ingredient.")
            }
        }
        sqlite3_finalize(statement)
    }
    
    func delete(ingredient: IngredientDTO) {
        let deleteQuery = "DELETE FROM Drink WHERE code = ?;"
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, deleteQuery, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, (ingredient.code as NSString).utf8String, -1, nil)
            
            if sqlite3_step(statement) == SQLITE_DONE {
                print("Successfully deleted ingredient.")
            } else {
                print("Failed to delete ingredient.")
            }
        }
        sqlite3_finalize(statement)
    }
    
    func deleteAll() {
        let deleteQuery = "DELETE FROM Drink"
        executeQuery(query: deleteQuery, description: "delete all drink")
    }
    
    func searchAll() -> [IngredientDTO] {
        var ingredients: [IngredientDTO] = []
        let query = "SELECT code, name FROM Ingredient;"
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                let code = String(cString: sqlite3_column_text(statement, 0))
                let name = String(cString: sqlite3_column_text(statement, 1))
                
                let ingredient = IngredientDTO(name: name, code: code)
                ingredients.append(ingredient)
            }
        } else {
            print("Failed to fetch ingredients from database.")
        }
        sqlite3_finalize(statement)
        return ingredients
    }
}
