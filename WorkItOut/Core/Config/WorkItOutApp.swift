//
//  WorkItOutApp.swift
//  WorkItOut
//
//  Created by Kevin Dallian on 20/10/23.
//

import SwiftUI
import FirebaseCore
import CoreData

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct WorkItOutApp: App {
    @StateObject var coreDataManager = CoreDataManager()
    @StateObject var dm: DataManager = DataManager()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
//            TestFetchFirebase()
//            HistoryView()
//            ProfileView()
            ContentView()
                .environment(\.managedObjectContext, coreDataManager.container.viewContext)
                .environmentObject(dm)
        }
    }
}


