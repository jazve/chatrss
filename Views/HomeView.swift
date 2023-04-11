import SwiftUI

struct HomeView: View {
    @ObservedObject private var feedViewModel = FeedViewModel()
    @State private var selectedTab: Tab = .feeds
    
    enum Tab {
        case feeds, latestNews, discover, settings
    }
    
    var body: some View {
        NavigationView {
            VStack {
                switch selectedTab {
                case .feeds:
                    feedsList
                case .latestNews:
                    LatestNewsView()
                case .discover:
                    Text("发现页面")
                        .font(.largeTitle)
                case .settings:
                    SettingsView()
                }
                Spacer()
                tabBar
            }
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarHidden(true)
        }
    }
    
    private var feedsList: some View {
        List {
            ForEach(feedViewModel.feeds) { feed in
                NavigationLink(destination: FeedDetailView(feed: feed)) {
                    HStack {
                        if let iconURL = feed.iconURL {
                            AsyncImage(url: iconURL) { image in
                                image.resizable()
                                    .frame(width: 32, height: 32)
                                    .cornerRadius(5)
                            } placeholder: {
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(Color(.systemGray6))
                                    .frame(width: 32, height: 32)
                            }
                            .padding(.trailing, 10)
                        }
                        
                        Text(feed.title)
                    }
                }
                .padding(.vertical, 10)
            }
        }
        .onAppear {
            feedViewModel.loadFeeds()
        }
    }
    
    

    
    private var tabBar: some View {
        TabBar(selectedTab: $selectedTab, tabs: [
            .init(title: "订阅列表", imageName: "list.bullet", tag: .feeds),
            .init(title: "最新消息", imageName: "newspaper", tag: .latestNews),
            .init(title: "发现", imageName: "magnifyingglass", tag: .discover),
            .init(title: "设置", imageName: "gear", tag: .settings)
        ])
    }
}

struct TabBar: View {
    @Binding var selectedTab: HomeView.Tab
    let tabs: [TabBarItem]
    
    var body: some View {
        HStack {
            ForEach(tabs) { tab in
                Button(action: {
                    selectedTab = tab.tag
                }) {
                    VStack {
                        Image(systemName: tab.imageName)
//                        Text(tab.title)
                    }
                }
                .foregroundColor(selectedTab == tab.tag ? .accentColor : .primary)
                .frame(maxWidth: .infinity)
            }
        }
        .padding()
        .background(Color(.systemBackground))
    }
}

struct TabBarItem: Identifiable {
    let id = UUID()
    let title: String
    let imageName: String
    let tag: HomeView.Tab
}

