import Foundation

struct News: Identifiable {
    let id: UUID
    let feed: Feed
    let title: String
    let publishDate: Date
}

