import SwiftUI

struct LatestNewsView: View {
    @StateObject private var viewModel = LatestNewsViewModel()

    var body: some View {
        List(viewModel.articles) { article in
            HStack(alignment: .top) {
                Image(systemName: "newspaper")
                    .foregroundColor(.blue)

                VStack(alignment: .leading) {
                    Text(article.title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text(article.title)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
//                    Text(article.publishDate)
//                        .font(.footnote)
//                        .foregroundColor(.gray)
                }

                Spacer()

//                if article.unreadCount > 0 {
//                    Text("\(article.unreadCount)")
//                        .font(.caption)
//                        .foregroundColor(.white)
//                        .padding(6)
//                        .background(Circle().fill(Color.red))
//                }
            }
        }
        .onAppear {
            viewModel.refresh()
        }
//        .onPullToRefresh(isRefreshing: $viewModel.isRefreshing) {
//            viewModel.refresh()
//        }
        .navigationBarTitle("Latest News")
        .navigationBarItems(trailing: Button(action: {
            viewModel.refresh()
        }, label: {
            Image(systemName: "arrow.clockwise")
                .imageScale(.large)
        }))
    }
}

