//
//  HistoryView.swift
//  WorkItOut
//
//  Created by Kevin Dallian on 02/11/23.
//

import SwiftUI

struct HistoryView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var vm : HistoryViewModel = HistoryViewModel()
    @State var showSheet = false
    var body: some View {
        ZStack(alignment: .top){
            Image("historyBackground")
                .ignoresSafeArea()
            ScrollView{
                LazyVStack(spacing: 20){
                    if !vm.historiesWithDate.isEmpty{
                        ForEach(vm.historiesWithDate.keys.sorted(by: {$0 > $1}), id: \.self){ date in
                            HistorySection(date: vm.historiesWithDate[date]!.first?.executionDate ?? Date.distantFuture, histories: vm.historiesWithDate[date]!, showSheet: $showSheet, currentHistory: $vm.currentHistory)
                        }
                    }
                    else{
                        Text("No History to show")
                    }
                }
                .padding(.vertical, 20)
                .toolbar{
                    ToolbarItem(placement: .topBarLeading) {
                        Button { self.presentationMode.wrappedValue.dismiss() }
                    label: {
                        ZStack{
                            Circle()
                                .tint(.grayBorder.opacity(0.15))
                                .frame(width: 40)
                            Image(systemName: "arrow.left")
                                .font(.system(size: 10))
                                .bold()
                        }
                    }
                    }
                }
                .sheet(isPresented: $showSheet){
                    if let history = vm.currentHistory{
                        HistorySheet(history: history)
                            .presentationDragIndicator(.visible)
                    }
                }
                
            }
        }
        .navigationTitle("History")
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    NavigationStack{
        HistoryView()
    }
}
