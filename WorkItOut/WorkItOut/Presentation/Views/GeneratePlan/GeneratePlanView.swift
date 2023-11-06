//
//  GeneratePlanView.swift
//  WorkItOut
//
//  Created by Jeremy Raymond on 30/10/23.
//

import SwiftUI

struct GeneratePlanView: View {
    @StateObject var vm: GeneratePlanViewModel = GeneratePlanViewModel()
    @EnvironmentObject var avm: AssessmentViewModel
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var dm: DataManager
    
    @State var finish: Bool = false
    @Binding var hasNoProfile : Bool
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Text("You are in week \(dm.profile?.currentPregnancyWeek ?? -1) of pregnancy, so we are giving you the \(dm.profile?.trimester.rawValue ?? "-1") trimester yoga plan!")
                    .padding(.horizontal)
                DayPickerView(days: dm.profile!.daysAvailable, selection: dm.profile!.daysAvailable[0])
                    .environmentObject(vm)
                ScrollViewReader(content: { (proxy: ScrollViewProxy) in
                    ScrollView {
                        VStack {
                            if dm.profile!.plan.isEmpty {
                                Text("No Plan yet")
                            }
                            else {
                                VStack(alignment: .leading) {
                                    ForEach(Array(dm.profile!.yogaPlan.yogas.enumerated()), id: \.element) { index, yoga in
                                        VStack {
                                            HStack {
                                                VStack(alignment: .leading) {
                                                    Text("Day \(index+1) - Upper Body")
                                                        .font(.title3)
                                                        .bold()
                                                    Text("\(yoga.day.getString()), \(dm.profile!.timeOfDay.getString())")
                                                        .foregroundStyle(Color.neutral3)
                                                        .font(.body)
                                                }
                                                .id(yoga.day.getInt())
                                                Spacer()
                                                Button(action: {
                                                    
                                                }, label: {
                                                    Image(systemName: "pencil")
                                                })
                                            }
                                            ForEach(Category.allCases, id: \.self) { category in
                                                if vm.checkCategory(poses: yoga.poses, category: category) {
                                                    HStack {
                                                        Text(category.rawValue)
                                                            .font(.subheadline)
                                                            .foregroundStyle(Color.neutral3)
                                                            .bold()
                                                        Rectangle()
                                                            .frame(height: 0.5)
                                                            .foregroundStyle(Color.neutral6)
                                                    }
                                                }
                                                ForEach(yoga.poses, id: \.self) { pose in
                                                    if pose.category == category {
                                                        YogaCardView(name: pose.name)
                                                    }
                                                }
                                            }
                                        }
                                        .padding()
                                        .background(.white)
                                        .padding(.bottom)
                                    }
                                }
                                .background(Color.background)
                            }
                        }
                    }
                    .onChange(of: vm.scrollTarget) { target in
                        print("Changed")
                        if let target = target {
                            vm.scrollTarget = nil
                            
                            withAnimation {
                                print("called")
                                proxy.scrollTo(target, anchor: .center)
                            }
                        }
                    }
                    
                })
                VStack {
                    ButtonComponent(title: "Finish") {
                        Task{
                            if let prof = dm.profile {
                                await vm.addProfileToCoreData(profile: prof, moc: moc) // TODO: buang seru
                            }
                        }
                        finish.toggle()
                        hasNoProfile.toggle()
                    }
                    .padding(.horizontal)
                }
                .navigationTitle("Workout Plan for Beginner")
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button(action: {
                            avm.resetTimer()
                            avm.state = .chooseWeek
                            self.presentationMode.wrappedValue.dismiss()
                        }, label: {
                            Image(systemName: "xmark")
                                .font(.body)
                                .padding(8)
                                .background(Color.background.opacity(0.5))
                                .clipShape(.circle)
                        })
                    }
                }
                .navigationDestination(isPresented: $finish, destination: {
                    if let prof = dm.profile {
                        HomeView(vm: HomeViewModel(profile: dm.profile!)) // TODO: buang seru
                    }
                })
                .navigationBarBackButtonHidden()
            }
//            .ignoresSafeArea()
        }
    }
}

//#Preview {
//    GeneratePlanView(dm: DataManager())
//}
