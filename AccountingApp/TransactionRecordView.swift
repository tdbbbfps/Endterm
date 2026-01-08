import SwiftUI

struct TransactionRecordView: View {
    let transaction: Transaction
    let on_delete: () -> Void
    
    var body: some View {
        HStack {
//          Transaction category, note and date.
            VStack(alignment: .leading, spacing: 4) {
                Text(transaction.category)
                    .font(.headline)
                    .foregroundColor(.primary)
                Text(transaction.note.isEmpty ? "" : transaction.note)
                        .font(.caption)
                        .foregroundColor(.gray)
                Text(transaction.date.formatted(date: .numeric, time: .shortened))
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            Spacer()
            HStack(spacing: 16) {
//              Transaction amount
                Text(transaction.amount >= 0 ? "$+\(Int(transaction.amount))" : "$\(Int(transaction.amount))")
                    .font(.headline)
                    .bold()
                    .foregroundColor(transaction.amount >= 0 ? .green : .red)
//              Delete record button
                Button(action: on_delete) {
                    Image(systemName: "trash.fill")
                        .foregroundColor(.white)
                        .padding(8)
                        .background(Color.red)
                        .clipShape(Circle())
                }

                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.1), lineWidth: 1)
        )
    }
}
