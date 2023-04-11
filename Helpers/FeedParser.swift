import Foundation
import Combine
import FeedKit

class FeedParser {
    func parseFeed(url: URL) -> AnyPublisher<Feed, Error> {
        return Future<Feed, Error> { promise in
            let parser = FeedKit.FeedParser(URL: url)
            
            parser.parseAsync { result in
                switch result {
                case .success(let feed):
                    if let rssFeed = feed.rssFeed {
                        let items = rssFeed.items ?? []
                        let articles = items.compactMap { item -> Article? in
                            guard let title = item.title,
                                  let link = item.link,
                                  let url = URL(string: link) else {
                                return nil
                            }
                            
                            let id = UUID().uuidString
                            let author = item.author ?? "未知"
                            
                            let content = item.description ?? ""
                            let publishDate = item.pubDate ?? Date()
                            var imageURL: URL?
                            
                            // Check the enclosure tag
                            if let enclosure = item.enclosure, enclosure.attributes?.type?.hasPrefix("image/") == true, let imageURLString = enclosure.attributes?.url {
                                imageURL = URL(string: imageURLString)
                            }
                            
                            // Check the media:content tag
                            if imageURL == nil, let mediaContent = item.media?.mediaContents?.first(where: { $0.attributes?.type?.hasPrefix("image/") == true }), let imageURLString = mediaContent.attributes?.url {
                                imageURL = URL(string: imageURLString)
                            }
                            
                            // Check the content for an img tag
                            if imageURL == nil, let imgTagRange = content.range(of: "<img[^>]+src=\"([^\"]+)\"", options: .regularExpression), let srcAttributeRange = content[imgTagRange].range(of: "src=\"([^\"]+)\"", options: .regularExpression) {
                                let imageURLString = String(content[srcAttributeRange].dropFirst(5).dropLast())
                                imageURL = URL(string: imageURLString)
                            }
                            
                            return Article(id: UUID().uuidString, title: title, content: content, publishDate: publishDate, imageURL: imageURL, author: author)
                        }
                        
                        let feed = Feed(title: rssFeed.title ?? "未知", url: url, iconURL: nil, articles: articles)
                        promise(.success(feed))
                    } else {
                        promise(.failure(FeedParserError.invalidFeedFormat))
                    }
                    
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    enum FeedParserError: Error {
        case invalidFeedFormat
    }
}
