import Foundation
// Define transaction's type.
enum TransactionType : String, CaseIterable, Identifiable {
    var id : String {self.rawValue}
    case expense = "支出"
    case income = "收入"
}
// Define transaction's category and icon.
enum TransactionCategory: String, CaseIterable, Identifiable {
    var id : String {self.rawValue}

    case food = "飲食"
    case transport = "交通"
    case entertainment = "娛樂"
    case shopping = "購物"
    case other = "其他"
    
    case salary = "薪水"
    case bonus = "獎金"
    case investment = "投資"
    case random = "撿到"

    var icon: String {
        switch self {
        case .food: return "fork.knife"
        case .transport: return "tram.fill"
        case .entertainment: return "gamecontroller.fill"
        case .shopping: return "cart.fill"
        case .other: return "ellipsis.circle"
        case .salary: return "banknote.fill"
        case .bonus: return "gift.fill"
        case .investment: return "chart.line.uptrend.xyaxis"
        case .random: return "laurel.leading"
        }
    }

    var type : TransactionType {
        switch self {
        case .food, .transport, .entertainment, .shopping, .other:
            return .expense
        case .salary, .bonus, .investment, .random:
            return .income
        }
    }

    static var expenses : [TransactionCategory] {
        self.allCases.filter{$0.type == .expense}
    }
    static var incomes : [TransactionCategory] {
        self.allCases.filter{$0.type == .income}
    }
    
}
