//
//  UserHandler.swift
//  MixbyPreview
//
//  Created by Ys on 11/29/24.
//

import SQLite3
import Foundation

class UserHandler {
    static private let db = DatabaseManager.shared.openDatabase()
    
    init() {
        UserHandler.createTable()
    }

    static func createTable() {
        let createTableQuery = """
        CREATE TABLE IF NOT EXISTS User (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            gender TEXT,
            favoriteTaste TEXT,
            persona TEXT
        );
        """
        executeQuery(query: createTableQuery, description: "User table created")
    }
    
    static func dropTable() {
        let dropTableQuery = "DROP TABLE IF EXISTS User;"
        executeQuery(query: dropTableQuery, description: "User table dropped")
    }

    static func insert(user: UserDTO) {
        let insertQuery = "INSERT INTO User (name, gender, favoriteTaste, persona) VALUES (?, ?, ?, ?);"
        var statement: OpaquePointer?
        print("in insertUser : \(user.name)")
        if sqlite3_prepare_v2(db, insertQuery, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, (user.name as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 2, (user.gender as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 3, (user.favoriteTaste as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 4, (user.persona as NSString).utf8String, -1, nil)
            
            if sqlite3_step(statement) == SQLITE_DONE {
                print("Successfully inserted user.")
            } else {
                print("Failed to insert user.")
            }
        }
        sqlite3_finalize(statement)
    }
    
    
    // must not use gender, favoriteTaste
    static func updatePersona(user: UserDTO) {
        let updateQuery = """
        UPDATE User
        SET persona = ?
        WHERE name = ?;
        """
//        let updateQuery2 = """
//        UPDATE User
//        SET persona = ?
//        """
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, updateQuery, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, (user.persona as NSString).utf8String, -1, nil) // user.persona를 바인딩
            sqlite3_bind_text(statement, 2, (user.name as NSString).utf8String, -1, nil)   // user.name을 바인딩
            
            if sqlite3_step(statement) == SQLITE_DONE {
                print("Successfully updated persona for \(user.name).")
            } else {
                print("Failed to update persona for \(user.name).")
            }
        } else {
            print("Failed to prepare update statement.")
        }
        sqlite3_finalize(statement)
    }

    static private func executeQuery(query: String, description: String) {
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
    
    static func searchAll() -> [UserDTO] {
        var users: [UserDTO] = []
        let query = "SELECT name, gender, favoriteTaste, persona FROM User;"
        var statement: OpaquePointer?

        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                let name = String(cString: sqlite3_column_text(statement, 0))
                let gender = String(cString: sqlite3_column_text(statement, 1))
                let favoriteTaste = String(cString: sqlite3_column_text(statement, 2))
                let persona = String(cString: sqlite3_column_text(statement, 3))
                
                print("persona : \(persona)")

                let user = UserDTO(name: name, gender: gender, favoriteTaste: favoriteTaste, persona: persona)
                users.append(user)
            }
        } else {
            print("Failed to fetch users from database.")
        }
        sqlite3_finalize(statement)
        return users
    }
}
