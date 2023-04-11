import Foundation

class LatestNewsViewModel: ObservableObject {
    @Published var articles: [Article] = []
    @Published var isRefreshing: Bool = false

    private let feedService = FeedService()

    func refresh() {
        isRefreshing = true

        feedService.getFeeds { [weak self] result in
            switch result {
            case .success(let feeds):
                self?.fetchLatestNews(for: feeds)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    private func fetchLatestNews(for feeds: [Feed]) {
        var allArticles: [Article] = []
        let dispatchGroup = DispatchGroup()

        for feed in feeds {
            dispatchGroup.enter()

            feedService.fetchLatestNews(for: feed) { result in
                switch result {
                case .success(let articles):
                    allArticles.append(contentsOf: articles)
                case .failure(let error):
                    print(error.localizedDescription)
                }

                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: .main) {
            let sortedArticles = allArticles.sorted(by: { $0.publishDate > $1.publishDate })
            self.articles = sortedArticles
            self.isRefreshing = false
        }
    }
}

