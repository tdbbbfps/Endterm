import Foundation
import SQLite3

struct Transaction : Identifiable {
    var id : Int32
    var date : Date
    var category : String
    var note : String
    var amount : Double
    var type : String
}

class DBManager {
    static let shared = DBManager()
    var db: OpaquePointer?
    let dbName = "db.sqlite"
    
    private init() {
        openDatabase()
        createTable()
    }
    
    func openDatabase() {
        let fileURL = try! FileManager.default
            .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(dbName)
        print(fileURL)
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("無法開啟資料庫")
        }
    }
    
    func createTable() {
        let createTableString = """
        CREATE TABLE IF NOT EXISTS Transactions(
        Id INTEGER PRIMARY KEY AUTOINCREMENT,
        Date REAL,
        Category TEXT,
        Note TEXT,
        Amount REAL,
        Type Text);
        """
        var createTableStatement: OpaquePointer?
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("資料表建立成功")
            } else {
                print("資料表建立失敗")
            }
        }
        sqlite3_finalize(createTableStatement)
    }

    func insert(date : Date, category : String, note : String, amount : Double, type : String) {
        let insertStatementString = "INSERT INTO Transactions (Date, Category, Note, Amount, Type) VALUES (?, ?, ?, ?, ?);"
        var insertStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_double(insertStatement, 1, date.timeIntervalSince1970)
            sqlite3_bind_text(insertStatement, 2, (category as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, (note as NSString).utf8String, -1, nil)
            sqlite3_bind_double(insertStatement, 4, amount)
            sqlite3_bind_text(insertStatement, 5, (type as NSString).utf8String, -1, nil)
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("新增成功")
            } else {
                print("新增失敗")
            }
        } else {
            print("schemas don't match models.")
        }
        sqlite3_finalize(insertStatement)
    }
    
    func read() -> [Transaction] {
        let queryStatementString = "SELECT * FROM Transactions ORDER BY Date DESC;"
        var queryStatement: OpaquePointer?
        var transactions: [Transaction] = []
        
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
                let dateVal = sqlite3_column_double(queryStatement, 1)
                let category = String(cString: sqlite3_column_text(queryStatement, 2))
                let note = String(cString: sqlite3_column_text(queryStatement, 3))
                let amount = sqlite3_column_double(queryStatement, 4)
                let type = String(cString: sqlite3_column_text(queryStatement, 5))
                let date = Date(timeIntervalSince1970: dateVal)
                transactions.append(Transaction(id: id, date: date, category: category, note: note, amount: amount, type: type))
            }
        }
        sqlite3_finalize(queryStatement)
        return transactions
    }
    
    func delete(id: Int32) {
        let deleteStatementString = "DELETE FROM Transactions WHERE Id = ?;"
        var deleteStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, deleteStatementString, -1, &deleteStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(deleteStatement, 1, id)
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("刪除成功")
            } else {
                print("刪除失敗")
            }
        }
        sqlite3_finalize(deleteStatement)
    }
}
