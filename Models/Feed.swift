import Foundation

class Feed: Identifiable, ObservableObject, Codable {
    let id: UUID
    let title: String
    let url: URL
    let iconURL: URL?
    let articles: [Article]
    
    init(title: String, url: URL, iconURL: URL?, articles: [Article]) {
        self.id = UUID()
        self.title = title
        self.url = url
        self.iconURL = iconURL
        self.articles = articles
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        url = try container.decode(URL.self, forKey: .url)
        iconURL = try container.decodeIfPresent(URL.self, forKey: .iconURL)
        articles = try container.decode([Article].self, forKey: .articles)
    }
    
    // 添加自定义的 encode(to encoder: Encoder) 方法
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(url, forKey: .url)
        try container.encodeIfPresent(iconURL, forKey: .iconURL)
        try container.encode(articles, forKey: .articles)
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, title, url, iconURL, articles
    }
}

