import Foundation

struct Game: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var opponent: String
    var score: String
    var date: Date = Date()
}
