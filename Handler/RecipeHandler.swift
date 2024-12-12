//
//  RecipeHandler.swift
//  mixby2
//
//  Created by Anthony on 12/1/24.
//


import SQLite3
import Foundation

class RecipeHandler {
    static let shared = RecipeHandler()
    private let db: OpaquePointer?
    
    private init() {
        db = DatabaseManager.shared.getDB()
        createTable()
    }
    
    private func createTable() {
        let createTableQuery = """
        CREATE TABLE IF NOT EXISTS Recipe (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            code TEXT,
            english_name TEXT,
            korean_name TEXT,
            tag1 TEXT,
            tag2 TEXT,
            have TEXT
        );
        """
        
        executeQuery(query: createTableQuery, description: "Create Recipe Table")
    }
    
    private func dropTable() {
        let dropTableQuery = "DROP TABLE IF EXISTS Recipe;"
        executeQuery(query: dropTableQuery, description: "Recipe table dropped")
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
    
    func insert(recipe: RecipeDTO) {
        let insertQuery = "INSERT INTO Recipe (code, english_name, korean_name, tag1, tag2, have) VALUES (?, ?, ?, ?, ?, ?);"
        var statement: OpaquePointer?
//        print("in insert Recipe : \(recipe.korean_name)")
        if sqlite3_prepare_v2(db, insertQuery, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, (recipe.code as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 2, (recipe.english_name as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 3, (recipe.korean_name as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 4, (recipe.tag1 as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 5, (recipe.tag2 as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 6, (recipe.have as NSString).utf8String, -1, nil)
            
            if sqlite3_step(statement) == SQLITE_DONE {
                //print("Successfully inserted recipe.")
            } else {
                print("Failed to insert recipe.")
            }
        }
        sqlite3_finalize(statement)
    }
    
    func delete(recipe: RecipeDTO) {
        let deleteQuery = "DELETE FROM Recipe WHERE code = ?;"
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, deleteQuery, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, (recipe.code as NSString).utf8String, -1, nil)
            
            if sqlite3_step(statement) == SQLITE_DONE {
                print("Successfully deleted recipe.")
            } else {
                print("Failed to delete recipe.")
            }
        }
        sqlite3_finalize(statement)
    }
    
    func deleteAll() {
        let deleteQuery = "DELETE FROM Recipe;"
        executeQuery(query: deleteQuery, description: "delete all recipes")
    }
    
    func searchHave() -> [RecipeDTO] {
        var recipes: [RecipeDTO] = []
        let query = "SELECT code, english_name, korean_name, tag1, tag2, have FROM Recipe;"
        var statement: OpaquePointer?

        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                let code = String(cString: sqlite3_column_text(statement, 0))
                let english_name = String(cString: sqlite3_column_text(statement, 1))
                let korean_name = String(cString: sqlite3_column_text(statement, 2))
                let tag1 = String(cString: sqlite3_column_text(statement, 3))
                let tag2 = String(cString: sqlite3_column_text(statement, 4))
                let haveString = String(cString: sqlite3_column_text(statement, 5))
                
                
                
                let parts = haveString.split(separator: "-").map(String.init)
                if parts.count == 2, let haveCount = Int(parts[0]), let needCount = Int(parts[1]), haveCount == needCount {
                    let recipe = RecipeDTO(
                        code: code,
                        english_name: english_name,
                        korean_name: korean_name,
                        tag1: tag1,
                        tag2: tag2,
                        have: haveString
                    )
                    recipes.append(recipe)
                }
            }
        } else {
            let errorMessage = String(cString: sqlite3_errmsg(db))
            print("Failed to fetch recipes from database.")
            print("SQLite Error: \(errorMessage)")
        }
        sqlite3_finalize(statement)
        return recipes
    }
    
    func searchAll() -> [RecipeDTO] {
        var recipes: [RecipeDTO] = []
        let query = "SELECT code, english_name, korean_name, tag1, tag2, have FROM Recipe;"
        var statement: OpaquePointer?

        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                let code = String(cString: sqlite3_column_text(statement, 0))
                let english_name = String(cString: sqlite3_column_text(statement, 1))
                let korean_name = String(cString: sqlite3_column_text(statement, 2))
                let tag1 = String(cString: sqlite3_column_text(statement, 3))
                let tag2 = String(cString: sqlite3_column_text(statement, 4))
                let have = String(cString: sqlite3_column_text(statement, 5))
                
                let recipe = RecipeDTO(
                    code: code,
                    english_name: english_name,
                    korean_name: korean_name,
                    tag1: tag1,
                    tag2: tag2,
                    have: have
                )
                recipes.append(recipe)
            }
        } else {
            let errorMessage = String(cString: sqlite3_errmsg(db))
            print("Failed to fetch recipes from database.")
            print("SQLite Error: \(errorMessage)")
        }
        sqlite3_finalize(statement)
        return recipes
    }
}
