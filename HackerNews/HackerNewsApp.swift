//
//  HackerNewsApp.swift
//  HackerNews
//
//  Created by Łukasz Andrzejewski on 26/05/2021.
//

import SwiftUI

@main
struct HackerNewsApp: App {
    var body: some Scene {
        WindowGroup {
            HackerNewsView(viewModel: HackerNewsViewModel(provider: HackerNewsProvider()))
        }
    }
}
