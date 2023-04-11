import Foundation

class FeedService {
    // 处理与订阅源相关的操作，例如：获取订阅源数据，更新订阅源等。

    private let storageKey = "feeds"
    private let userDefaults = UserDefaults.standard
    
    func getFeeds(completion: @escaping (Result<[Feed], Error>) -> Void) {
        // 在此实现从服务器或本地获取订阅源数据的逻辑
        DispatchQueue.global().async {
            if let data = self.userDefaults.data(forKey: self.storageKey) {
                do {
                    let feeds = try JSONDecoder().decode([Feed].self, from: data)
                    completion(.success(feeds))
                } catch {
                    completion(.failure(error))
                }
            } else {
                completion(.success([]))
            }
        }
    }
    
    func addFeed(feed: Feed, completion: @escaping (Result<Feed, Error>) -> Void) {
        // 在此实现添加订阅源数据的逻辑
        getFeeds { result in
            switch result {
            case .success(var feeds):
                feeds.append(feed)
                do {
                    let data = try JSONEncoder().encode(feeds)
                    self.userDefaults.set(data, forKey: self.storageKey)
                    completion(.success(feed))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func updateFeed(feed: Feed, completion: @escaping (Result<Feed, Error>) -> Void) {
        // 在此实现更新订阅源数据的逻辑
        getFeeds { result in
            switch result {
            case .success(var feeds):
                if let index = feeds.firstIndex(where: { $0.id == feed.id }) {
                    feeds[index] = feed
                    do {
                        let data = try JSONEncoder().encode(feeds)
                        self.userDefaults.set(data, forKey: self.storageKey)
                        completion(.success(feed))
                    } catch {
                        completion(.failure(error))
                    }
                } else {
                    completion(.failure(NSError(domain: "FeedService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Feed not found"])))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // 根据需要添加其他与订阅源相关的方法
    func fetchLatestNews(for feed: Feed, completion: @escaping (Result<[Article], Error>) -> Void) {
        // Fetch latest news for the specified feed from server and call completion with the result
    }
    


}
