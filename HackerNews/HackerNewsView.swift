//
//  ContentView.swift
//  HackerNews
//
//  Created by Łukasz Andrzejewski on 26/05/2021.
//

import SwiftUI

struct HackerNewsView: View {
    
    @ObservedObject
    var viewModel: HackerNewsViewModel
    
    var body: some View {
        NavigationView { 
            List {
                Section(header: Text("Top stories")) {
                    ForEach(viewModel.stories) { story in
                        VStack {
                            Text(story.title)
                                .lineLimit(2)
                                .font(.title2)
                            HStack {
                                Text(story.by)
                                    .font(.body)
                                Spacer()
                                TimeBadge(time: story.since)
                            }
                            .padding(.top)
                        }
                    }
                }
            }.navigationTitle("\(viewModel.stories.count) stories")
        }
    }
    
}

struct HackerNewsView_Previews: PreviewProvider {
    
    static var previews: some View {
        HackerNewsView(viewModel: HackerNewsViewModel(provider: HackerNewsProvider()))
    }
    
}
