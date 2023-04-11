import SwiftUI

struct BubbleView: View {
    
    let article: Article
    let maxWidth: CGFloat
    
    // 添加一个占位符图像
    var placeholder: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(Color(.white))
            .opacity(1)
            .frame(width: 48 ,height: 48)
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            
            //             文章图片
            if let imageURL = article.imageURL {
                AsyncImage(url: imageURL) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 48, height: 48)
                        .cornerRadius(10)
                } placeholder: {
                    placeholder
                }
                
            } else {
                placeholder
            }
            
            
            // 气泡左侧的三角形
           // TriangleShape()
               // .fill(Color(.systemGray6))
               // .frame(width: 16, height: 16)
                //.padding(.trailing, -15)
              //  .rotationEffect(.degrees(35))
            
            // 文章标题
            VStack(alignment: .leading, spacing: 10) {
                Text(article.title)
                    .font(.body)
                //                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)
            }
            .padding(EdgeInsets(top: 15, leading: 15, bottom: 15, trailing: 15))
            .background(Color(.systemGray6))
            .cornerRadius(16)
            .frame(maxWidth: maxWidth*0.8, alignment: .leading)
        }
       Spacer()
//        .colorScheme(.light)
    }
}

struct TriangleShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}


enum Filter: String, CaseIterable, Identifiable {
    case all = "全部"
    case unread = "未读"
    case read = "已读"
    
    var id: String { self.rawValue }
}



struct FeedDetailView: View {
    
    @StateObject var feed: Feed
    @State private var showArticleView = false
    @State private var selectedArticleViewModel: ArticleViewModel?
    @State private var filter: Filter = .all
    @State private var searchText: String = ""
    
    var filteredArticles: [Article] {
        feed.articles.filter { article in
            switch filter {
            case .all:
                return true
            case .unread:
                return !article.isRead
            case .read:
                return article.isRead
            }
        }
    }
    
    var body: some View {
        VStack{
            
            
            GeometryReader { geometry in
                ScrollViewReader { scrollViewProxy in
                    ScrollView {
                        VStack(alignment: .leading, spacing: 15) {
                            ForEach(filteredArticles, id: \.id) { article in
                                VStack(alignment: .leading, spacing: 5) {
                                   Text("\(article.publishDate, formatter: dateFormatter)")
                                      .font(.footnote)
                                       .foregroundColor(.gray)
                                       .padding(.vertical, 25)
                                       .frame(maxWidth: .infinity, alignment: .center)
                                    
                                    HStack {
                                        BubbleView(article: article, maxWidth: geometry.size.width * 0.8)
                                            .onTapGesture {
                                                if let index = feed.articles.firstIndex(where: { $0.id == article.id }) {
                                                    selectedArticleViewModel = ArticleViewModel(articles: feed.articles, currentIndex: index)
                                                    article.isRead = true // 设置为已读
                                                    showArticleView.toggle()
                                                }
                                            }

                                    }
                                }
                                .id(article.id)
                            }
                        }
                        .padding(20)
                    }
                    .navigationBarTitle(feed.title, displayMode: .inline)
                    .sheet(item: $selectedArticleViewModel) { viewModel in
                        ArticleView(viewModel: viewModel)
                            .onDisappear {
                                selectedArticleViewModel = nil
                            }
                    }
                }
            }
            
//            HStack {
//
//                // 底部操作栏
//
                Picker(selection: $filter, label: Text("")) {
                    ForEach(Filter.allCases) { filter in
                        Text(filter.rawValue).tag(filter)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .frame(height: 60)
                .padding(.horizontal, 5)
//
////                // 搜索框
////                HStack {
////                    TextField("搜索文章", text: $searchText)
////                        .padding(7)
////                        .padding(.horizontal, 25)
////                        .background(Color(.systemGray6))
////                        .cornerRadius(8)
////                        .overlay(
////                            HStack {
////                                Image(systemName: "magnifyingglass")
////                                    .foregroundColor(.gray)
////                                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
////                                    .padding(.leading, 8)
////                                Button(action: {
////                                    self.searchText = ""
////                                }) {
////                                    Image(systemName: "xmark.circle.fill")
////                                        .foregroundColor(.gray)
////                                        .padding(.trailing, 8)
////                                }
////                            }
////                        )
////                }
//            }
//            .padding(.horizontal)
            
            
            }

    }
    
    // 日期格式化器
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
    
    // 将日期划分为时间段
    private func timeSegment(for date: Date) -> Int {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        return hour / 1
    }
}
