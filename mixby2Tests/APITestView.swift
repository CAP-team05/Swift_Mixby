//
//  ContentView.swift
//  FirstApp
//
//  Created by Ys on 11/21/24.
//

import SwiftUI
import SQLite3

private var api_address: String = "http://127.0.0.1:2222/drink/name=잭다니엘"
private var api_request_address: String = "http://localhost:2222/userinfo"

struct TestView: View {
    @State private var db: OpaquePointer?

    var body: some View {
        TabView {
            InputView(db: $db)
                .tabItem {
                    Label("Input", systemImage: "square.and.pencil")
                }
            
            DatabaseView(db: $db)
                .tabItem {
                    Label("Database", systemImage: "list.dash")
                }
            
            APITestView()
                .tabItem {
                    Label("API Test", systemImage: "cloud")
                }
            
            SendJSONView(db: $db)
                .tabItem {
                    Label("Send JSON", systemImage: "paperplane")
                }
        }
        .onAppear {
            setupDatabase()
        }
    }
    
    func setupDatabase() {
        let fileURL = try! FileManager.default
            .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("UserInfo.sqlite")
        
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("Error opening database")
            return
        }
        
        let createTableQuery = """
        CREATE TABLE IF NOT EXISTS User (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            gender TEXT,
            favoriteTaste TEXT
        );
        """
        
        if sqlite3_exec(db, createTableQuery, nil, nil, nil) != SQLITE_OK {
            print("Error creating table")
            return
        }
    }
}

struct InputView: View {
    @Binding var db: OpaquePointer?
    @State private var name: String = ""
    @State private var gender: String = ""
    @State private var favoriteTaste: String = ""

    var body: some View {
        VStack(spacing: 20) {
            Text("User Info")
                .font(.title)
            
            TextField("Enter your name", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            TextField("Enter your gender", text: $gender)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            TextField("Enter your favorite taste", text: $favoriteTaste)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button("Save to Database") {
                saveData(name: name, gender: gender, favoriteTaste: favoriteTaste)
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
    }
    
    func saveData(name: String, gender: String, favoriteTaste: String) {
        let insertQuery = "INSERT INTO User (name, gender, favoriteTaste) VALUES (?, ?, ?);"
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, insertQuery, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, (name as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 2, (gender as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 3, (favoriteTaste as NSString).utf8String, -1, nil)
            
            if sqlite3_step(statement) == SQLITE_DONE {
                print("Data saved successfully")
            } else {
                print("Could not save data")
            }
        } else {
            print("Error preparing statement")
        }
        
        sqlite3_finalize(statement)
    }
}

struct DatabaseView: View {
    @Binding var db: OpaquePointer?
    @State private var users: [(id: Int, name: String, gender: String, favoriteTaste: String)] = []

    var body: some View {
        VStack {
            Text("Saved Users")
                .font(.title)
                .padding()
            
            List {
                ForEach(users, id: \.id) { user in
                    VStack(alignment: .leading) {
                        Text("Name: \(user.name)")
                        Text("Gender: \(user.gender)")
                        Text("Favorite Taste: \(user.favoriteTaste)")
                    }
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            deleteData(id: user.id)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
            }
            .onAppear {
                fetchData()
            }
        }
        .padding()
    }
    
    func fetchData() {
        users.removeAll()
        let query = "SELECT id, name, gender, favoriteTaste FROM User;"
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                let id = Int(sqlite3_column_int(statement, 0))
                let name = String(cString: sqlite3_column_text(statement, 1))
                let gender = String(cString: sqlite3_column_text(statement, 2))
                let favoriteTaste = String(cString: sqlite3_column_text(statement, 3))
                
                users.append((id: id, name: name, gender: gender, favoriteTaste: favoriteTaste))
            }
        } else {
            print("Error fetching data")
        }
        
        sqlite3_finalize(statement)
    }
    
    func deleteData(id: Int) {
        let deleteQuery = "DELETE FROM User WHERE id = ?;"
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, deleteQuery, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_int(statement, 1, Int32(id))
            
            if sqlite3_step(statement) == SQLITE_DONE {
                print("Data deleted successfully")
                fetchData() // 데이터 삭제 후 리스트 갱신
            } else {
                print("Could not delete data")
            }
        } else {
            print("Error preparing delete statement")
        }
        
        sqlite3_finalize(statement)
    }
}


struct APITestView: View {
    @State private var responseData: String = "Press the button to make an API request."

