//
//  TheMovieDatabase_TCAApp.swift
//  TheMovieDatabase_TCA
//
//  Created by Koushik Dutta on 04/04/24.
//

import SwiftUI
import ComposableArchitecture

@main
struct TheMovieDatabase_TCAApp: App {
    var body: some Scene {
        WindowGroup {
            RootView(viewStore: Store(initialState: RootViewReducer.State(), reducer: {
                RootViewReducer()
            }))
        }
    }
}
