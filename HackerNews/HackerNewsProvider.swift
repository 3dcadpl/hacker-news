import Foundation
import Combine

class HackerNewsProvider {
    
    private enum Endpoint {
        
        private static let baseUrl = URL(string: "https://hacker-news.firebaseio.com/v0/")!
        
        case stories
        case story(Int)
        
        var url: URL {
            switch self {
            case .stories:
                return Endpoint.baseUrl.appendingPathComponent("newstories.json")
            case .story(let id):
                return Endpoint.baseUrl.appendingPathComponent("item/\(id).json")
            }
        }
        
    }
    private let decoder: JSONDecoder
    private let queue: DispatchQueue
    
    init(decoder: JSONDecoder = JSONDecoder(), queue: DispatchQueue = DispatchQueue(label: "api", qos: .default, attributes: .concurrent)) {
        self.decoder = decoder
        self.queue = queue
    }
    
    func getStories() -> AnyPublisher<[Story], Error> {
        URLSession.shared
            .dataTaskPublisher(for: Endpoint.stories.url)
            .map { $0.data }
            .decode(type: [Int].self, decoder: decoder)
            .filter { !$0.isEmpty }
            .flatMap { self.getStories(ids: $0) }
            .scan([]) { $0 + [$1] }
            .map { $0.sorted() }
            .eraseToAnyPublisher()
    }
    
    private func getStories(ids: [Int], limit: Int = 20) -> AnyPublisher<Story, Error> {
        let storiesIds = Array(ids.prefix(limit))
        let firstStory = getStory(id: storiesIds[0])
        return Array(storiesIds.dropFirst()).reduce(firstStory) { result, id in
            result.merge(with: getStory(id: id))
                .eraseToAnyPublisher()
        }
    }

    private func getStory(id: Int) -> AnyPublisher<Story, Error> {
        URLSession.shared
            .dataTaskPublisher(for: Endpoint.story(id).url)
            .receive(on: queue)
            .map { $0.data }
            .decode(type: StoryDto.self, decoder: decoder)
            .map { Story(id: $0.id, title: $0.title, by: $0.by, time: $0.time, since: "") }
            .catch(onError(error:))
            .eraseToAnyPublisher()
    }
    
    private func onError(error: Error) -> AnyPublisher<Story, Error> {
        print(error)
        return Empty<Story, Error>()
            .eraseToAnyPublisher()
    }
    
}


