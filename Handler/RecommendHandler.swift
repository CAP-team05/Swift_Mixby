//
//  RecommendHandler.swift
//  mixby2
//
//  Created by Anthony on 12/1/24.
//


import SQLite3
import Foundation

class RecommendHandler {
    public static let shared = RecommendHandler()
    private let db: OpaquePointer?
        
    private init() {
        db = DatabaseManager.shared.getDB()
        createTable()
    }
    
    private func createTable() {
        let createTableQuery = """
        CREATE TABLE IF NOT EXISTS Recommend (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            reason TEXT,
            tag TEXT
        );
        """
        executeQuery(query: createTableQuery, description: "Create Recommend Table")
    }
    
    private func dropTable() {
        let dropTableQuery = "DROP TABLE IF EXISTS Recommend;"
        executeQuery(query: dropTableQuery, description: "Recommend table dropped")
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
    
    func insert(recommend: RecommendDTO) {
        let insertQuery = "INSERT INTO Recommend (name, reason, tag) VALUES (?, ?, ?);"
        var statement: OpaquePointer?
        print("in insert Recommend : \(recommend.name)")
        if sqlite3_prepare_v2(db, insertQuery, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, (recommend.name as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 2, (recommend.reason as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 3, (recommend.tag as NSString).utf8String, -1, nil)
            
            if sqlite3_step(statement) == SQLITE_DONE {
                print("Successfully inserted Recommend.")
            } else {
                print("Failed to insert Recommend.")
            }
        }
        sqlite3_finalize(statement)
    }
    
    func delete(recommend: RecommendDTO) {
        let deleteQuery = "DELETE FROM Recommend WHERE code = ?;"
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, deleteQuery, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, (recommend.name as NSString).utf8String, -1, nil)
            
            if sqlite3_step(statement) == SQLITE_DONE {
                print("Successfully deleted Recommend.")
            } else {
                print("Failed to delete Recommend.")
            }
        }
        sqlite3_finalize(statement)
    }
    
    func deleteAll() {
        let deleteQuery = "DELETE FROM Recommend;"
        executeQuery(query: deleteQuery, description: "Delete all Recommends")
    }
    
    func searchAll() -> [RecommendDTO] {
        var recommends: [RecommendDTO] = []
        let query = "SELECT name, reason, tag FROM Recommend;"
        var statement: OpaquePointer?

        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                let name = String(cString: sqlite3_column_text(statement, 0))
                let reason = String(cString: sqlite3_column_text(statement, 1))
                let tag = String(cString: sqlite3_column_text(statement, 2))
                
                let recommend = RecommendDTO(
                    name: name,
                    reason: reason,
                    tag: tag
                )
                recommends.append(recommend)
            }
        } else {
            let errorMessage = String(cString: sqlite3_errmsg(db))
            print("Failed to fetch Recommends from database.")
            print("SQLite Error: \(errorMessage)")
        }
        sqlite3_finalize(statement)
        return recommends
    }
}
