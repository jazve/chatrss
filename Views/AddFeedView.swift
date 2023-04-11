import SwiftUI

struct AddFeedView: View {
    @State private var feedURL = ""
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var feedViewModel: FeedViewModel
    
    // 添加订阅源页面
    var body: some View {
        NavigationView {
            Form {
                // 输入订阅源URL
                Section(header: Text("输入订阅源URL")) {
                    TextField("", text: $feedURL)
                        .keyboardType(.URL)
                        .autocapitalization(.none)
                }
                
                // 提交按钮
                Section {
                    Button(action: {
                        if let url = URL(string: feedURL) {
                            feedViewModel.addFeed(url: url) // 更改这里
                            presentationMode.wrappedValue.dismiss()
                        }
                    }) {
                        Text("提交")
                    }
                    .disabled(feedURL.isEmpty)
                }
            }
            .navigationBarTitle("添加订阅源")
            .navigationBarItems(trailing: Button("关闭") {
                // 在这里添加保存设置的逻辑
                
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

