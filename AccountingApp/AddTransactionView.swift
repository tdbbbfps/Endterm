import SwiftUI

struct AddTransactionView : View {
    @Environment(\.dismiss) var dismiss
    var on_save: () -> Void
    
    @State private var date : Date = Date()
    @State private var selected_type : TransactionType = .expense
    @State private var selected_category : TransactionCategory = .food
    @State private var note : String = ""
    @State private var amount : String = ""
    var current_categories : [TransactionCategory] {
        switch selected_type {
        case .expense:
            return TransactionCategory.expenses
        case .income:
            return TransactionCategory.incomes
        }
    }
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("交易詳情")) {
                    DatePicker("日期", selection: $date, displayedComponents: [.date, .hourAndMinute])
                    Picker("交易類型", selection: $selected_type) {
                        ForEach(TransactionType.allCases) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                    .pickerStyle(.segmented)
                    .onChange(of: selected_type) { oldValue, newValue in
                        if newValue == TransactionType.expense {
                            selected_category = .food
                        } else {
                            selected_category = .salary
                        }
                    }
                    Picker("類別", selection: $selected_category) {
                        ForEach(current_categories) { category in
                            Label(category.rawValue, systemImage: category.icon)
                                .tag(category)
                        }
                    }
                    TextField("金額", text: $amount)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.trailing)
                    TextField("註記", text: $note)
                        .multilineTextAlignment(.trailing)
                }
            }
            .navigationTitle("新增一筆")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("新增") {
                        add_transaction()
                    }
                    .disabled((Double(amount) ?? 0) <= 0)
                }
            }
        }
    }
    
    func add_transaction() {
        let input_amount = Double(amount) ?? 0
//      Check if amount is greater than 0.
        guard input_amount > 0 else {
            return
        }
        DBManager.shared.insert(
            date: date,
            category: selected_category.rawValue,
            note: note,
            amount: selected_type == .income ? input_amount : -input_amount,
            type: selected_type.rawValue
        )
        
        on_save()
        dismiss()
    }
}
