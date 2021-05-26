import Foundation

struct StoryDto: Decodable {
    
    let id: Int
    let title: String
    let by: String
    let time: TimeInterval
    let url: String
    
}
