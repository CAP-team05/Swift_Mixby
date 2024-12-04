//
//  TastingNoteHandler.swift
//  MixbyPreview
//
//  Created by Ys on 11/29/24.
//

import SQLite3
import Foundation


class TastingNoteHandler {
    static private let db = DatabaseManager.shared.openDatabase()
    
    init() {
        // dropTastingNoteTable()
        TastingNoteHandler.createTable()
    }

    static func createTable() {
        let createTableQuery = """
        CREATE TABLE IF NOT EXISTS TastingNote (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            code TEXT,
            english_name TEXT,
            korean_name TEXT,
            drinkDate TEXT,
            eval INTEGER,
            sweetness INTEGER,
            sourness INTEGER,
            alcohol INTEGER
        );
        """
        executeQuery(query: createTableQuery, description: "TastingNote table created")
    }
    
    static func dropTable() {
        let dropTableQuery = "DROP TABLE IF EXISTS TastingNote"
        executeQuery(query: dropTableQuery, description: "TastingNote table dropped")
    }

    static func insert(note: TastingNoteDTO) {
        let insertQuery = """
        INSERT INTO TastingNote (code, english_name, korean_name, drinkDate, eval, sweetness, sourness, alcohol)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?);
        """
        var statement: OpaquePointer?
        if sqlite3_prepare_v2(db, insertQuery, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, (note.code as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 2, (note.english_name as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 3, (note.korean_name as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 4, (note.drinkDate as NSString).utf8String, -1, nil)
            sqlite3_bind_int(statement, 5, Int32(note.eval))
            sqlite3_bind_int(statement, 6, Int32(note.sweetness))
            sqlite3_bind_int(statement, 7, Int32(note.sourness))
            sqlite3_bind_int(statement, 8, Int32(note.alcohol))

            if sqlite3_step(statement) == SQLITE_DONE {
                print("Successfully inserted tasting note.")
            } else {
                print("Failed to insert tasting note.")
            }
        }
        sqlite3_finalize(statement)
    }
    
    static func update(note: TastingNoteDTO) {
        let updateQuery = """
        UPDATE TastingNote
        SET eval = ?, sweetness = ?, sourness = ?, alcohol = ?
        WHERE code = ?;
        """
        
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, updateQuery, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_int(statement, 1, Int32(note.eval))
            sqlite3_bind_int(statement, 2, Int32(note.sweetness))
            sqlite3_bind_int(statement, 3, Int32(note.sourness))
            sqlite3_bind_int(statement, 4, Int32(note.alcohol))
            sqlite3_bind_text(statement, 5, (note.code as NSString).utf8String, -1, nil)
            
            if sqlite3_step(statement) == SQLITE_DONE {
                print("Successfully updated persona for \(note.code).")
            } else {
                print("Failed to update persona for \(note.code).")
            }
        } else {
            print("Failed to prepare update statement.")
        }
        sqlite3_finalize(statement)
        
    }
    
    static func searchAll() -> [TastingNoteDTO] {
        var notes: [TastingNoteDTO] = []
        let query = "SELECT code, english_name, korean_name, drinkDate, eval, sweetness, sourness, alcohol FROM TastingNote;"
        var statement: OpaquePointer?

        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                let cn = String(cString: sqlite3_column_text(statement, 0))
                let enm = String(cString: sqlite3_column_text(statement, 1))
                let knm = String(cString: sqlite3_column_text(statement, 2))
                let dd = String(cString: sqlite3_column_text(statement, 3))
                let eval = Int(sqlite3_column_int(statement, 4))
                let sweet = Int(sqlite3_column_int(statement, 5))
                let sour = Int(sqlite3_column_int(statement, 6))
                let al = Int(sqlite3_column_int(statement, 7))

                let note = TastingNoteDTO(code: cn, english_name: enm, korean_name: knm, drinkDate: dd, eval: eval, sweetness: sweet, sourness: sour, alcohol: al)
                notes.append(note)
            }
        } else {
            print("Failed to fetch users from database.")
        }
        sqlite3_finalize(statement)
        return notes
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
}