    var body: some View {
        VStack(spacing: 20) {
            Text("API Test")
                .font(.title)
            
            Button("Make API Request") {
                fetchAPIData()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            
            ScrollView {
                Text(responseData)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
            }
            .frame(maxHeight: 300)
        }
        .padding()
    }
    
    func fetchAPIData() {
        guard let url = URL(string: api_address) else {
            responseData = "Invalid URL."
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    responseData = "Error: \(error.localizedDescription)"
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    responseData = "No data received."
                }
                return
            }
            
            do {
                // JSON 파싱
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [Any] {
                    var parsedResult = ""
                    for element in jsonArray {
                        if let stringElement = element as? String {
                            parsedResult += "\(stringElement)\n"
                        } else if let objectElement = element as? [String: Any] {
                            parsedResult += "\(objectElement)\n"
                        }
                    }
                    DispatchQueue.main.async {
                        responseData = parsedResult
                    }
                } else {
                    DispatchQueue.main.async {
                        responseData = "Invalid JSON format."
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    responseData = "JSON parsing error: \(error.localizedDescription)"
                }
            }
        }
        
        task.resume()
    }
}

struct SendJSONView: View {
    @Binding var db: OpaquePointer?
    @State private var responseMessage: String = "Press the button to send JSON data."
    @State private var isSending: Bool = false

    var body: some View {
        VStack(spacing: 20) {
            Text("Send JSON Data")
                .font(.title)
            
            Button("Send JSON File") {
                sendJSONFile()
            }
            .padding()
            .background(isSending ? Color.gray : Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .disabled(isSending)
            
            ScrollView {
                Text(responseMessage)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
            }
            .frame(maxHeight: 300)
        }
        .padding()
    }
    
    func fetchUsers() -> [[String: Any]] {
        var users = [[String: Any]]()
        let query = "SELECT id, name, gender, favoriteTaste FROM User;"
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                let id = Int(sqlite3_column_int(statement, 0))
                let name = String(cString: sqlite3_column_text(statement, 1))
                let gender = String(cString: sqlite3_column_text(statement, 2))
                let favoriteTaste = String(cString: sqlite3_column_text(statement, 3))
                
                let user: [String: Any] = [
                    "id": id,
                    "name": name,
                    "gender": gender,
                    "favoriteTaste": favoriteTaste
                ]
                users.append(user)
            }
        } else {
            print("Error fetching users.")
        }
        
        sqlite3_finalize(statement)
        return users
    }
    
    func sendJSONFile() {
        guard let url = URL(string: api_request_address) else {
            responseMessage = "Invalid URL."
            return
        }
        
        let users = fetchUsers()
        guard !users.isEmpty else {
            responseMessage = "No users to send."
            return
        }
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: users, options: .prettyPrinted)
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            isSending = true
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                DispatchQueue.main.async {
                    isSending = false
                }
                
                if let error = error {
                    DispatchQueue.main.async {
                        responseMessage = "Error: \(error.localizedDescription)"
                    }
                    return
                }
                
                guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                    DispatchQueue.main.async {
                        responseMessage = "Server error."
                    }
                    return
                }
                
                if let data = data, let responseString = String(data: data, encoding: .utf8) {
                    DispatchQueue.main.async {
                        responseMessage = "Success: \(responseString)"
                    }
                } else {
                    DispatchQueue.main.async {
                        responseMessage = "No response data."
                    }
                }
            }
            
            task.resume()
        } catch {
            responseMessage = "Error creating JSON: \(error.localizedDescription)"
        }
    }
}

#Preview {
    TestView()
}

