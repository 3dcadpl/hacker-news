import Foundation
import Combine

class HackerNewsViewModel: ObservableObject {
    
    @Published
    var stories: [Story] = []
    
    private let provider: HackerNewsProvider
    private var formatter = RelativeDateTimeFormatter()
    private var subscriptions = Set<AnyCancellable>()
    
    init(provider: HackerNewsProvider) {
        self.provider = provider
        Timer.publish(every: 5, on: .main, in: .common)
            .autoconnect()
            .sink(receiveValue: time(storyTime:))
            .store(in: &subscriptions)
        refresh()
    }
    
    func refresh() {
        provider.getStories()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { print($0) }) { self.stories = $0.map { self.updateTime(story: $0, time: Date()) } }
            .store(in: &subscriptions)
    }
    
    func time(storyTime: Date) {
        stories = stories.map { updateTime(story: $0, time: storyTime) }
    }
    
    private func updateTime(story: Story, time: Date) -> Story {
        Story(id: story.id, title: story.title, by: story.by, time: story.time, since: formatter.localizedString(fromTimeInterval: story.time - time.timeIntervalSince1970))
    }

}
