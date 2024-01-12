//
//  BookHarbourApp.swift
//  BookHarbour
//
//  Created by Summer Gasaway on 1/2/24.
//

import SwiftUI

@main
struct BookHarbourApp: App {
    @StateObject private var appState = AppState()
    @StateObject private var currentBook = CurrentBook()
    
    @Environment(\.scenePhase) var scenePhase
    
    let dataController = DataController.shared
    
    var body: some Scene {
        WindowGroup {
            if appState.showReaderView{
                ReaderView()
                    .environmentObject(appState)
                    .environmentObject(currentBook)
            }
            else{
                MainHomeView()
                    .environment(\.managedObjectContext, dataController.container.viewContext)
                    .environmentObject(appState)
                    .environmentObject(currentBook)                
            }
        }
    }
}

