import Foundation

struct Story: Identifiable, Comparable {
    
    let id: Int
    let title: String
    let by: String
    let time: TimeInterval
    let since: String
    
    static func < (lhs: Story, rhs: Story) -> Bool {
        lhs.time > rhs.time
    }
    
}
