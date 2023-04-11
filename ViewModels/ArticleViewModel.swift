import Foundation
import Combine
import SwiftUI

class ArticleViewModel: ObservableObject, Identifiable {
    @Published private(set) var articles: [Article]
    @Published private(set) var currentIndex: Int
    
    // 检测 ScrollView 是否可以滚动
    @Published var canScroll: Bool = false
    
    var currentArticle: Article? {
        guard !articles.isEmpty, currentIndex >= 0, currentIndex < articles.count else {
            return nil
        }
        return articles[currentIndex]
    }
    
    init(articles: [Article], currentIndex: Int = 0) {
        self.articles = articles
        self.currentIndex = currentIndex
    }
    
    func previousArticle() {
        if currentIndex > 0 {
            currentIndex -= 1
        }
    }
    
    func nextArticle() {
        if currentIndex < articles.count - 1 {
            currentIndex += 1
        }
    }
}

