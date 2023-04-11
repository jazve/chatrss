import SwiftUI

class Article: Identifiable, ObservableObject, Codable {
    let id: String
    let title: String
    let content: String
    let publishDate: Date
    let imageURL: URL?
    let author: String
    @Published var isRead: Bool = false
    
    init(id: String, title: String, content: String, publishDate: Date, imageURL: URL?, author: String) {
        self.id = id
        self.title = title
        self.content = content
        self.publishDate = publishDate
        self.author = author
        self.imageURL = imageURL
    }
    
    // Codable conformance for the @Published property
    enum CodingKeys: String, CodingKey {
        case id, title, content, publishDate, imageURL, author, isRead
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(content, forKey: .content)
        try container.encode(publishDate, forKey: .publishDate)
        try container.encode(imageURL, forKey: .imageURL)
        try container.encode(author, forKey: .author)
        try container.encode(isRead, forKey: .isRead)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        content = try container.decode(String.self, forKey: .content)
        publishDate = try container.decode(Date.self, forKey: .publishDate)
        imageURL = try container.decode(URL?.self, forKey: .imageURL)
        author = try container.decode(String.self, forKey: .author)
        isRead = try container.decode(Bool.self, forKey: .isRead)
    }
}

