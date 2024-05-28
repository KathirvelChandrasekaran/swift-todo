//
//  TodoSwiftApp.swift
//  TodoSwift
//
//  Created by kathirvel.chandrasekaran on 12/05/24.
//

import SwiftUI

@main
struct TodoSwiftApp: App {
    @State var listViewModel: ListViewModel = ListViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ListView()
            }
            .environmentObject(listViewModel)
        }
    }
}
