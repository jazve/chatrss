import Foundation
import Combine
import SwiftUI

class FeedViewModel: ObservableObject {
    @Published var feeds: [Feed] = []
    private var cancellables: Set<AnyCancellable> = []
    
    func loadFeeds() {
        // 在这里实现加载订阅源列表的逻辑，例如从本地存储或网络请求
        
        // 如果没有订阅源，添加默认订阅源
        if feeds.isEmpty {
            if let defaultFeedURL = URL(string: "https://www.ithome.com/rss") {
                addFeed(url: defaultFeedURL)
            }
        }
    }
    
    func addFeed(url: URL) {
        let feedParser = FeedParser()
        
        feedParser.parseFeed(url: url)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        print("Error adding feed: \(error)")
                    }
                },
                receiveValue: { feed in
                    self.feeds.append(feed)
                    // 在这里实现保存订阅源列表的逻辑，例如保存到本地存储
                }
            )
            .store(in: &cancellables)
    }
    
    func deleteFeed(at offsets: IndexSet) {
        // 在这里实现删除订阅源的逻辑，包括从数据结构中删除和更新存储
        feeds.remove(atOffsets: offsets)
    }
    
    // 当 ViewModel 不再使用时取消订阅
    deinit {
        for cancellable in cancellables {
            cancellable.cancel()
        }
    }
}
