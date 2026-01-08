import SwiftUI
import Charts

struct ContentView: View {
    @State private var transactions: [Transaction] = []
    @State private var show_add_view: Bool = false
    
    var total_incomes: Double {
        transactions.filter { $0.amount > 0 }.reduce(0) { $0 + $1.amount }
    }
    var total_expenses: Double {
        abs(transactions.filter { $0.amount <= 0 }.reduce(0) { $0 + $1.amount })
    }
    var balance: Double { total_incomes - total_expenses }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.4, green: 0.4, blue: 0.4)
                    .ignoresSafeArea()
                GeometryReader { geometry in
                    VStack(spacing: 0) {
                        ZStack {
                            Color(red: 0.3, green: 0.3, blue: 0.3)
//                      Balance pie chart
                            Chart(transactions) { item in
                                SectorMark(
                                    angle: .value("Amount", abs(item.amount)),
                                    innerRadius: .ratio(0.75)
                                )
                                .foregroundStyle(item.type == "支出" ? .red : .green)
                            }
                            .chartBackground { proxy in
                                GeometryReader { geo in
                                    VStack(spacing: 4) {
                                        Label("結餘", systemImage: "dollarsign.circle.fill")
                                            .font(.headline)
                                            .foregroundColor(Color(red: 0.82, green: 0.68, blue: 0.21))
                                        Text(balance > 0 ? "$+\(Int(balance))" : "$\(Int(balance))")
                                            .font(.title3.bold())
                                            .foregroundColor(balance >= 0 ? .green : .red)
                                    }
                                    .position(x: geo.size.width / 2, y: geo.size.height / 2)
                                }
                            }
                            .padding()
                        }
                        .frame(height: geometry.size.height * 0.3)
//                      Transaction records container
                        ZStack {
//                          Background tooltip if transactions is empty.
                            if transactions.isEmpty {
                                VStack(spacing: 12) {
                                    Image(systemName: "list.bullet.clipboard")
                                        .font(.system(size: 48))
                                        .foregroundColor(.gray.opacity(0.5))
                                    Text("按下按鈕新增記錄")
                                        .foregroundColor(.gray)
                                }
                            } else {
                                ScrollView {
                                    LazyVStack(spacing: 10) {
                                        ForEach(transactions) { item in
                                            TransactionRecordView(transaction: item) {
                                                delete_record(id: item.id)
                                            }
                                        }
                                    }
                                    .padding()
                                    .padding(.bottom, 80)
                                }
                            }
                        }
                        .frame(height: geometry.size.height * 0.7)
                    }
                }
                .navigationTitle("陽春麵記帳APP")
                
                .navigationBarTitleDisplayMode(.inline)
                .toolbarBackground(Color(red: 0.2, green: 0.2, blue: 0.2), for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                .toolbarColorScheme(.dark, for: .navigationBar)
                .overlay(alignment: .bottom) {
                    Button {
                        show_add_view = true
                    } label: {
                        Image(systemName: "plus")
                            .font(.title.weight(.semibold))
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .clipShape(Circle())
                            .shadow(radius: 4, y: 2)
                            .overlay(Circle().stroke(Color.white, lineWidth: 1))
                    }
                    .padding(.bottom, 20)
                }
                .onAppear {
                    refresh_data()
                }
                .sheet(isPresented: $show_add_view) {
                    AddTransactionView {
                        refresh_data()
                    }
                }
            }
        }
    }
//  Read data from database
    func refresh_data() {
        transactions = DBManager.shared.read()
    }
//  Delete data from database
    func delete_record(id: Int32) {
        DBManager.shared.delete(id: id)
        refresh_data()
    }
}

#Preview {
    ContentView()
}

